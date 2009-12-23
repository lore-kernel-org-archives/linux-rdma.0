From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMAoE / lossless Ethernet (ewg: SC'09 BOF - Meeting notes)
Date: Wed, 23 Dec 2009 07:52:43 -0800
Message-ID: <adahbrh1yd0.fsf@roland-alpha.cisco.com>
References: <2ED289D4E09FBD4D92D911E869B97FDD01AF10F2@mtlexch01.mtl.com>
	<4B31D048.5040001@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B31D048.5040001-smomgflXvOZWk0Htik3J/w@public.gmane.org> (Or Gerlitz's message of "Wed, 23
	Dec 2009 10:09:44 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Frank <richard.frank-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Grun <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > Liran, I would say that OTOH global pause isn't the way to go and OTHO
 > IB RC functions quite bad when many packets are lost. As such RDMAoE
 > without PFC and mapping priorities into TCs (the Ethernet VLs) isn't
 > really for production, for any non trivial environment involving more
 > then one hop. Also, this email is from one month ago, any news on the
 > patches?

I agree that implementing DCB is important for IBoE, but why do you say
that a classical ethernet fabric with global pause isn't usable?  That
should be roughly equivalent to an IB fabric that uses only a single VL,
which is the case for many production IB fabrics.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
