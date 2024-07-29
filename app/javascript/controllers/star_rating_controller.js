import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["star"]

  initialize() {
    this.stars = this.starTargets
  }

  highlightStars(event) {
    const index = this.stars.indexOf(event.currentTarget)
    this.stars.forEach((star, i) => {
      if (i <= index) {
        star.classList.add('text-yellow-400')
        star.classList.remove('text-gray-400')
      } else {
        star.classList.add('text-gray-400')
        star.classList.remove('text-yellow-400')
      }
    })
  }

  resetStars() {
    this.stars.forEach(star => {
      star.classList.add('text-gray-400')
      star.classList.remove('text-yellow-400')
    })
  }
}
