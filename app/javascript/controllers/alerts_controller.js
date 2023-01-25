import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  dismiss(e) {
    e.preventDefault();
    e.stopPropagation();

    document.getElementById(e.params["banner"]).classList.add("d-none");
  }
}