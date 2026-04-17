# frozen_string_literal: true

# В enum модели нет отдельного rank для подсемейств/триб,
# поэтому строки с `п/сем.` и семейными суффиксами вроде `-inae` / `-ini`
# сохраняются как rank: :family.
#
# Также несколько строк без префиксов нормализуются вручную:
# - Crustacea -> :tclass
# - Hydrachnidia n.det. -> :subclass
# - Copepoda n.det. -> :subclass
# - Nematoda n.det. -> :phylum
#
# Если хочешь полностью пересевать эту таблицу, можешь предварительно раскомментировать:
# Taxon.delete_all

raw_taxons = <<~TEXT
  тип Porifera
  сем. Spongillidae n.det
  тип Cnidaria
  класс Hydrozoa
  сем. Hydridae
  Hydra sp. (o-b) **
  тип Nematoda
  Nematoda n.det.
  тип Annelida
  п/класс Oligochaeta sp.
  сем. Naididae sp.
  Chaetogaster sp.
  Ophidonais serpentina (Müller, 1774)?
  Stylaria lacustris (Linnaeus, 1767) (b)
  Ripistes parasita (Schmidt, 1847)
  Dero sp.
  сем. Tubificidae  sp.
  Tubifex ignotus (Stolc, 1886)
  Tubifex newaensis (Michaelsen, 1902)
  сем. Enchytraeidae n.det.
  п/класс Hirudinea
  сем. Glossiphoniidae sp. (juv.)
  Batracobdella paludosa (Carena, 1824)
  Helobdella stagnalis  (Linnaeus, 1758)
  Hemiclepsis marginata O.F. Müller, 1774
  Theromyzon tessulatum (Müller, 1774)
  сем. Erpobdellidae
  Erpobdella sp.
  тип Bryozoa
  Paludicella articulata Ehrenberg, 1810
  Cristatella mucedo Cuvier, 1798
  сем. Plumatellidae sp.
  Plumatella sp.
  тип Mollusca
  класс Bivalvia
  сем. Unionidae sp. (juv.)
  Anodonta (Colletopterum) sp.
  Unio (Unio) tumidus (Philipsson in Retzius, 1788)
  Unio (Unio) pictorum (Linnaeus, 1758)
  сем. Sphaeriidae sp.
  Musculium sp.
  Sphaerium corneum (Linnaeus, 1758)
  Sphaerium (Nucleocyclas) nucleus (Studer, 1820)
  Sphaerium sp.
  Euglesa (Henslowiana) sp.
  Euglesa sp.
  класс Gastropoda
  сем. Viviparidae
  Viviparus (Contectiana) contectus (Millet, 1813)
  сем. Valvatidae
  Valvata (Valvata) cristata Müller, 1774
  Valvata (Atropidina) pulchella Studer, 1820 sensu Chernogorenko et Starobogatov, 1987 (=Cincinna studeri Boeters et Falkner, 1998)
  Valvata (Sibirovalvata) sp.
  Valvata (Atropidina) sp.
  сем. Bithyniidae
  Bithynia (Opistorchophorus) troschelii (Paasch, 1842)
  Bithynia (Bithynia) tentaculata (Linnaeus, 1758)(b)
  Bithynia (Codiella) leachii (Sheppard, 1823)(o-b)
  сем. Acroloxidae
  Acroloxus (Acroloxus) lacustris (Linnaeus, 1758) (o-b)
  сем. Lymnaeidae
  Stagnicola (Stagnicola) palustris (O.F. Müller, 1774)
  Radix (Radix) parapsilia Vinarski et Glöer, 2009
  Radix sp.  juv.
  Galba (Galba) truncatula (O.F. Müller, 1774)
  сем. Planorbidae
  Planorbarius corneus (Linnaeus, 1758) (b)
  Armiger crista (Linnaeus, 1758) (o)
  Lamorbis riparius (Westerlund, 1865)
  Hippeutis complanatus (Linnaeus, 1758)
  Segmentina nitida (O.F. Müller, 1774)
  Planorbis planorbis (Linnaeus, 1758) (b)
  Anisus (Disculifer) vortex (Linnaeus, 1758)
  Bathyomphalus crassus (Da Costa, 1778)
  Gyraulus (Gyraulus) albus (O.F. Müller, 1774)
  Gyraulus sp.
  тип Arthropoda
  класс Arachnida
  п/отряд Hydrachnidia n.det.
  класс Crustacea
  п/класс Cladocera n.det.
  класс Copepoda n.det.
  п/класс Branchiura
  сем. Argulidae
  Argulus  sp.
  отряд Isopoda
  сем. Asellidae
  Asellus aquaticus Linnaeus, 1758  (a)
  класс Insecta
  отряд Ephemeroptera
  сем. Baetidae
  Cloeon diptrerum Linnaeus, 1761 (o-a)
  Cloeon sp. (juv.)
  сем. Caenidae
  Caenis robusta Eaton, 1884
  C. horaria (Linnaeus, 1758) (o)
  C. laceta (Burmeister, 1839)
  Caenis sp. (juv.)
  отряд Odonata
  сем. Coenagrionidae sp.(juv.)
  Erythromma najas (Hansemann, 1823)
  сем. Aeschnidae
  Aeschna grandis (Linnaeus, 1758)
  Aeschna crenata Hagen, 1856
  Aeschna sp. (juv.)
  сем. Corduliidae sp.(juv.)
  Epitheca bimaculata Charpentier, 1825
  Somatochlora metallica Van der Linden, 1825
  отряд Hemiptera
  сем. Nepidae
  Nepa cinerea Linnaeus, 1758
  сем. Pleidae
  Plea minutissima Leach,1817
  отряд Coleoptera
  сем. Haliplidae
  Haliplus sp. (imago) (o-b)
  Haliplus sp. (larv.)  (o-b)
  сем. Noteridae
  Noterus crassicornis (O.F. Müller, 1776) (imago)
  сем. Dytiscidae
  п/сем. Hydroporinae spp.  (imago)
  п/сем. Hydroporinae sp. (larv.)
  Graptodytes sp. (imago)
  Hydroporus sp. (imago)
  Hyphydrus ovatus (Linnaeus,  1761)
  п/сем. Agabtinae  sp. (larv.)
  п/сем. Colymbetinae sp. (larv.)
  Ilybius sp. (larv.)
  Ilybius sp. (imago)
  Agabus sp. (larv.)
  Colymbetes sp. (larv.)
  Rhantus sp.  (larv.)
  Laccophilus sp. (imago)
  Acilius canaliculatus (Nicolai, 1822)
  Dytiscus circumcinctus Ahrens, 1811 (larv.)
  Hydaticus seminiger (De Geer, 1774) (imago)
  Hydaticus sp.  (larv.)
  сем. Hydraenidae sp. (imago)
  Hydraena sp. (imago)
  сем. Hydrophilidae sp. (imago)
  Hydrophilidae sp. (larv.)
  Cercyon sp.(imago)
  Hydrochara caraboides (Linnaeus, 1758) (larv.)
  Anacaena sp. (imago)
  Laccobius sp. (imago)
  Laccobius sp. (larv.)
  Enochrus sp. (larv.)
  сем. Scirtidae (= Elodidae) n.det.  (imago)
  сем. Scirtidae (= Elodidae) sp. (larv.)
  Scirtes sp .(larv.)
  сем. Elmidae sp. (larv.)
  сем. Chrysomelidae
  отряд Neuroptera
  сем. Sisyridae
  Sisyra fuscata (F.,1793)
  Sisyra sp.
  отряд Megaloptera
  сем. Sialidae
  Sialis sordida Klingstedt, 1932
  Sialis morio Klingstedt, 1932
  Sialis sp.
  отряд Trichoptera
  сем. Polycentropodidae
  Neureclipsis bimaculata (Linnaeus, 1758)  (o-b)
  Cyrnus insolutus MacLachlan, 1878
  Cyrnus flavidus MacLachlan, 1864
  Holocentropus dubius (Rambur, 1842) (o)
  Holocentropus sp. (juv.)
  сем. Hydroptilidae  sp. (juv.)
  Agraylea sexmaculata Curtis, 1834 (o-b)
  Hydroptila sp.
  Oxyethira sp. (o)
  Orthotrichia sp.
  Tricholeiochiton fagesii (Guinard, 1879)
  сем. Molannidae
  Molanna angustata Curtis, 1834  (o)
  сем. Leptoceridae sp. (juv.)
  Athripsodes cinereus (Curtis, 1834)
  Athripsodes atherrimus (Stephens, 1836)
  Triaenodes bicolor (Curtis, 1834) (o-b)
  Triaenodes sp.
  Oecetis sp.
  Mystacides longicornis (Linnaeus, 1758)
  Mystacides niger (Linnaeus, 1758)
  Mystacides sp. (juv.) (b)
  сем. Limnephilidae sp. (juv.)
  Grammotaulius nigropunctatus Retzius, 1783
  Ironoguia dubia (Stephens, 1837)
  Nemotaulius punctatolineatus (Retzius, 1783)
  Limnephilus centralis  Curtis, 1834
  L. nigriceps Zetterstedt, 1840
  Limnephilus lunatus Curtis, 1834
  Limnephilus sp.
  Phacopteryx brevipennis (Curtis, 1834)
  Anabolia furcata Brauer, 1857
  сем. Phryganeidae
  Agrypnia obsoleta (Hagen, 1864)
  Phryganea sp.
  отряд Lepidoptera sp.(pup.)
  сем. Pyraustidae sp. (juv.)
  Elophila nymphaeata Linnaeus, 1758
  Cataclysta lemnata Linnaeus, 1758 (b)
  отряд Diptera
  сем. Chironomidae sp.
  п/сем. Chironominae sp.
  Zavreliella marmorata Kieffer, 1920
  Chironomus sp.
  Omisus caledonicus (Edwards, 1932)
  Glyptotendipes sp.
  Polypedilum sp.
  Tanytarsini sp.
  Tanytarsus sp.
  п/сем. Orthocladiinae n.det
  п/сем. Tanypodinae n.det.
  сем. Simuliidae n.det. (o-b)
  сем. Ceratopogonidae n.det.
  сем. Limoniidae
  Phylidorea sp.
  Molophilus sp.
  сем. Psychodidae n.det.
  Tinearia sp.
  сем. Dixidae
  Dixella sp.
  Dixa sp.
  сем. Chaoboridae
  Chaoborus sp.
  сем. Culicidae sp.
  Aedes sp.
  Culex sp.
  Anopheles sp.
  сем. Stratiomyidae sp. (juv.)
  Odontomyia ornata (Maigen, 1822)
  Odontomyia tigrina (F. 1775)
  Odontomyia sp. (juv.)
  сем. Tabanidae sp. (juv.)
  сем. Syrphidae
TEXT

I18n.with_locale(:ru) do
  parents = []

  raw_taxons.each_line do |line|
    result = Taxons::BuildTaxonCommand.call(line)
    unless result.success?
      puts "\n\n\nСкипаем таксон #{line}, ибо: #{result.inspect}\n\n\n" # rubocop:disable Rails/Output
      next
    end

    taxon = result.value!

    parents.pop while parents.last && parents.last <= taxon
    taxon.parent ||= parents.last if parents.last
    parents.push(taxon) if taxon.rank != :r_species

    taxon.save! if taxon.changed? || taxon.new_record?
  end
end
