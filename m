From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V2 for-next 2/6] IB/core: Add RSS and TSS QP groups
Date: Mon, 11 Feb 2013 20:42:42 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237368B99E0B@ORSMSX101.amr.corp.intel.com>
References: <1360079337-8173-1-git-send-email-ogerlitz@mellanox.com>
 <1360079337-8173-3-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360079337-8173-3-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> RSS (Receive Side Scaling) TSS (Transmit Side Scaling, better known as
> MQ/Multi-Queue) are common networking techniques which allow to use
> contemporary NICs that support multiple receive and transmit descriptor
> queues (multi-queue), see also Documentation/networking/scaling.txt

If TSS is better known as MQ, then why not use that term instead?

> - qp group type attribute for qp creation saying whether this is a parent QP
> or rx/tx (rss/tss) child QP or none of the above for non rss/tss QPs.

Can we either define this as a new QP type or some QP creation flag, so that every user who wants to create a QP doesn't need to figure out what a QP group is and if their QP needs to be part of one?

Then you wouldn't need to define IB_QPG_NONE.
 
> - per qp group type, another attribute is added, for parent QPs, the number
> of rx/tx child QPs and for child QPs pointer to the parent.

If I understand the interface correctly, the user calls ib_create_qp() to create a parent QP and reserve space for all of the children.  They then call ib_create_qp() to allocate the children.  Is this correct?

What restrictions does a child QP have based on the parent?  E.g. same PD, CQ, QP size <= parent, number SGEs <= parent, destroyed with parent, etc.  And how independent is a child QP?  E.g. joins own multicast groups, different CQs, transitions states independently, etc.

It's not clear to me if using the existing interfaces are the best approach, if MQ is best handled as different QPs, if MQ is better abstracted as a 'QP' that has multiple send/receive queues, if MQ should just be completely hidden beneath verbs, or what.

The XRC model of creating the parent and using open to associated related QPs still seems more appropriate, but it depends on how independent the parent and child QPs are.  We don't have a spec (formal or informal) that defines how the verbs function with these new QP types, which makes reviewing these changes difficult.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
