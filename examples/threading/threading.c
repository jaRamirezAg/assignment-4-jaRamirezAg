#include "threading.h"
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

// Optional: use these functions to add debug or error prints to your application
#define DEBUG_LOG(msg,...)
//#define DEBUG_LOG(msg,...) printf("threading: " msg "\n" , ##__VA_ARGS__)
#define ERROR_LOG(msg,...) printf("threading ERROR: " msg "\n" , ##__VA_ARGS__)

void* threadfunc(void* thread_param)
{

    // TODO: wait, obtain mutex, wait, release mutex as described by thread_data structure
    // hint: use a cast like the one below to obtain thread arguments from your parameter
    //struct thread_data* thread_func_args = (struct thread_data *) thread_param;

    // 1. Obtenemos los argumentos mediante el cast sugerido
    struct thread_data* thread_func_args = (struct thread_data *) thread_param;

    // 2. Esperar antes de obtener el mutex (ms a us)
    usleep(thread_func_args->wait_to_obtain_ms * 1000);

    // 3. Intentar obtener el mutex
    int rc = pthread_mutex_lock(thread_func_args->mutex);
    if (rc != 0) {
        ERROR_LOG("Failed to lock mutex");
        thread_func_args->thread_complete_success = false;
        return thread_param;
    }

    // 4. Esperar mientras se mantiene el mutex (ms a us)
    usleep(thread_func_args->wait_to_release_ms * 1000);

    // 5. Liberar el mutex
    rc = pthread_mutex_unlock(thread_func_args->mutex);
    if (rc != 0) {
        ERROR_LOG("Failed to unlock mutex");
        thread_func_args->thread_complete_success = false;
        return thread_param;
    }

    // 6. exito
    thread_func_args->thread_complete_success = true;
    return thread_param;
}


bool start_thread_obtaining_mutex(pthread_t *thread, pthread_mutex_t *mutex,int wait_to_obtain_ms, int wait_to_release_ms)
{
    /**
     * TODO: allocate memory for thread_data, setup mutex and wait arguments, pass thread_data to created thread
     * using threadfunc() as entry point.
     *
     * return true if successful.
     *
     * See implementation details in threading.h file comment block
     */

    // 1. Asignar memoria para los datos del hilo
    struct thread_data* data = (struct thread_data*) malloc(sizeof(struct thread_data));
    if (data == NULL) {
        ERROR_LOG("Failed to allocate memory");
        return false;
    }

    // 2. Configurar la estructura con los parámetros recibidos
    data->mutex = mutex;
    data->wait_to_obtain_ms = wait_to_obtain_ms;
    data->wait_to_release_ms = wait_to_release_ms;
    data->thread_complete_success = false;

    // 3. Crear el hilo pasándole nuestra estructura 'data'
    int rc = pthread_create(thread, NULL, threadfunc, data);

    if (rc != 0) {
        ERROR_LOG("Failed to create thread");
        free(data); // Limpiar si falla la creación
        return false;
    }

    return true;
}

