<?php

namespace App\Http\Controllers;

use App\Models\Task;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;


class TaskController extends Controller
{
    public function index()
    {
        $tasks = Task::where('user_id', Auth::id())->get();
        return view('tasks.index', compact('tasks'));
    }

    public function store(Request $request)
    {
        $request->validate(['title' => 'required|string|max:255']);

        Task::create([
            'title' => $request->title,
            'user_id' => Auth::id(),
        ]);

        return redirect()->back();
    }

    public function update(Task $task)
    {
        abort_unless($task->user_id === auth()->id(), 403);
        $task->update(['completed' => !$task->completed]);
        return redirect()->back();
    }

    public function destroy(Task $task)
    {
        abort_unless($task->user_id === auth()->id(), 403);
        $task->delete();
        return redirect()->back();
    }
}
