From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from
 misinterpreted flag
Date: Fri, 20 Oct 2017 19:04:33 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB6347E59B@CRSMSX101.amr.corp.intel.com>
References: <20171019213859.26124.37851.stgit@phlsvslse11.ph.intel.com>
 <20171020073724.GY2106@mtr-leonro.local>
 <3F128C9216C9B84BB6ED23EF16290AFB6347E3BF@CRSMSX101.amr.corp.intel.com>
 <20171020162017.GZ2106@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171020162017.GZ2106-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Ruhl, Michael J" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Leon Romanovsky
> Sent: Friday, October 20, 2017 12:20 PM
> To: Wan, Kaike
> Cc: Ruhl, Michael J; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from
> misinterpreted flag
> 
> On Fri, Oct 20, 2017 at 12:18:02PM +0000, Wan, Kaike wrote:
> > The nlmsg_flags from 0x100 and up have always been overloaded for
> different requests, as shown in include/uapi/linux/netlink.h:
> 
> Exactly, they are overloaded in include/uapi/linux/netlink.h where all nlmsg
> flags are declared and not in some random rdma*.h file.

Since they are known to be overloaded, how could you depend on the flags to make decision for all requests/responses?

The reason for defining RDMA_NL_LS_F_ERR in include/uapi/rdma/rdma_netlink is that all LS related defines and structures are defined in the file. It is true that it can lead to misuse, just like the current code. However, the defines in include/uapi/linux/netlink.h un-mistakenly indicate that those bits can be overloaded. 

> 
> But it is not my main point.
> 
> My main point is lack of usage of NLMSG_ERROR messages to inform about
> errors, exactly as kernel informs users about errors in netlink, but in the
> opposite direction.

The difference is that the LS needs all the original information (request type, client index, msg_seq, etc) to match the response with the original request. Therefore, the easiest thing to do is to return the response with the original info plus an error flag, instead of using the NLMSG_ERROR message.

> > >
> > > In meanwhile, can we implement dummy dumpit functions for the LS,
> > > which reuse ib_nl_is_good_ip_resp?
> >
> > Why do you want to jump all the dump hoops instead of directly calling the
> response handler? LS is different from other netlink channels in that it sends
> request from kernel to user space and receives responses from it instead of
> the other way around. Consequently, the handling of netlink responses may
> be different from handing requests from user space.
> >
> 
> Doesn't the part of email below answers on the question "why"?

No. A response should not necessarily be processed the same as a request.

> 
> > >
> > > I prefer this solution over yours, because it doesn't mix
> > > LS-specifics with general decision function and leaves LS anomalies in the
> LS-relevant code.
> 
> 
> > >
> > > And returning 0 in absence of dumpit function as a response with
> > > NLM_F_DUMP flag is wrong. User should be aware of the fact that
> > > something wrong was with his request.
> > >
> > > Thanks
> > >
> >
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
