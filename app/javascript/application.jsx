// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import ReleaseBranchForm from "./components/releaseBranchForm";
import ReleaseNoteForm from "./components/releaseNoteForm";
import Topics from "./components/topics";
import TopicForm from './components/topicForm';
import OtherForm from './components/otherForm';
import {mountComponent} from "./mountComponent";
import { Turbo } from "@hotwired/turbo-rails";

// サイト全体で Turbo Drive を無効にする
Turbo.session.drive = false;

mountComponent('release_branch_form', ReleaseBranchForm);
mountComponent('release_note_form', ReleaseNoteForm);
mountComponent('topics', Topics);
mountComponent('topic_form', TopicForm);
mountComponent('other_form', OtherForm);
