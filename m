From: "Liran Liss" <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: RDMAoE / lossless Ethernet (ewg: SC'09 BOF - Meeting notes)
Date: Thu, 24 Dec 2009 10:40:58 +0200
Message-ID: <2ED289D4E09FBD4D92D911E869B97FDD0222EFDF@mtlexch01.mtl.com>
References: <2ED289D4E09FBD4D92D911E869B97FDD01AF10F2@mtlexch01.mtl.com><4B31D048.5040001@voltaire.com><adahbrh1yd0.fsf@roland-alpha.cisco.com><15ddcffd0912231412y8f6724fh5a7036f30117189e@mail.gmail.com> <adad42519n5.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <adad42519n5.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Richard Frank <richard.frank-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Grun <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I second...

Note that even with a "single VL", no endpoint can freeze the fabric -
if a multicast receiver has gone to breakfast it would just loose its
own packets rather than introducing congestion.
The only way an end-node can cause congestion is if its internal buses
don't match the IB link's BW, but this is unrelated to (lack of)
transport-level flow control.
--Liran


-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
[mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Roland Dreier
Sent: Thursday, December 24, 2009 2:47 AM
To: Or Gerlitz
Cc: Or Gerlitz; Liran Liss; Yevgeny Petrilin; Richard Frank; Sean Hefty;
Linux RDMA list; Paul Grun
Subject: Re: RDMAoE / lossless Ethernet (ewg: SC'09 BOF - Meeting notes)


 > To start with, no matter how many data VLs are used (e.g one), all
the  > crucial management traffic (SMPs) go on VL15 which is on the one
hand  > lossy and on the other hand not subject to congestion when other
VLs  > are. Now how would you manage your Cisco switch --remotely-- on a
> globally paused fabric when some multicast receiver hasn't had its  >
breakfast and now slows the sender while filling the queues throughout
> the congestion tree where this switch is part of?

There's not really an analog of QP0/VL15 traffic in IBoE (no SM, etc).
The analog of switch management traffic would either be on a separate
management network (and I wouldn't be surprised if many IBoE fabrics
have 100 meg management networks next to the 10/40G data fabric), or
would be QP1 traffic on the same data VL.  Yes this leads to problems if
the fabric is congested but many IB production fabrics seem to cope.

As I said, DCB is definitely useful for IBoE and also has many
advantages even for non-RDMA deployments, but conversely I think IBoE
may be useful in production, even in non-DCB classical ethernet fabrics.

 > To continue with, lossless is good, but to make your cluster usable
> under congestion, you need congestion control, that is QCN, which is
> designed/optimized to the case of multiple TCs.

I am not aware of a single production deployment of IB congestion
management.  So clearly it's a "nice to have" but again not a prereq for
production use.

 > Also, IBoE can potentially find its way to much more complex  >
environments than IB has, specifically, to clusters whose hosts are  >
acting as hypervisors running many many VMs and the underlying fabrics
> does consolidates many types of traffic, globally pausing a port can
> dramatically reduce the efficiency of such computing center which  >
probably was built originally to increase efficiency.

Sure, DCB is very useful, in many environments.  And maybe even a
requirement sometimes.  I'm simply trying to say that IBoE with
classical ethernet is at least as useful as standard IB in many cases
(IBoE without DCB is roughly equivalent to IB without QoS, and most IB
deployments still don't use QoS).

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
