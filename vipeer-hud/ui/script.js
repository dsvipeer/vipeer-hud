
function setVeloBar(velo) {
    let fill_value = 100 * (velo) / (130)
    let fill_element = document.querySelector('.veloFill')
    
    fill_element.style.height = `${fill_value}%`
}

function formatTime(minute, hour) {
    let time = ''

    if (hour <= 9) {
        time += '0' + hour
    } else {
        time += hour
    }

    if (minute <= 9) {
        time += ':0' + minute
    } else {
        time += ':' + minute
    }

    return time
}


window.addEventListener('message', ({ data }) => {
    if (data.hud == true) {
        document.querySelector('body').style.display = 'flex'
    } else if (data.hud == false) {
        document.querySelector('body').style.display = 'none'
    }

    if (data.hotkey == false) {
        document.querySelector('hotkey').style.display = 'none'
    }


    let life = document.querySelector('.lifeFill')
    life.style.width = `${data.health}%`
    life.style.background = data.health <= 0 ?'transparent':'#224EF2'

    if (data.armour > 0) {
        document.querySelector('.shieldBar').style.display = `flex`
        document.querySelector('.shieldFill').style.width = `${data.armour}%`
    } else {
        document.querySelector('.shieldBar').style.display = `none`
    }


    let hour = document.querySelector('.hour')
    hour.textContent = `${data.time}`

    let location = document.querySelector('.location')
    location.innerHTML = `
        <div class="icon"><img src="images/loc.svg" alt=""></div>
        <p>${data.street}</p>
    `

    let car = document.querySelector('.carHud-container')

    if (data.car) {
        car.style.display = 'flex'
        car.classList.add('veloAppear')
        car.classList.remove('veloDisappear')

        let velo = document.querySelector('.velo')

        velo.textContent = data.speed

        if (Number(data.speed) <= 9) {
            velo.innerHTML = `
                <h1 class = 'velo'><span class = 'defaultVelo'>00</span>${data.speed.toFixed(0)}<span class = 'kmText'>KMH</span></h1>
            `
        } else if (Number(data.speed) <= 99) {
            velo.innerHTML = `
                <h1 class = 'velo'><span class = 'defaultVelo'>0</span>${data.speed.toFixed(0)}<span class = 'kmText'>KMH</span></h1>
            `
        } else {
            velo.innerHTML = `
                <h1 class = 'velo'>${data.speed.toFixed(0)}<span class = 'kmText'>KMH</span></h1>
            `
        }

        let velo_perc = 100 * (data.speed) / (300)

        setVeloBar(velo_perc)

        let gas_element = document.querySelector('.gasAmount');
        gas_element.innerHTML = `
        <p class = 'gasAmount'>${data.fuel.toFixed(0)}<span>%</span></p>`
        document.querySelector('.shieldFill').style.width = `${data.fuel.toFixed(0)}%`
        
        let seatbelt = document.querySelector('.seatbelt')

        if (data.seatbelt == '1') {
            seatbelt.classList.remove('opacity')
        } else {
            seatbelt.classList.add('opacity')
        }
    } else {
        car.classList.remove('veloAppear')
        car.classList.add('veloDisappear')

        setTimeout(() => {
            car.style.display = 'flex'
        }, 3900)
    }

})