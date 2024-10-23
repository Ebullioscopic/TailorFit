package com.karthikinformationtechnology.tailorfitandroid

import android.app.Dialog
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import androidx.fragment.app.DialogFragment

class HeightInputDialogFragment(private val onHeightInput: (Float) -> Unit) : DialogFragment() {

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        return super.onCreateDialog(savedInstanceState)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.dialog_height_input, container, false)

        val heightInput = view.findViewById<EditText>(R.id.height_input)
        val submitButton = view.findViewById<Button>(R.id.submit_button)

        submitButton.setOnClickListener {
            val heightText = heightInput.text.toString()
            if (heightText.isNotEmpty()) {
                val height = heightText.toFloat()
                onHeightInput(height)
                dismiss()
            }
        }

        return view
    }
}
