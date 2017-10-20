From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from
 misinterpreted flag
Date: Fri, 20 Oct 2017 12:18:02 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB6347E3BF@CRSMSX101.amr.corp.intel.com>
References: <20171019213859.26124.37851.stgit@phlsvslse11.ph.intel.com>
 <20171020073724.GY2106@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171020073724.GY2106-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Ruhl, Michael J" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Leon Romanovsky
> Sent: Friday, October 20, 2017 3:37 AM
> To: Ruhl, Michael J
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from
> misinterpreted flag
> >
> > The issue is that in rdma_nl_rcv_msg(), the check 'if (flags &
> > NLM_F_DUMP)' is not completely correct.
> >
> > NLM_F_DUMP is two bits NLM_F_ROOT | NLM_F_MATCH.
> >
> > ibacm sends a RDMA_NL_LS response with the RDMA_NL_LS_F_ERR bit set
> if
> > an error occurs in the service (like no provider being available, or
> > ACM_STATUS_ENODATA, etc.).
> >
> > NLM_F_ROOT == (0x100) == RDMA_NL_LS_F_ERR.
> >
> > The current code thinks that it sees a NLM_F_DUMP flag and incorrectly
> > calls the .dump() callback.
> 
> Hi Michael,
> 
> Thanks for the report and for excellent analysis, You are right that
> RDMA_NL_LS_F_ERR has the same value as NLM_F_ROOT and it is bad, but I
> just think that it is not the final root cause.
> 
> In case of errors, the LS was supposed to send NLMSG_ERROR message and
> not overload general nlmsg_flags, which is awful. However I don't know if it
> is feasible to fix current implementation without breaking UAPI contract.

The nlmsg_flags from 0x100 and up have always been overloaded for different requests, as shown in include/uapi/linux/netlink.h:

* Modifiers to GET request */
#define NLM_F_ROOT	0x100	/* specify tree	root	*/
#define NLM_F_MATCH	0x200	/* return all matching	*/
#define NLM_F_ATOMIC	0x400	/* atomic GET		*/
#define NLM_F_DUMP	(NLM_F_ROOT|NLM_F_MATCH)

/* Modifiers to NEW request */
#define NLM_F_REPLACE	0x100	/* Override existing		*/
#define NLM_F_EXCL	0x200	/* Do not touch, if it exists	*/
#define NLM_F_CREATE	0x400	/* Create, if it does not exist	*/
#define NLM_F_APPEND	0x800	/* Add to end of list		*/

/* Modifiers to DELETE request */
#define NLM_F_NONREC	0x100	/* Do not delete recursively	*/

/* Flags for ACK message */
#define NLM_F_CAPPED	0x100	/* request was capped */
#define NLM_F_ACK_TLVS	0x200	/* extended ACK TVLs were included *

The NLM_F_DUMP flag is supposed to be used for the GET request only, not as a general flag for all netlink requests.

> 
> In meanwhile, can we implement dummy dumpit functions for the LS, which
> reuse ib_nl_is_good_ip_resp?

Why do you want to jump all the dump hoops instead of directly calling the response handler? LS is different from other netlink channels in that it sends request from kernel to user space and receives responses from it instead of the other way around. Consequently, the handling of netlink responses may be different from handing requests from user space.

> 
> I prefer this solution over yours, because it doesn't mix LS-specifics with
> general decision function and leaves LS anomalies in the LS-relevant code.
> 
> And returning 0 in absence of dumpit function as a response with
> NLM_F_DUMP flag is wrong. User should be aware of the fact that
> something wrong was with his request.
> 
> Thanks
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
