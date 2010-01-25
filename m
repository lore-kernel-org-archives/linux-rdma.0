From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] libibverbs: Force line-buffering in ibv_asyncwatch
Date: Mon, 25 Jan 2010 11:44:30 +0200
Message-ID: <4B5D67FE.80509@Voltaire.com>
References: <ED0695A5-CBE3-4CE2-A20C-BBC7BEF28C33@Sun.com>	<4B5BD8B5.2080102@voltaire.com> <23AC7B6E-377F-4CFC-AD9D-0D2FD27662C7@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <23AC7B6E-377F-4CFC-AD9D-0D2FD27662C7-UdXhSnd/wVw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

H=E5kon Bugge wrote:
> I used the information at www.openfabrics.org/git/?p=3Dofed_1_2_5/lib=
ibverbs.git;a=3Dsummary=20
> which states the "owner" to be Vlad. May be that confused me. I'll se=
nd a copy to Roland

Roland's user space git trees are all hosted @ kernel.org=20
the libibverbs one is git://git.kernel.org/pub/scm/libs/infiniband/libi=
bverbs.git
you can find there the libmlx4 and libmthca ones as well.

Vlad - is there a way to prevent such confusion in the future, maybe pu=
t a clear comment
in the header of the ofa git page?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
