From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 for-next 2/6] IB/core: Add RSS and TSS QP groups
Date: Tue, 12 Feb 2013 18:46:55 +0200
Message-ID: <CAJZOPZ+eT=UGfqbwyMn8BtKCei2t1RKj1auAhSbPphLF9A6eVg@mail.gmail.com>
References: <1360079337-8173-1-git-send-email-ogerlitz@mellanox.com>
	<1360079337-8173-3-git-send-email-ogerlitz@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237368B99E0B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237368B99E0B-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

resending for the 3rd time, now from different address as the mail
server reject both prev postings...

On Mon, Feb 11, 2013 at 10:42 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> If I understand the interface correctly, the user calls ib_create_qp() to
> create a parent QP and reserve space for all of the children.  They then
> call ib_create_qp() to allocate the children.  Is this correct?

YES


> What restrictions does a child QP have based on the parent?  E.g. same PD,
> CQ, QP size <= parent, number SGEs <= parent, destroyed with parent, etc.
> And how independent is a child QP?  E.g. joins own multicast groups,
> different CQs, transitions states independently, etc.

These parent/child QPs are supported for UD and RAW_PACKET QP types,
and of course child and parent have to be of the same QP type.
A good (probably best) practice would be for the parent and child QPs
to use the same PD (and QKEY for UD QPs), it makes sense that we
enforce that on the core level.  Using the same CQ isn't required nor
similarity in the QP ring/sge size and whatever other attributes.

Currently its the HW driver role to dictate the QP number for created
QPs, an assumption taken by the architecture/design for the QP groups.

re RSS child QPs, under the proposed API, HW drivers are likely to
reserve consecutive range of QPNs for the childs. To meet certain HW
requirements, the driver may round up the number of requested RSS
children to be a power of two, and the consumer is expected to
actually open the rounded up number of QPs. This might somehow fell
between the cracks in the submitted code, we need to see how to nail
that corner. Other than that, no limitations.

re TSS child QPs, under the proposed API, HW drivers are likely to
reserve consecutive range of QPNs for the childs unless they support
the IB_DEVICE_UD_TSS capability which is set to indicate that the
device supports "HW TSS" which means that the HW is capable of
over-riding the source UD QPN present in sent IB datagram header (DTH)
with the parent's QPN.  This is irrelevant for RAW_PACKET Ethernet
QPs. Other than that, no limitations.


> It's not clear to me if using the existing interfaces are the best
> approach, if MQ is best handled as different QPs, if MQ is better abstracted
> as a 'QP' that has multiple send/receive queues, if MQ should just be
> completely hidden beneath verbs, or what.

We found it to be handled well as a different QP...


> The XRC model of creating the parent and using open to associated related
> QPs still seems more appropriate, but it depends on how independent the
> parent and child QPs are.  We don't have a spec (formal or informal) that
> defines how the verbs function with these new QP types, which makes
> reviewing these changes difficult.

As I explained above, parent and child QPs are pretty much
independent, re the XRC model,
Tzahi provided detailed answer why we didn't find a fit here, which if
I understand correct,
you accepted his arguments... again here
http://marc.info/?l=linux-rdma&m=134486836225450&w=2 and all thread
here http://marc.info/?t=133881099000001&r=1&w=2
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
