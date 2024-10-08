// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import './previewMarkdown'
import Attendee from "./components/attendee";
import ReleaseInformationForm from "./components/releaseInformationForm";
import Topics from "./components/topics";
import TopicForm from './components/topicForm';
import OtherForm from './components/otherForm';
import NextDateForm from "./components/nextDateForm";
import Absentee from "./components/absentee";
import TotalAttendances from "./components/totalAttendances";
import {mountComponent} from "./mountComponent";
import { Turbo } from "@hotwired/turbo-rails";

// サイト全体で Turbo Drive を無効にする
Turbo.session.drive = false;

mountComponent('attendee', Attendee);
mountComponent('release_branch_form', ReleaseInformationForm);
mountComponent('release_note_form', ReleaseInformationForm);
mountComponent('topics', Topics);
mountComponent('topic_form', TopicForm);
mountComponent('other_form', OtherForm);
mountComponent('next_date_form', NextDateForm)
mountComponent('absentee', Absentee);
mountComponent('total_attendances', TotalAttendances)
