<x-app-layout>


<div class="container mx-auto max-w-lg mt-10 bg-red-200 p-3">
    <h1 class="text-2xl font-bold mb-4">Twoja lista zadań</h1>
    
    <form method="POST" action="{{ route('tasks.store') }}" class="mb-4">
        @csrf
        <div class="flex">
            <input type="text" name="title" class="border rounded p-2 flex-1" placeholder="Nowe zadanie">
            <button type="submit" class="bg-blue-600 text-white px-4 py-2 ml-2 rounded">Dodaj</button>
        </div>
    </form>

    <ul class="space-y-2">
        @foreach($tasks as $task)
            <li class="flex justify-between items-center border p-2 rounded">
                <form action="{{ route('tasks.update', $task) }}" method="POST">
                    @csrf
                    @method('PATCH')
                    <button type="submit">{{ $task->completed ? '✅' : '⬜' }}</button>
                </form>

                <span class="{{ $task->completed ? 'line-through text-gray-500' : '' }}">
                    {{ $task->title }}
                </span>

                <form action="{{ route('tasks.destroy', $task) }}" method="POST">
                    @csrf
                    @method('DELETE')
                    <button type="submit" class="text-red-500">X</button>
                </form>
            </li>
        @endforeach
    </ul>
</div>
</x-app-layout>
