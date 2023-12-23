// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"

import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import { Modal } from "tailwindcss-stimulus-components"

application.register('modal', Modal)

eagerLoadControllersFrom("controllers", application)
