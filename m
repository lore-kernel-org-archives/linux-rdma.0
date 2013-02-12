From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 for-next 2/6] IB/core: Add RSS and TSS QP groups
Date: Tue, 12 Feb 2013 17:27:50 +0200
Message-ID: <511A5F76.3010402@mellanox.com>
References: <1360079337-8173-1-git-send-email-ogerlitz@mellanox.com> <1360079337-8173-3-git-send-email-ogerlitz@mellanox.com> <1828884A29C6694DAF28B7E6B8A8237368B99E0B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237368B99E0B-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/02/2013 22:42, Hefty, Sean wrote:
>> RSS (Receive Side Scaling) TSS (Transmit Side Scaling, better known as
>> MQ/Multi-Queue) are common networking techniques which allow to use
>> contemporary NICs that support multiple receive and transmit descriptor
>> queues (multi-queue), see also Documentation/networking/scaling.txt
> If TSS is better known as MQ, then why not use that term instead?

Well, maybe saying that TSS is better known as MQ was too definitive in 
that context, Linux now
support MQ for networking driver on both the RX and TX rings, e.g 
through both in-kernel netdev
APIs and to user space too through ethtool and friends that allow you to 
configure the number
of RX/TX rings etc. RSS is well known term, and we found the term TSS to 
have good fit here as the TX
equivalent of RSS.


>
>> - qp group type attribute for qp creation saying whether this is a parent QP
>> or rx/tx (rss/tss) child QP or none of the above for non rss/tss QPs.
> Can we either define this as a new QP type or some QP creation flag, so that every user who wants to create a QP doesn't need to figure out what a QP group is and if their QP needs to be part of one? Then you wouldn't need to define IB_QPG_NONE.

understood, basically I don't see why this change can't be done. In a 
response to earlier posting of these patches, Tzahi Oved from Mellanox 
wrote on the same matter "Reg ib_qp_init_attr and ib_qp_type, since 
RSS/TSS child/parent attributes can be defined for multiple QP types 
(today IB_QPT_UD and IB_QPT_RAW_PACKET), we believe it is cleaner to 
have another attribute of ib_qpg_type." 
http://marc.info/?l=linux-rdma&m=134486836225450&w=2 any way, this isn't 
the hard core part of the suggested changes, so we should be able to 
nail that this way (current proposal) or another (yours) somehow.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
