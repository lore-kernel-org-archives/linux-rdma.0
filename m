From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/3] IB/mlx4: Fix max_wqe capacity report for query device
Date: Fri, 25 May 2012 06:04:33 +0300
Message-ID: <CAJZOPZLvNHXkY9zakzVJqxYo1n=RYyRdpL6fVpchvo2GcmRLZQ@mail.gmail.com>
References: <1337864889-20886-1-git-send-email-ogerlitz@mellanox.com>
	<1337864889-20886-3-git-send-email-ogerlitz@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237346A23DD0@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A23DD0-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 24, 2012 at 6:42 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:

> I believe that I was *just* hitting into this bug.

Good, so we came just in time.

> I don't understand the part about breaking the ABI. =A0Why wouldn't y=
ou just
> return the correct values from the kernel? =A0Are the values being re=
turned
> now usable?

Addressing the 2nd part of your question, the patch makes sure that
the values returned now are usable for kernel consumers, as for user
consumers, that's work in done in the patches I just sent to libmlx4.

As for the 1st part, this goes back to that 2007 discussion... see
http://lists.openfabrics.org/pipermail/general/2007-October/042529.html
and following mails. So the way we went is to allow unpatched libmlx4
work with patched kernels, and patch libmlx4 separately

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
