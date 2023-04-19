async function fetchData() {
  const response = await fetch('/data');
  const data = await response.json();
  return data;
}

function createChart(data) {
  const ctx = document.getElementById('chart').getContext('2d');
  new Chart(ctx, {
    type: 'line', // Change the chart type to 'line'
    data: {
      datasets: data.map(restaurant => {
        return {
          label: restaurant.name,
          data: restaurant.data.map(point => ({
            x: new Date(point.x * 1000), // Convert timestamp to Date object
            y: point.y,
          })),
          backgroundColor: 'rgba(75, 192, 192, 0.2)',
          borderColor: 'rgba(75, 192, 192, 1)',
          borderWidth: 1,
          pointBackgroundColor: 'black', // Set the color of the points
          fill: false, // Set fill to false for line chart
        };
      }),
    },
    options: {
      scales: {
        x: {
          type: 'time',
          time: {
            unit: 'day',
            tooltipFormat: 'MMM dd, yyyy',
            displayFormats: {
              day: 'MMM dd',
            },
          },
          title: {
            display: true,
            text: 'Date',
          },
        },
        y: {
          title: {
            display: true,
            text: 'Cumulative Amount',
          },
        },
      },
    },
  });
}
async function main() {
  const data = await fetchData();
  const canvas = document.createElement('canvas');
  canvas.id = 'chart';
  document.getElementById('canvas-container').appendChild(canvas);
  createChart(data);
}

main();