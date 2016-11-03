From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v4 10/10] IB/mlx5: Simplify completion into a wait_event
Date: Thu, 3 Nov 2016 08:37:16 -0700
Message-ID: <CA+55aFxUA8r8_-yYtZfijWK_2WB+eCxMiHS-bVDN45-98V6Hdw@mail.gmail.com>
References: <1477551554-30349-1-git-send-email-binoy.jayan@linaro.org> <1477551554-30349-11-git-send-email-binoy.jayan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477551554-30349-11-git-send-email-binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 26, 2016 at 11:59 PM, Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> Convert the completion 'mlx5_ib_umr_context:done' to a wait_event as it
> just waits for the return value to be filled.

This is wrong.

Since that "umr_context" variable is on the stack, and you are waiting
for it to be fully done, it really should be a completion.

Why?

Because a "complete()" guarantees that the *last* access to the
variable is done by the thread that does "wait_for_completion()".

In contrast, doing a "wait_event()" can actually *race* with whoever
wakes it up, and the "wait_event()" may race with the wakeup, where
the wakeup() ends up removing the entry from the list, so that
"list_empty_careful()" sees that it's all done, but the "wakeup()" can
still be holding (and about to release) the waitqueue spinlock.

What's the problem?

When the waiter is on the stack, the umr_context" variable may be
about to be relased, and then the "wake_up()" may end up accessing the
umr_context waitqueue spinlock after it has already become something
else.

This is unlikely, but it's very much one of the things that a
"completion" is all about. A completion (along with a plain spinlock)
is guaranteed to be synchronous in a way that semaphores and
wait-queues are *not*, so that when somebody has done "complete()",
there is no access to the variable that can race.

So no. A wait-queue wakeup is NOT AT ALL the same thing as a completion.

There really is a very real reason why "complete()" exists, and why it
is used for one-time initializations like this. "complete()" along
with spinlocks are synchronous in ways that other concepts are not.

                  Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
