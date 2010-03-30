From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rds: use IB_CQ_REPORT_MISSED_EVENTS to avoid missed
 CQ callbacks
Date: Tue, 30 Mar 2010 16:50:53 -0700
Message-ID: <1269993053.4192.235.camel@chromite.mv.qlogic.com>
References: <1269987841.4192.228.camel@chromite.mv.qlogic.com>
	 <adaeij1v14z.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaeij1v14z.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2010-03-30 at 16:30 -0700, Roland Dreier wrote:
> > OpenFabrics added a IB_CQ_REPORT_MISSED_EVENTS flag to detect this
> 
> OpenFabrics?  Funny, I thought I added that flag.

You did. I can change the comment if you like.

> (This is not a serious objection ... I'm just being annoying.  Being
> serious, I'm happy to see this used outside of IPoIB and this looks like
> a good optimization)
> 
>  > This patch by itself should improve RDS performance over QLogic HCAs
> 
> Out of curiousity have you measured an improvement?

It is a great improvement over a bunch of printks and then
hitting BUG_ON() in __rds_ib_ring_used().

An actual performance difference will have to wait until
the underlying race is better understood. I thought this
patch might spark a discussion since the code in
rds_ib_send_cq_comp_handler() calls printk_ratelimit()
so the 0xdead message must have been seen before enough
to warrant adding the call and the comment:
/* In the error case, wc.opcode sometimes contains garbage */


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
