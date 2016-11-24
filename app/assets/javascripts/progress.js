$( document ).on('turbolinks:load', function() {
  if ($('#myChart').length > 0) {
    render_chart();
  };
});

function render_chart(){

  console.log("rendering chart");

  var ctx = $("#myChart");
  var labels = JSON.parse(ctx[0].dataset.progress).labels
  var weights = JSON.parse(ctx[0].dataset.progress).weights
  var max_weight = Math.max.apply(Math, weights);

  // Calculate end points for lineweights
  var lineWeights = weights.slice();
  var start = weights.slice().filter(Number)[0];
  var end = weights.slice().filter(Number).reverse()[0];
  lineWeights[0] = start;
  lineWeights[weights.length - 1] = end;

  var data = {
    labels: labels,
    datasets: [
      {
        label: "Weight",
        fill: false,
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
        pointRadius: 2,
        pointHitRadius: 2,
        data: weights,
        spanGaps: true
      },
      {
        label: "Line",
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
        pointRadius: 0,
        pointHitRadius: 0,
        data: lineWeights,
        spanGaps: true
      }
    ]
  };

  var options = {
    legend: {
      display: false
    },
    elements: { point: { radius: 0 } }, 
    scales: {
      yAxes: [{
        gridLines: {
          display: false
        },
        ticks: {
          display: false,
          beginAtZero: true,
          max: Math.ceil(max_weight + 20)
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