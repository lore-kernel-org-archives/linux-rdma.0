From: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH v1 for-next 06/16] IB/core: Implement support for MMU
 notifiers regarding on demand paging regions
Date: Sun, 7 Sep 2014 14:35:59 +0000
Message-ID: <6B2A6E60C06CCC42AE31809BF572352B010E2442C7@MTLDAG02.mtl.com>
References: <20140904202458.GB2685@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140904202458.GB2685-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "1404377069-20585-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <1404377069-20585-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jerome Glisse  <IMCEAMAILTO-j+2Eglisse+40gmail+2Ecom-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jerome Glisse [mailto:j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Thursday, September 04, 2014 11:25 PM
> To: Haggai Eran; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Shachar Raindel; Sagi Grimberg
> Subject: Re: [PATCH v1 for-next 06/16] IB/core: Implement support for
> MMU notifiers regarding on demand paging regions
> 
> > * Add an interval tree implementation for ODP umems. Create an
> interval tree
> >   for each ucontext (including a count of the number of ODP MRs in
> this
> >   context, mutex, etc.), and register ODP umems in the interval tree.
> > * Add MMU notifiers handling functions, using the interval tree to
> notify only
> >   the relevant umems and underlying MRs.
> > * Register to receive MMU notifier events from the MM subsystem upon
> ODP MR
> >   registration (and unregister accordingly).
> > * Add a completion object to synchronize the destruction of ODP umems.
> > * Add mechanism to abort page faults when there's a concurrent
> invalidation.
> >
> > The way we synchronize between concurrent invalidations and page
> faults is by
> > keeping a counter of currently running invalidations, and a sequence
> number
> > that is incremented whenever an invalidation is caught. The page fault
> code
> > checks the counter and also verifies that the sequence number hasn't
> > progressed before it updates the umem's page tables. This is similar
> to what
> > the kvm module does.
> >
> > There's currently a rare race in the code when registering a umem in
> the
> > middle of an ongoing notifier. The proper fix is to either serialize
> the
> > insertion to our umem tree with mm_lock_all or use a ucontext wide
> running
> > notifiers count for retries decision. Either is ugly and can lead to
> some sort
> > of starvation. The current workaround is ugly as well - now the user
> can end
> > up with mapped addresses that are not in the user's address space
> (although it
> > is highly unlikely).
> 
> I have been trying to wrap my head around this comment. I am totaly
> unfamiliar
> with RDMA code, but from quick look at it when registering umem you take
> the
> mmap_sem in read mode so any munmap from userspace would be serialize.
> Really
> the worst that can happen is that a umem pointing to a mmaped file that
> is
> concurently truncated but even then the address is still valid, but it
> should
> result in a SIGBUS which here is obviously harder to report (again dunno
> how
> RDMA works).
> 
> So am i missing something ?
> 

Sadly, taking mmap_sem in read-only mode does not prevent all possible invalidations from happening.
For example, a call to madvise requesting MADVISE_DONTNEED will lock the mmap_sem for reading only, allowing a notifier to run in parallel to the MR registration As a result, the following sequence of events could happen:

Thread 1:                       |   Thread 2
--------------------------------+-------------------------
madvise                         |
down_read(mmap_sem)             |
notifier_start                  |
                                |   down_read(mmap_sem)
                                |   register_mr
notifier_end                    |
reduce_mr_notifiers_count       |

The end result of this sequence is an mr with running notifiers count of -1, which is bad.
The current workaround is to avoid decreasing the notifiers count if it is zero, which can cause other issues.
The proper fix would be to prevent notifiers from running in parallel to registration. For this, taking mmap_sem in write mode might be sufficient, but we are not sure about this.
We will be happy to hear additional input on this subject, to make sure we got it covered properly.

Thanks,
--Shachar
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
