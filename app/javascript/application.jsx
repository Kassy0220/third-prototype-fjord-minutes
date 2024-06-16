// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import React from "react";
import { createRoot } from 'react-dom/client';
import TopicForm from './components/topicForm';
import { Turbo } from "@hotwired/turbo-rails";

// サイト全体で Turbo Drive を無効にする
// Turbo.session.drive = false;

const element = document.getElementById('topic_form');
const root = createRoot(element);

const minuteData = JSON.parse(element.getAttribute('data'));
console.log(minuteData)
root.render(<TopicForm minuteId={minuteData.minute_id}/>);

