From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC] IB/uverbs: Add support for passing memory region
 invalidations to userspace
Date: Thu, 14 Oct 2010 18:50:59 +0200
Message-ID: <20101014165059.GB13969@mtldesk30>
References: <adaiq181226.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adaiq181226.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 11, 2010 at 09:13:05PM -0700, Roland Dreier wrote:
> Hi everyone,
> 
> I think I've finally gotten my revision of ummunotify to live within
> userspace verbs into a reasonable state.  I've done no testing beyond
> compiling it and reading over the code -- in fact, I haven't even
> implemented the corresponding support in libibverbs -- but I wanted to
> get this out so that people can take a look.
> 
> Given that we are probably no more than a week away from the 2.6.37
> merge window, I don't think this is appropriate for 2.6.37, but I
> definitely plan to get this into 2.6.38 unless there is some big problem
> I don't see right now.
> 
> As usual, all comments and criticisms welcome!

I made a review and overall it looks good. One comment though. Could
we add an option to ib_uverbs_dereg_mr_common() to deregister all
regions for which notifications have been received? This could relieve
anyone who does not wish to read the notifications from the
notifications channel but instead have it done automatically.
> 
>  
> +struct ib_uverbs_mmu_notify_event_desc {
> +	__u64 cq_handle;
I assume this is going to be mr_handle.
> +};
> +
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
