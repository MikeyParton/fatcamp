$( document ).on('turbolinks:load', function() {
  if ($('#myChart').length > 0) {
    render_chart();
  };
});

function render_chart(){

  console.log("rendering chart")

  var ctx = $("#myChart");
  var labels = JSON.parse(ctx[0].dataset.progress).labels
  var weights = JSON.parse(ctx[0].dataset.progress).weights

  var data = {
    labels: labels,
    datasets: [
      {
        label: "Weight",
        fill: true,
        lineTension: 0.1,
        backgroundColor: "rgba(75,192,192,0.4)",
        borderColor: "rgba(75,192,192,1)",
        borderCapStyle: 'butt',
        borderDash: [],
        borderDashOffset: 0.0,
        borderJoinStyle: 'miter',
        pointBorderColor: "rgba(75,192,192,1)",
        pointBackgroundColor: "#fff",
        pointBorderWidth: 1,
        pointHoverRadius: 5,
        pointHoverBackgroundColor: "rgba(75,192,192,1)",
        pointHoverBorderColor: "rgba(220,220,220,1)",
        pointHoverBorderWidth: 2,
        pointRadius: 1,
        pointHitRadius: 10,
        data: weights,
        spanGaps: true
      }
    ]
  };

  var max_of_array = Math.max.apply(Math, data.datasets[0].data);

  var options = {
    legend: {
      display: false
    },
    scales: {
      yAxes: [{
        gridLines: {
          display: false
        },
        ticks: {
          display: false,
          beginAtZero: false,
          max: Math.ceil(max_of_array/20)*20 + 20
        }
      }],
      xAxes: [{
        gridLines: {
          display: false
        }
      }]
    }
  }

  var lineChart = new Chart(ctx, {
    type: 'line',
    data: data,
    options: options
  });

}