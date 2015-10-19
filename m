From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 15/23] staging/rdma/hfi1: Implement Expected Receive TID
 caching
Date: Mon, 19 Oct 2015 09:54:52 -0700
Message-ID: <20151019165452.GB30921@kroah.com>
References: <1445273027-29634-1-git-send-email-ira.weiny@intel.com>
 <1445273027-29634-16-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1445273027-29634-16-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 19, 2015 at 12:43:39PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Expected receives work by user-space libraries (PSM) calling into the driver
> with information about the user's receive buffer and have the driver DMA-map
> that buffer and program the HFI to receive data directly into it.
> 
> This is an expensive operation as it requires the driver to pin the pages which
> the user's buffer maps to, DMA-map them, and then program the HFI.
> 
> When the receive is complete, user-space libraries have to call into the driver
> again so the buffer is removed from the HFI, un-mapped, and the pages unpinned.
> 
> All of these operations are expensive, considering that a lot of applications
> (especially micro-benchmarks) use the same buffer over and over.
> 
> In order to get better performance for user-space applications, it is highly
> beneficial that they don't continuously call into the driver to register and
> unregister the same buffer. Rather, they can register the buffer and cache it
> for future work. The buffer can be unregistered when it is freed by the user.
> 
> This change implements such buffer caching by making use of the kernel's MMU
> notifier API. User-space libraries call into the driver only when the need to
> register a new buffer.
> 
> Once a buffer is registered, it stays programmed into the HFI until the kernel
> notifies the driver that the buffer has been freed by the user. At that time,
> the user-space library is notified and it can do the necessary work to remove
> the buffer from its cache.
> 
> Buffers which have been invalidated by the kernel are not automatically removed
> from the HFI and do not have their pages unpinned. Buffers are only completely
> removed when the user-space libraries call into the driver to free them.  This
> is done to ensure that any ongoing transfers into that buffer are complete.
> This is important when a buffer is not completely freed but rather it is
> shrunk. The user-space library could still have uncompleted transfers into the
> remaining buffer.
> 
> With this feature, it is important that systems are setup with reasonable
> limits for the amount of lockable memory.  Keeping the limit at "unlimited" (as
> we've done up to this point), may result in jobs being killed by the kernel's
> OOM due to them taking up excessive amounts of memory.
> 
> This commit also includes some code clean-up and rearrangement to make the
> driver code base easier to maintain and develop.

Please do cleanup and rearrangement in a separate patch (ideally before
this one) as this is impossible to review as-is.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
