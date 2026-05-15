import { Controller } from "@hotwired/stimulus"
import Handsontable from "../lib/handsontable"

const DEFAULT_DATA = Array.from({ length: 10 }, () => Array(10).fill(null))

// Renders an editable Handsontable and keeps a hidden input synced
// with its current contents (as JSON), so the data is submitted with the form.
export default class extends Controller {
  static targets = ["table", "input"]

  connect() {
    this.hot = new Handsontable(this.tableTarget, {
      data: this.#initialData(),
      rowHeaders: true,
      colHeaders: true,
      minRows: 10,
      minCols: 10,
      height: "auto",
      width: "auto",
      colWidths: 100,
      rowHeights: 28,
      autoWrapCol: true,
      contextMenu: true,
      licenseKey: "non-commercial-and-evaluation",
      afterChange: () => this.#sync(),
      afterCreateRow: () => this.#sync(),
      afterRemoveRow: () => this.#sync(),
      afterCreateCol: () => this.#sync(),
      afterRemoveCol: () => this.#sync(),
    })

    this.#sync()
  }

  disconnect() {
    this.hot?.destroy()
    this.hot = null
  }

  #initialData() {
    const raw = this.inputTarget.value
    if (!raw) return DEFAULT_DATA

    try {
      const parsed = JSON.parse(raw)
      return Array.isArray(parsed) && parsed.length > 0 ? parsed : DEFAULT_DATA
    } catch {
      return DEFAULT_DATA
    }
  }

  #sync() {
    if (!this.hot) return
    this.inputTarget.value = JSON.stringify(this.hot.getData())
  }
}
