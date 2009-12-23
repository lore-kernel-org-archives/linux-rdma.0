From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMAoE / lossless Ethernet (ewg: SC'09 BOF - Meeting notes)
Date: Thu, 24 Dec 2009 00:12:48 +0200
Message-ID: <15ddcffd0912231412y8f6724fh5a7036f30117189e@mail.gmail.com>
References: <2ED289D4E09FBD4D92D911E869B97FDD01AF10F2@mtlexch01.mtl.com>
	 <4B31D048.5040001@voltaire.com>
	 <adahbrh1yd0.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adahbrh1yd0.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Richard Frank <richard.frank-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Grun <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:

> I agree that implementing DCB is important for IBoE, but why do you s=
ay
> that a classical ethernet fabric with global pause isn't usable? =A0T=
hat
> should be roughly equivalent to an IB fabric that uses only a single =
VL,
> which is the case for many production IB fabrics.

To start with, no matter how many data VLs are used (e.g one), all the
crucial management traffic (SMPs) go on VL15 which is on the one hand
lossy and on the other hand not subject to congestion when other VLs
are. Now how would you manage your Cisco switch --remotely-- on a
globally paused fabric when some multicast receiver hasn't had its
breakfast and now slows the sender while filling the queues throughout
the congestion tree where this switch is part of?

To continue with, lossless is good, but to make your cluster usable
under congestion, you need congestion control, that is QCN, which is
designed/optimized to the case of multiple TCs.

Also, IBoE can potentially find its way to much more complex
environments than IB has, specifically, to clusters whose hosts are
acting as hypervisors running many many VMs and the underlying fabrics
does consolidates many types of traffic, globally pausing a port can
dramatically reduce the efficiency of such computing center which
probably was built originally to increase efficiency.

I believe that the ixgbe team well understand that, and hence their
continued DCB efforts can make the combination of RXE with
Niantic/ixgbe very intresting to test.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
