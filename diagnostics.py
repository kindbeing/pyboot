import sys
import threading
import multiprocessing
import os
import tracemalloc
import gc
import time
from threading import Thread
from multiprocessing import Process
import psutil

def get_runtime_diagnostics():
    """Comprehensive diagnostic function for Python runtime analysis."""

    def get_thread_info():
        """Get information about current threads."""
        current_thread = threading.current_thread()
        all_threads = threading.enumerate()

        thread_info = {
            "current_thread": {
                "name": current_thread.name,
                "ident": current_thread.ident,
                "daemon": current_thread.daemon
            },
            "active_threads": len(all_threads),
            "thread_list": [{"name": t.name, "ident": t.ident, "daemon": t.daemon}
                            for t in all_threads]
        }
        return thread_info

    def get_process_info():
        """Get information about the current process and its children."""
        current_process = multiprocessing.current_process()
        python_process = psutil.Process()

        process_info = {
            "current_process": {
                "name": current_process.name,
                "pid": os.getpid(),
                "parent_pid": os.getppid()
            },
            "cpu_count": multiprocessing.cpu_count(),
            "memory_usage": {
                "rss": python_process.memory_info().rss / 1024 / 1024,  # MB
                "vms": python_process.memory_info().vms / 1024 / 1024   # MB
            },
            "cpu_percent": python_process.cpu_percent(),
            "threads": python_process.num_threads()
        }
        return process_info

    def get_memory_info():
        """Get detailed memory usage information."""
        tracemalloc.start()
        snapshot = tracemalloc.take_snapshot()
        top_stats = snapshot.statistics('lineno')

        memory_info = {
            "gc_objects": len(gc.get_objects()),
            "gc_stats": gc.get_stats(),
            "top_memory_usage": [
                {
                    "file": stat.traceback[0].filename,
                    "line": stat.traceback[0].lineno,
                    "size": stat.size / 1024  # KB
                }
                for stat in top_stats[:3]
            ]
        }
        tracemalloc.stop()
        return memory_info

    def get_interpreter_info():
        """Get Python interpreter information."""
        return {
            "version": sys.version,
            "platform": sys.platform,
            "executable": sys.executable,
            "gil_enabled": True,  # CPython always has GIL
            "recursion_limit": sys.getrecursionlimit(),
            "implementation": sys.implementation.name
        }

    # Simulate some workload
    def cpu_bound_task():
        result = 0
        for i in range(1000000):
            result += i
        return result

    def io_bound_task():
        time.sleep(0.1)

    # Create some threads and processes for demonstration
    threads = [Thread(target=cpu_bound_task) for _ in range(2)]
    processes = [Process(target=cpu_bound_task) for _ in range(2)]

    # Start workload
    for t in threads:
        t.start()
    for p in processes:
        p.start()

    # Collect diagnostics
    diagnostics = {
        "interpreter": get_interpreter_info(),
        "process": get_process_info(),
        "threads": get_thread_info(),
        "memory": get_memory_info()
    }

    # Clean up
    for t in threads:
        t.join()
    for p in processes:
        p.join()

    return diagnostics

# Run diagnostics and display results
def print_diagnostics():
    diagnostics = get_runtime_diagnostics()

    print("\n=== Python Runtime Diagnostics ===\n")

    print("1. Interpreter Information:")
    print(f"   - Version: {diagnostics['interpreter']['version'].split()[0]}")
    print(f"   - Platform: {diagnostics['interpreter']['platform']}")
    print(f"   - GIL Enabled: {diagnostics['interpreter']['gil_enabled']}")
    print(f"   - Implementation: {diagnostics['interpreter']['implementation']}")

    print("\n2. Process Information:")
    print(f"   - PID: {diagnostics['process']['current_process']['pid']}")
    print(f"   - Parent PID: {diagnostics['process']['current_process']['parent_pid']}")
    print(f"   - CPU Count: {diagnostics['process']['cpu_count']}")
    print(f"   - Memory Usage (RSS): {diagnostics['process']['memory_usage']['rss']:.2f} MB")
    print(f"   - CPU Usage: {diagnostics['process']['cpu_percent']}%")

    print("\n3. Thread Information:")
    print(f"   - Active Threads: {diagnostics['threads']['active_threads']}")
    print("   - Thread List:")
    for thread in diagnostics['threads']['thread_list']:
        print(f"     * {thread['name']} (ID: {thread['ident']})")

    print("\n4. Memory Information:")
    print(f"   - Garbage Collector Objects: {diagnostics['memory']['gc_objects']}")
    print("   - Top Memory Usage:")
    for stat in diagnostics['memory']['top_memory_usage']:
        print(f"     * {stat['file']}: {stat['size']:.2f} KB")

if __name__ == "__main__":
    print_diagnostics()