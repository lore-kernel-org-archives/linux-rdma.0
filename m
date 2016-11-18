From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 05/10] IB/isert: Replace semaphore sem with completion
Date: Fri, 18 Nov 2016 09:58:15 +0100
Message-ID: <3477625.cZS9dUaHfE@wuerfel>
References: <1477551554-30349-1-git-send-email-binoy.jayan@linaro.org> <a267cc5e-4d4f-368e-a159-3eecc2187969@grimberg.me> <CAHv-k__HHRzK7+AZ912GVw9ToxZWMw3OccPqgGt_NBf6+RXdzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHv-k__HHRzK7+AZ912GVw9ToxZWMw3OccPqgGt_NBf6+RXdzA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: Sagi Grimberg <sagi@grimberg.me>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, Linux kernel mailing list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Friday, November 18, 2016 12:27:32 PM CET Binoy Jayan wrote:
> Hi Sagi,
> 
> On 31 October 2016 at 02:42, Sagi Grimberg <sagi@grimberg.me> wrote:
> >> The semaphore 'sem' in isert_device is used as completion, so convert
> >> it to struct completion. Semaphores are going away in the future.
> >
> >
> > Umm, this is 100% *not* true. np->sem is designed as a counting to
> > sync the iscsi login thread with the connect requests coming from the
> > initiators. So this is actually a reliable bug insertion :(
> >
> > NAK from me...
> 
> Sorry for the late reply as I was held up in other activities.
> 
> I converted this to a wait_event() implementation but as I was doing it,
> I was wondering how it would have been different if it was a completion
> and not a semaphore.
> 
> File: drivers/infiniband/ulp/isert/ib_isert.c
> 
> If isert_connected_handler() is called multiple times, adding an entry to the
> list, and if that happens while we use completion, 'done' (part of struct
> completion) would be incremented by 1 each time 'complete' is called from
> isert_connected_handler. After 'n' iterations, done will be equal to 'n'. If we
> call wait_for_completion now from isert_accept_np, it would just decrement
> 'done' by one and continue without blocking, consuming one node at a time
> from the list 'isert_np->pending'.
> 
> Alternatively if "done" becomes zero, and the next time wait_for_completion is
> called, the API would add a node at the end of the wait queue 'wait' in 'struct
> completion' and block until "done" is nonzero. (Ref: do_wait_for_common)
> It exists the wait when a call to 'complete' turns 'done' back to 1.
> But if there
> are multiple waits called before calling complete, all the tasks
> calling the wait
> gets queued up and they will all would see "done" set to zero. When complete
> is called now, done turns 1 again and the first task in the queue is woken up
> as it is serialized as FIFO. Now the first wait returns and the done is
> decremented by 1 just before the return.
> 
> Am I missing something here?

I think you are right. This is behavior is actuallly documented in
Documentation/scheduler/completion.txt:

  If complete() is called multiple times then this will allow for that number
  of waiters to continue - each call to complete() will simply increment the
  done element. Calling complete_all() multiple times is a bug though. Both
  complete() and complete_all() can be called in hard-irq/atomic context
  safely.

However, this is fairly unusual behavior and I wasn't immediately aware
of it either when I read Sagi's reply. While your patch looks correct,
it's probably a good idea to point out the counting behavior of this
completion as explicitly as possible, in the changelog text of the patch
as well as in a code comment and perhaps in the naming of the completion.

	Arnd
