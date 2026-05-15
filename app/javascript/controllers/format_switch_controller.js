import { Controller } from "@hotwired/stimulus"

// Switches the contents of a turbo-frame to format-specific fields
// when the format <select> changes.
export default class extends Controller {
  static targets = ["select"]

  static values = {
    url: String,
    frame: String,
  }

  change() {
    const frame = document.getElementById(this.frameValue)
    if (!frame) return

    const url = new URL(this.urlValue, window.location.origin)
    url.searchParams.set("format", this.selectTarget.value)
    frame.src = url.toString()
  }
}
