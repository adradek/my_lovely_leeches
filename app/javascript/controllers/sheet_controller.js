import { Controller } from "@hotwired/stimulus"
import Handsontable from "../lib/handsontable"

const SELECTED_BUTTON_CLASSES = ["bg-blue-500", "text-white"]
const PASSIVE_BUTTON_CLASSES = ["text-gray-700", "border", "border-gray-400", "hover:bg-blue-200"]

// Connects to data-controller="sheet"
export default class extends Controller {
  static targets = ["data", "sheetButton", "table"]

  static values = {
    sheetIndex: { type: Number, default: 0 },
  }

  initialize() {
    this.sheets = JSON.parse(this.dataTarget.textContent)
  }

  disconnect() {
    this.hot?.destroy()
    this.hot = null
  }

  selectSheet({ params: { index } }) {
    this.sheetIndexValue = index
  }

  sheetIndexValueChanged() {
    this.#refreshButtons()

    if (!this.hot) {
      this.#initHot()
    } else {
      this.hot.loadData(this.#currentData)
    }
  }

  #refreshButtons() {
    this.sheetButtonTargets.forEach((button, index) => {
      const isSelected = index === this.sheetIndexValue
      SELECTED_BUTTON_CLASSES.forEach(c => button.classList.toggle(c, isSelected))
      PASSIVE_BUTTON_CLASSES.forEach(c => button.classList.toggle(c, !isSelected))
    })
  }

  #initHot() {
    this.hot = new Handsontable(this.tableTarget, {
      data: this.#currentData,
      rowHeaders: true,
      colHeaders: true,
      // height: 'auto',
      // autoWrapRow: true,
      autoWrapCol: true,
      licenseKey: 'non-commercial-and-evaluation'
    });
  }

  get #currentData() {
    return this.sheets[this.sheetIndexValue].data
  }
}
