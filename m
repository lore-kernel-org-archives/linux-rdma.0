From: Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH V5 7/8] IB/uverbs: Resolve Ethernet L2 addresses when
 modifying QP
Date: Wed, 20 Nov 2013 07:15:27 +0000
Message-ID: <dad4986f-4b34-47dc-b6bb-b4882ad1405a@CMEXHTCAS2.ad.emulex.com>
References: <1384381792-2023-1-git-send-email-ogerlitz@mellanox.com>
	<1384381792-2023-8-git-send-email-ogerlitz@mellanox.com>
	<CAG4TOxOUFfPMU+q1yKy6S7v3QiLVgMQwxNC-_vw-7UeUb7LoBg@mail.gmail.com>
 <CAJZOPZ+5UJCAObzFjK5w=bnnSjRM102vR5Ft1nd4nO48Lr2HOg@mail.gmail.com>
 <EE7902D3F51F404C82415C4803930ACD3FD8348A@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EE7902D3F51F404C82415C4803930ACD3FD8348A-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, monis <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> I agree with Or. RDMA-CM takes care of resolving l2 addresses for kernel ULP
> and there are no _non-rdma-cm_ ULP right now in the IB-kernel-stack. On
> the other hand, for the user-space applications, which uses RDMA-CM V5 is a
> simplified approach. All the patches =< v4 was an effort to change RDMA-CM
> and it changed entire user/kernel interface of rdma-cm and verbs, this was
> not acceptable.

Agree as well.

> With V5 patch-set I still have a concern about those user apps which does not
> use rdma-cm (e.g. ib_send_bw without -R option) how DMAC and SMAC will
> be resolved?
> 
> However, in the approach to move address resolution to core verbs i.e.
> ib_modify_qp() and ib_create_ah(), vendor driver will have freedom to
> resolve l2 addresses in its own way.

This I am not sure if it's a good idea for each vendor driver to implement L2 address resolution in it's own way ?
Not sure if that was the intent behind Roland's statement ?

Thanks
Som


> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Or Gerlitz
> Sent: Wednesday, November 20, 2013 2:19 AM
> To: Roland Dreier
> Cc: Or Gerlitz; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; monis; matanb; Tzahi Oved; Moni
> Shoua
> Subject: Re: [PATCH V5 7/8] IB/uverbs: Resolve Ethernet L2 addresses when
> modifying QP
> 
> On Tue, Nov 19, 2013 at 8:08 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >> Existing user space applications provide only IBoE L3 address
> >> attributes to the kernel when they issue QP modify. To comply with
> >> them and let such apps to keep work transparently under the IBoE GID
> >> IP addressing changes, added Eth L2 address resolution in the user-kernel
> linking piece - uverbs.
> 
> > I don't get why this belongs in uverbs.  In the current design serves
> > as a transport between userspace and kernel and the kernel verbs are
> > the same as user verbs.  The only exception to this that introduces
> > complexity is the stuff related to sharing XRCs and that makes sense
> > because multiple processes etc. is definitely a userspace-only concern.
> 
> > However in this case I don't see why address resolution is something
> > only userspace cares about.  Wouldn't it make sense to put this
> > resolution in core verbs?
> 
> Basically, we've put it into uverbs b/c for kernel consumers that use the
> rdma-cm the problem doesn't exist, since the Ethernet L2 attributes are filled
> into the qp attributes used by the rdma-cm throughout the address
> resolution process.
> 
> Since currently there are no in-tree non rdma-cm cosumer ULPs that are
> applicable to RoCE, the kernel is done deal in that respect.
> 
> If it helps or/and make more sense, sure we can move the reslution to be
> done @ the core verbs, e.g in core/verbs.c :: ib_modify_qp, anything else
> expect for this feedback?
> 
> Or.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
