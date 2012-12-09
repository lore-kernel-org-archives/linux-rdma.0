From: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [RFC] osm_log printing incorrectly assumes that pthread_t
 is not opaque type
Date: Sun, 9 Dec 2012 11:56:55 -0800
Message-ID: <CAGH67wQ=-Mn3_HMy7=VOT2am99qbjrXcOpC6+_PCSW6xuyVvRA@mail.gmail.com>
References: <alpine.BSF.2.00.1212090125590.64779@toaster.local>
	<75EE638CB68A864F90627D3D06A189A859350715@MTRDAG01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <75EE638CB68A864F90627D3D06A189A859350715-SlGPd/IId7auSA5JZHE7gA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Alex,

On Sun, Dec 9, 2012 at 9:43 AM, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Hi Garrett,
>
>> Hi,
>>       When porting a newer version of OFED to FreeBSD and running the
>> compile against clang with all of the warnings enabled, I ran into build
>> failures because osm_log, etc assumes that pthread_t is an integral type
>> (which is valid on Linux, but not necessarily correct on other platforms). The
>> fix I implemented was attached, but that doesn't necessarily seem correct
>> either, so I was wondering what was trying to be gained by printing out the
>> thread ID (especially because syslog(9) isn't necessarily an asynch safe
>> syscall [1]).
>
> One reason to use "sort of thread id" would be to determine specific flows,
> when looking through the log. Why it's important to use async-safe functions
> in that case?

Seems reasonable (and that was my guess, but I wanted to check :)..).

> I think that instead of using pthread_self(), it's better to use gettid() in Linux
> case. Is there any equivalent for this in BSD?

There isn't really, but there's an undocumented macro that gets to the
thread ID from a 'struct pthread' object (the "opaque type" for
pthread_t on FreeBSD). From lib/libthr/thread/thr_private.h:

336 /*
337  * lwpid_t is 32bit but kernel thr API exports tid as long type
338  * in very earily date.
339  */
340 #define TID(thread)     ((uint32_t) ((thread)->tid))

Need to check with the POSIX folks and freebsd-standards@ to see
whether or not we can get something properly standardized between
FreeBSD and Linux to handle this; being able to know the thread ID for
logging seems like a reasonable request that should be fulfilled in
multithreaded applications that the standards folks just seem to have
overlooked when creating the pthread APIs (it would also be
interesting to see whether or not C11 resolves this, but I hear it
introduces another can of worms with its half-baked threading
implementation).

Thanks,
-Garrett
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
