From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: =?iso-8859-1?Q?Na=EFv?= =?iso-8859-1?Q?e?= question wrt
	ibv_reg_mr(), pinned pages and Linux VM
Date: Mon, 15 Mar 2010 09:52:59 +0200
Message-ID: <20100315075259.GB23358@mtldesk030.lab.mtl.com>
References: <20100314102239.GA23358@mtldesk030.lab.mtl.com>
	<C7C25E98.10DB%tim.wright@rnanetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <C7C25E98.10DB%tim.wright-c+vHNXOUHMmEK/hMebVsMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tim Wright <tim.wright-c+vHNXOUHMmEK/hMebVsMw@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Mar 14, 2010 at 12:36:26PM -0400, Tim Wright wrote:
> Hi Eli,
> Thank you for replying. Yes the call succeeds and the memory is clearly pinned at least from the perspective of the kernel, and the RDMA operations do happen on the correct memory. The problem is that the pages get stolen from the resident set of the program, which is inefficient, and doesn't seem to make a lot of sense since it doesn't free much of anything since the memory is locked. What does seem to  happen under load is that the process page tables can get kicked out making access to the pinned memory very slow. Of course other parts of the application are also subject to paging, so mlock is really necessary anyway, but I was surprised that the memory was only pinned into physical memory and not also locked into the calling process' address space.
> 
> For my purposes, it seems mlockall() is the solution, and it appears to interact just fine with the underlying get_user_pages() operations.

I see your point and I think you're right. I beleive the reason for
this is that the kernel does not know in advance that it is bound to
fail releasing the page (that's because get_user_pages() takes a
reference on it) so it tries swapping out the prcoess's page.
mlocking the memory seems to do the work. If you'd had more memory
then maybe you would not face this problem from the beginning.
In the early days of IB we used to do mlock to lock the pages but it
was not trivial to find the physical pages. Now we call
get_user_pages() which gives us the list of pages.
I wonder how bad is the effect of paging in the pages again. After
all, the correct page should be found quite fast since it does not
have to be allocated again, only to be found.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
