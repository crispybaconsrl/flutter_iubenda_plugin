package com.example.iubenda_plugin

import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.iubenda.iab.IubendaCMP
import com.iubenda.iab.IubendaCMPChangeListener
import com.iubenda.iab.IubendaCMPConfig
import com.iubenda.iab.internal.IubendaCMPInternal


class Iub : AppCompatActivity(), IubendaCMPChangeListener {

    private var bannerIsShowed = false
    private var isConsentInvoked = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_iub)

        val siteId = intent.getStringExtra("siteId")
        val cookiesId = intent.getStringExtra("cookiesId")
        val showPreferences = intent.getBooleanExtra("showPreferences", false)

        val configuration = IubendaCMPConfig.builder()
            .gdprEnabled(true)
            .siteId(siteId)
            .cookiePolicyId(cookiesId)
            .googleAds(true)
            .acceptIfDismissed(false)
            .build()

        bannerIsShowed = false
        IubendaCMP.initialize(this, configuration)

        if (showPreferences) {
            IubendaCMP.openPreferences(this)
        } else {
            val hasExpressedPreferences = IubendaCMP.getStorage().hasExpressedPreference()
            if (hasExpressedPreferences) {
                returnConsentResult()
            }

            IubendaCMP.askConsent(this)
        }
    }

    override fun onPostCreate(savedInstanceState: Bundle?) {
        super.onPostCreate(savedInstanceState)
        IubendaCMP.registerChangeListener {
            returnConsentResult()
        }
    }

    override fun onConsentChanged() {
        initializeLibraries()
    }

    private fun initializeLibraries() {
        if (IubendaCMP.isConsentGiven()) {
            if (IubendaCMP.isGooglePersonalized()) {
                // enable Google personalized ADs
            } else {
                // disable Google personalized ADs
            }
            // setup other libraries
        }
    }

    override fun onPause() {
        super.onPause()
        bannerIsShowed = true
    }

    override fun onStop() {
        super.onStop()
        if (bannerIsShowed && isConsentInvoked) {
            returnConsentResult()
        }
    }

    override fun onResume() {
        super.onResume()
        if (bannerIsShowed) {
            returnConsentResult()
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        IubendaCMP.unregisterChangeListener(this)
    }

    private fun returnConsentResult(consent: Boolean? = null) {
        var userConsent = consent;
        if (userConsent == null) {
            userConsent = IubendaCMP.isConsentGiven()
        }
        val resultIntent = Intent()
        val purposeString = IubendaCMP.getStorage().purposesString
        val isGooglePersonalised = checkPersonalizedAds(purposes = purposeString)
        resultIntent.putExtra("consent_key", isGooglePersonalised)
        setResult(RESULT_OK, resultIntent)
        this.finish()
    }

    private fun checkPersonalizedAds(purposes: String) : Boolean {
        if (purposes.length < 10) {
            return false;
        } else {
            var isPersonalised = true;
            val googlePersonalisedPurposes = listOf<Int>(1,2,3,4,7,9,10)
            purposes.forEachIndexed { index, c ->
                if (googlePersonalisedPurposes.contains(index + 1)) {
                    val purposeValue = convertStringToBoolean(value = c)
                    isPersonalised = isPersonalised.and(purposeValue)
                }
            }
            return isPersonalised;
        }
        return false;
    }

    private fun convertStringToBoolean(value: Char) : Boolean {
        if (value == '1') {
            return true
        }
        return false
    }
}