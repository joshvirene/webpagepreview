// Function that will dynamically update the fields related to income tax calculation

function updateIncomeFields() {
    const filingStatus = document.getElementById('filing_status').value;
    const incomeSingle = document.getElementById('income_single');
    const incomeMarriedSeparate = document.getElementById('income_married_separate');
    const eitcStatus = document.getElementById('EITC_status').value;
    const eitcKidsDiv = document.getElementById('eitc_kids');
    const ctcStatus = document.getElementById('CTC_status').value;
    const ctcKidsDiv = document.getElementById('ctc_kids');
    const caleitcStatus = document.getElementById('CalEITC_status').value
    const caleitcKidsDiv = document.getElementById('caleitc_kids')
    const yctcStatus = document.getElementById('YCTC_status').value;
    const yctcKidsDiv = document.getElementById('yctc_kids');

    // Reset display for all sections
    incomeSingle.style.display = 'none';
    incomeMarriedSeparate.style.display = 'none';
    eitcKidsDiv.style.display = 'none';
    ctcKidsDiv.style.display = 'none';
    caleitcKidsDiv.style.display = 'none';
    yctcKidsDiv.style.display = 'none';

    // Display income fields based on filing status
    if (filingStatus === 'Single' || filingStatus === 'Married Filing Jointly' || filingStatus === 'Head of Household') {
        incomeSingle.style.display = 'block'; // Show total income for these options
    } else if (filingStatus === 'Married Filing Separately') {
        incomeMarriedSeparate.style.display = 'block'; // Show two income fields
    }

    // Display EITC eligible children input if EITC status is eligible
    if (eitcStatus === 'eligible') {
        eitcKidsDiv.style.display = 'block';
    }

    // Display CTC eligible children input if CTC status is eligible
    if (ctcStatus === 'eligible') {
        ctcKidsDiv.style.display = 'block';
    }

    // Display CalEITC eligible children input if CalEITC status is eligible
    if (caleitcStatus === 'eligible') {
        caleitcKidsDiv.style.display = 'block';
    }

    // Display YCTC eligible children input if YCTC status is eligible
    if (yctcStatus === 'eligible') {
        yctcKidsDiv.style.display = 'block';
    }

}

// Function that will dynamically update fields related to household expense calculation
function updateHouseholdFields() {
    const nKids = parseInt(document.getElementById('nonincome_hh_membersN').value, 10);
    const privateSchoolDiv = document.getElementById('childrenW_privateschoolN_container');
    const childcareDiv = document.getElementById('childrenW_childcareN_container');
    const pets = parseInt(document.getElementById('petsN').value, 10);
    const petInsuranceDiv = document.getElementById('pet_insN_container');

    // Hide all optional fields by default
    privateSchoolDiv.style.display = 'none';
    if (childcareDiv) childcareDiv.style.display = 'none';
    petInsuranceDiv.style.display = 'none';

    // Display the private school and childcare fields if nKids > 0
    if (nKids > 0) {
        privateSchoolDiv.style.display = 'block';
        if (childcareDiv) childcareDiv.style.display = 'block';
    }

    // Display pet insurance field if there are pets
    if (pets > 0) {
        petInsuranceDiv.style.display = 'block';
    }
}

