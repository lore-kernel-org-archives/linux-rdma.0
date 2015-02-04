From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 for-next 3/4] IB/core: Make sure that the PSN does not
 overflow
Date: Wed, 4 Feb 2015 16:28:07 -0700
Message-ID: <20150204232807.GA30154@obsidianresearch.com>
References: <1422522871-11216-1-git-send-email-ogerlitz@mellanox.com>
 <1422522871-11216-4-git-send-email-ogerlitz@mellanox.com>
 <20150129175437.GF11842@obsidianresearch.com>
 <54CE0F0A.7080704@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54CE0F0A.7080704-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 01, 2015 at 01:33:30PM +0200, Or Gerlitz wrote:

> >>@@ -860,6 +860,12 @@ int ib_modify_qp_is_ok(enum ib_qp_state cur_state, enum ib_qp_state next_state,
> >>  	if (mask & ~(req_param | opt_param | IB_QP_STATE))
> >>  		return 0;
> >>+	if ((mask & IB_QP_SQ_PSN) && (attr->sq_psn & 0xff000000))
> >>+		return 0;
> >>+
> >>+	if ((mask & IB_QP_RQ_PSN) && (attr->rq_psn & 0xff000000))
> >>+		return 0;
> >>+

> >And since rdmacm has had this longstanding bug of generating > 24
> >bit PSNs, this change seems really scary - very likely to break
> >working systems.
 
> By IBTA the HW can only use 24 bits, also the IB CM also makes sure
> to only encode/decode 24 PSN bits to/from the wire (see the PSN
> related helpers in drivers/infiniband/core/cm_msgs.h), so in that
> respect, I don't see what other bits which are not 24 bits out of
> the 32 generated ones could be of some use to existing applications,
> please clarify.

Maybe you can explain why this check is suddenly important now? It
seems risky with no rational?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
