import { useState } from "react"; 

const MoodForm = () => {
    const [mood, setMood] = useState("");
    const [note, setNote] = useState("");
    const [responseMessage, setResponseMessage] = useState("");

    const handleSubmit = async () => {
        try {
            const response = await fetch("http://localhost:8080/moodpin/add", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({ mood, note }),
                mode: "cors", // Ensure CORS is enabled
                credentials: "include", // Include credentials if needed
            });

            if (!response.ok) {
                throw new Error("Failed to send data");
            }

            const result = await response.json();
            setResponseMessage(result.message);
            setMood("");
            setNote("");
        } catch (error) {
            console.error("Error:", error);
            setResponseMessage("An error occurred. Please try again.");
        }
    };

    return (
        <div className="max-w-md mx-auto mt-10 p-5 bg-white rounded-lg shadow-md">
            <h2 className="text-2xl font-bold text-center mb-4">Mood Pin</h2>
            <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700 mb-1">Mood</label>
                <input
                    type="text"
                    value={mood}
                    onChange={(e) => setMood(e.target.value)}
                    className="w-full p-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="Enter your mood"
                />
            </div>
            <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700 mb-1">Note</label>
                <textarea
                    value={note}
                    onChange={(e) => setNote(e.target.value)}
                    className="w-full p-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="Enter a note"
                />
            </div>
            <button
                onClick={handleSubmit}
                className="w-full p-2 bg-blue-600 text-white rounded hover:bg-blue-700 transition"
            >
                Submit
            </button>
            {responseMessage && (
                <div className="mt-4 text-center text-green-600">
                    {responseMessage}
                </div>
            )}
        </div>
    );
};

export default MoodForm;
