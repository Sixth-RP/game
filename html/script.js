window.addEventListener('message', function(event) {
    const data = event.data;

    if (data.action === 'toggleRadar') {
        const radarContainer = document.getElementById('radar-container');
        if (data.show) {
            radarContainer.classList.remove('hidden');
        } else {
            radarContainer.classList.add('hidden');
        }
    } else if (data.action === 'updateRadar') {
        updateRadarDisplay(data);
    }
});

function updateRadarDisplay(data) {
    // Update front speed
    const frontSpeedElement = document.getElementById('front-speed');
    frontSpeedElement.textContent = padSpeed(data.frontSpeed);
    if (data.frontLocked) {
        frontSpeedElement.classList.add('locked');
    } else {
        frontSpeedElement.classList.remove('locked');
    }

    // Update rear speed
    const rearSpeedElement = document.getElementById('rear-speed');
    rearSpeedElement.textContent = padSpeed(data.rearSpeed);
    if (data.rearLocked) {
        rearSpeedElement.classList.add('locked');
    } else {
        rearSpeedElement.classList.remove('locked');
    }

    // Update patrol speed
    const patrolSpeedElement = document.getElementById('patrol-speed');
    patrolSpeedElement.textContent = padSpeed(data.patrolSpeed);

    // Update front plate
    const frontPlateElement = document.getElementById('front-plate');
    if (data.frontPlate && data.frontPlate.trim() !== '') {
        frontPlateElement.textContent = data.frontPlate.trim();
    } else {
        frontPlateElement.textContent = '--------';
    }

    // Update rear plate
    const rearPlateElement = document.getElementById('rear-plate');
    if (data.rearPlate && data.rearPlate.trim() !== '') {
        rearPlateElement.textContent = data.rearPlate.trim();
    } else {
        rearPlateElement.textContent = '--------';
    }

    // Add active animation for non-zero speeds
    if (data.frontSpeed > 0) {
        frontSpeedElement.classList.add('active');
    } else {
        frontSpeedElement.classList.remove('active');
    }

    if (data.rearSpeed > 0) {
        rearSpeedElement.classList.add('active');
    } else {
        rearSpeedElement.classList.remove('active');
    }
}

function padSpeed(speed) {
    return String(speed).padStart(3, '0');
}
