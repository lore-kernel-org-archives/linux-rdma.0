From: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 05/10] IB/isert: Replace semaphore sem with completion
Date: Fri, 18 Nov 2016 12:27:32 +0530
Message-ID: <CAHv-k__HHRzK7+AZ912GVw9ToxZWMw3OccPqgGt_NBf6+RXdzA@mail.gmail.com>
References: <1477551554-30349-1-git-send-email-binoy.jayan@linaro.org>
 <1477551554-30349-6-git-send-email-binoy.jayan@linaro.org> <a267cc5e-4d4f-368e-a159-3eecc2187969@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a267cc5e-4d4f-368e-a159-3eecc2187969-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux kernel mailing list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sagi,

On 31 October 2016 at 02:42, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>> The semaphore 'sem' in isert_device is used as completion, so convert
>> it to struct completion. Semaphores are going away in the future.
>
>
> Umm, this is 100% *not* true. np->sem is designed as a counting to
> sync the iscsi login thread with the connect requests coming from the
> initiators. So this is actually a reliable bug insertion :(
>
> NAK from me...

Sorry for the late reply as I was held up in other activities.

I converted this to a wait_event() implementation but as I was doing it,
I was wondering how it would have been different if it was a completion
and not a semaphore.

File: drivers/infiniband/ulp/isert/ib_isert.c

If isert_connected_handler() is called multiple times, adding an entry to the
list, and if that happens while we use completion, 'done' (part of struct
completion) would be incremented by 1 each time 'complete' is called from
isert_connected_handler. After 'n' iterations, done will be equal to 'n'. If we
call wait_for_completion now from isert_accept_np, it would just decrement
'done' by one and continue without blocking, consuming one node at a time
from the list 'isert_np->pending'.

Alternatively if "done" becomes zero, and the next time wait_for_completion is
called, the API would add a node at the end of the wait queue 'wait' in 'struct
completion' and block until "done" is nonzero. (Ref: do_wait_for_common)
It exists the wait when a call to 'complete' turns 'done' back to 1.
But if there
are multiple waits called before calling complete, all the tasks
calling the wait
gets queued up and they will all would see "done" set to zero. When complete
is called now, done turns 1 again and the first task in the queue is woken up
as it is serialized as FIFO. Now the first wait returns and the done is
decremented by 1 just before the return.

Am I missing something here?

Thanks,
Binoy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
