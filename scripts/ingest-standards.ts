import cron from 'node-cron';
// ... imports

async function runIngestion() {
   // ... (Your existing ingestion logic)
}

// IF RUNNING IN DOCKER WORKER MODE:
console.log("Worker started. Scheduling ingestion for every Monday at 8am.");

// Schedule task to run at 08:00 on Monday
cron.schedule('0 8 * * 1', () => {
  console.log('⏰ Running scheduled ingestion...');
  runIngestion();
});

// Run once immediately on startup to ensure data exists
runIngestion();