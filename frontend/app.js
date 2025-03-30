document.addEventListener('DOMContentLoaded', () => {
    // Registration Form Handling
    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        registerForm.addEventListener('submit', async (e) => {
            e.preventDefault();

            const formData = new FormData(e.target);
            const data = Object.fromEntries(formData);

            if (!data.name || !data.email || !data.phone || !data.password) {
                alert("All fields are required");
                return;
            }

            try {
                const response = await fetch('http://127.0.0.1:5000/api/customers/register', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data),
                });

                if (!response.ok) throw new Error('Network response was not ok');

                const result = await response.json();
                console.log('✅ Registration successful:', result);
                alert("Registration successful! You can now log in.");
            } catch (error) {
                console.error('❌ Error during registration:', error);
                alert("Registration failed.");
            }
        });
    }

    // Login Form Handling
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', async (e) => {
            e.preventDefault();

            const formData = new FormData(e.target);
            const data = Object.fromEntries(formData);

            try {
                const response = await fetch('http://127.0.0.1:5000/api/customers/login', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data),
                });

                if (!response.ok) throw new Error('Invalid credentials');

                const result = await response.json();
                console.log('✅ Login successful:', result);
                alert('Login successful!');
            } catch (error) {
                console.error('❌ Error during login:', error);
                alert('Login failed! Check your credentials.');
            }
        });
    }
});
