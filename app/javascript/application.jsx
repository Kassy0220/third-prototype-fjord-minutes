// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import Topics from "./components/topics";
import TopicForm from './components/topicForm';
import {mountComponent} from "./mountComponent";
import { Turbo } from "@hotwired/turbo-rails";

// サイト全体で Turbo Drive を無効にする
Turbo.session.drive = false;

mountComponent('topics', Topics);
mountComponent('topic_form', TopicForm);
