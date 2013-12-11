From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V5 7/8] IB/uverbs: Resolve Ethernet L2 addresses when
 modifying QP
Date: Wed, 11 Dec 2013 09:59:49 -0800
Message-ID: <CAG4TOxMgHuC=rzB+8stotaeKqwxipz06s_B2zogMMqNn3ZWTOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, monis <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 19, 2013 at 8:09 PM, Devesh Sharma <Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wrote:
> Hi Roland,
>
> I agree with Or. RDMA-CM takes care of resolving l2 addresses for kernel ULP and there are no _non-rdma-cm_ ULP right now in the IB-kernel-stack. On the other hand, for the user-space applications, which uses RDMA-CM V5 is a simplified approach. All the patches =< v4 was an effort to change RDMA-CM and it changed entire user/kernel interface of rdma-cm and verbs, this was not acceptable.
>
> With V5 patch-set I still have a concern about those user apps which does not use rdma-cm (e.g. ib_send_bw without -R option) how DMAC and SMAC will be resolved?

OK, I guess I'm still confused.  Do we have two ways of resolving
addresses, one way for consumers that use the RDMA CM and another way
for consumers that don't?  Does that mean we end up having two
different paths through core verbs?  Even if we put address resolution
in uverbs, how do user apps that *do* use librdmacm work?

Also the statement that there are no non-rdma-cm consumers in the
kernel is definitely false -- the SRP initiator does not use IP
addressing, and it does seem like a legitimate and useful application
to run SRP over ethernet.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
