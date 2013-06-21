From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: Revert pinned_vm braindamage
Date: Thu, 20 Jun 2013 23:25:31 -0700
Message-ID: <CAG4TOxNp8hrsC-1hbxGaR+xoUJYqUNv+sen4baukNCtASCwXOw@mail.gmail.com>
References: <20130606124351.GZ27176@twins.programming.kicks-ass.net>
 <0000013f1ad00ec0-9574a936-3a75-4ccc-a84c-4a12a7ea106e-000000@email.amazonses.com>
 <20130607110344.GA27176@twins.programming.kicks-ass.net> <0000013f1f1f79d1-2cf8cb8c-7e63-4e83-9f2b-7acc0e0638a1-000000@email.amazonses.com>
 <20130617110832.GP3204@twins.programming.kicks-ass.net> <0000013f536c60ee-9a1ca9da-b798-416a-a32e-c896813d3bac-000000@email.amazonses.com>
 <20130620114943.GB12125@gmail.com> <0000013f620f4699-f484f28e-3d12-4560-adfe-3b00af995fd9-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0000013f620f4699-f484f28e-3d12-4560-adfe-3b00af995fd9-000000-p/GC64/jrecnJqMo6gzdpkEOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Motohiro KOSAKI <kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 20, 2013 at 7:48 AM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:
> There is no way that user space can initiate a page pin right now. Perf is
> pinning the page from the kernel. Similarly the IB subsystem pins memory
> meeded for device I/O.

Christoph, your argument would be a lot more convincing if you stopped
repeating this nonsense.  Sure, in a strict sense, it might be true
that the IB subsystem in the kernel is the code that actually pins
memory, but given that unprivileged userspace can tell the kernel to
pin arbitrary parts of its memory for any amount of time, is that
relevant?  And in fact taking your "initiate" word choice above, I
don't even think your statement is true -- userspace initiates the
pinning by, for example, doing an IB memory registration (libibverbs
ibv_reg_mr() call), which turns into a system call, which leads to the
kernel trying to pin pages.  The pages aren't unpinned until userspace
unregisters the memory (or causes a cleanup by closing the context
fd).

Here's an argument by analogy.  Would it make any sense for me to say
userspace can't mlock memory, because only the kernel can set
VM_LOCKED on a vma?  Of course not.  Userspace has the mlock() system
call, and although the actual work happens in the kernel, we clearly
want to be able to limit the amount of memory locked by the kernel ON
BEHALF OF USERSPACE.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
