import { Controller } from "@hotwired/stimulus"
import Chart from 'chart.js/auto';


export default class extends Controller {
  connect() {
   new Chart(this.element, {
      type: "line",
      data: {
        labels: ["Red", "Blue", "Yellow", "Green", "Purple", "Orange"],
        datasets: [{
          label: "# of Votes",
          data: [12, 19, 3, 5, 2, 3],
          backgroundColor: "rgba(255, 99, 132, 0.2)",
          borderColor: "rgba(255, 99, 132, 1)",
          borderWidth: 1
        }]
      },
    })
  }
}