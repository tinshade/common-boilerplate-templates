import './style.css';
import api from './api/client';

const apiUrl = document.querySelector('#api-url');
const result = document.querySelector('#result');
const errorBox = document.querySelector('#error');

apiUrl.textContent = `API: ${import.meta.env.VITE_API_URL}`;

api
  .get('/api/health')
  .then((res) => {
    result.textContent = JSON.stringify(res.data, null, 2);
    result.hidden = false;
  })
  .catch((err) => {
    errorBox.textContent = err.message;
    errorBox.hidden = false;
  });
