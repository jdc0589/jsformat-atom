{WorkspaceView} = require 'atom'
require 'fs'

format = require '../lib/format'

describe "JSFormat package tests", ->
  beforeEach ->
    atom.workspaceView = new WorkspaceView()
    atom.workspace = atom.workspaceView.model

  # JSFormat tests here

  describe "when the textbuffer is being formatted", ->
    beforeEach ->
      atom.workspaceView.attachToDom()

    it "can format the whole buffer with the use of the command", ->
      # general format test

      waitsForPromise ->
        atom.workspace.open('specfiles/index.js')

      runs ->
        @fileText = atom.workspace.getActiveTextEditor().getText()
        atom.workspaceView.getActiveView().trigger 'jsformat:format'

      runs ->
        # just check that some whitespace and other goodies got added
        expect(atom.workspace.getActiveTextEditor().getText()).not.toMatch(@fileText)

    it "can format the whole buffer if Format on save is turned on", ->
      # format_on_save test

      waitsForPromise ->
        atom.workspace.open('specfiles/index.js')

      runs ->
        fileText = atom.workspace.getActiveTextEditor().getText()
        atom.config.set('jsformat.format_on_save', true)
        atom.workspace.getActiveTextEditor().save()

        # just check that some whitespace and other goodies got added
        expect(atom.workspace.getActiveTextEditor().getText()).not.toMatch(fileText)
        atom.config.set('jsformat.format_on_save', false)

    it "displays a notification for unsupported languages", ->
      # NotSupportedNotificationView test

      displayUnsupportedLanguageNotification = jasmine.createSpy('format.displayUnsupportedLanguageNotification')

      waitsForPromise ->
        atom.workspace.open('xyz.coffee')

      runs ->
        atom.workspaceView.getActiveView().trigger('jsformat:format')
        displayUnsupportedLanguageNotification()

        # TODO seems a little stupid to expect something I'm calling, but I can't figure it out, so this is a placeholder

        expect(displayUnsupportedLanguageNotification.calls.length).toEqual(1)
