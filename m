From: "leon-2ukJVAZIZ/Y@public.gmane.org" <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH for kernel v4.6] IB/srpt: Revert "Convert to percpu_ida
 tag allocation"
Date: Fri, 1 Apr 2016 06:45:09 +0300
Message-ID: <20160401034509.GB8565@leon.nu>
References: <56FDBA63.7010804@sandisk.com>
 <20160401030322.GH2670@leon.nu>
 <56FDE739.9090801@sandisk.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56FDE739.9090801-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 31, 2016 at 08:12:57PM -0700, Bart Van Assche wrote:
> On 03/31/16 20:05, Leon Romanovsky wrote:
> >On Thu, Mar 31, 2016 at 05:01:39PM -0700, Bart Van Assche wrote:
> >>That patch is wrong because it makes the ib_srpt driver use I/O
> >>contexts allocated by transport_alloc_session_tags() but it does
> >>not initialize these I/O contexts properly.
> >
> >Did you have a chance to see which initializations are missing in this
> >case? What is needed to do if we decide to fix original patch?
> >
> >Except these questions, the revert is fine :)
> >Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Hello Leon,
> 
> Thanks for the review. The initializations that are missing from that patch
> are the 'buf' pointer in the srpt_ioctx structure and mapping that buffer
> for DMA.

Generally speaking you can call to srpt_alloc_ioctx or something
similar to perform mapping, right after that line
+       ioctx = &((struct srpt_send_ioctx *)se_sess->sess_cmd_map)[tag];

> Another bug introduced by that patch is that it doubles the amount
> of memory that is allocated for I/O contexts. New I/O context allocations
> were added by that patch but the existing I/O context allocation code was
> not removed.

It should be easy to fix, just delete it.

> 
> Regarding reconsidering the original patch: before we do that it has to be
> shown with numbers that the percpu_ida conversion does not decrease
> performance. This is something I had already asked two months ago. See also
> http://thread.gmane.org/gmane.linux.scsi.target.devel/11253/focus=110559.

I don't think that performance was the main goal of that patch set. In
addition, percpu_ida is supposed allocate tags on the percpu list which
will give the same performance as initial code.

> 
> Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
