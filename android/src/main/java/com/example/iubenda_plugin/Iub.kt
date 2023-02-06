package com.example.iubenda_plugin

import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.iubenda.iab.IubendaCMP
import com.iubenda.iab.IubendaCMPChangeListener
import com.iubenda.iab.IubendaCMPConfig


class Iub : AppCompatActivity(), IubendaCMPChangeListener {
    private val configuration = IubendaCMPConfig.builder()
        .gdprEnabled(true)
        .siteId("2938102")
        .cookiePolicyId("87278796")
        .googleAds(true)
//        .applyStyles(true)
//        .cssResource(R.raw.custom_style)
//        .jsonResource(R.raw.config)
        .acceptIfDismissed(false)
        .build()

    private var bannerIsShowed = false
    private var isConsentInvoked = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_iub)
        bannerIsShowed = false
        IubendaCMP.initialize(this, configuration)

        val consent = IubendaCMP.isConsentGiven()

        if (consent) {
            returnConsentResult(consent = consent)
        }

        IubendaCMP.askConsent(this)

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
        resultIntent.putExtra("consent_key", userConsent)
        setResult(RESULT_OK, resultIntent)
        this.finish()
    }
}