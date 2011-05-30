From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4: allow for 4K mtu configuration of IB ports
Date: Tue, 31 May 2011 01:12:23 +0300
Message-ID: <BANLkTi=6Tg+fy-JUp5aiORVGbr-jNU-jUw@mail.gmail.com>
References: <alpine.LRH.2.00.1105251507140.16147@ogerlitz.voltaire.com>
	<BANLkTi=bKdVXm+f+HVeg2tBzT4RBJDCN_w@mail.gmail.com>
	<BANLkTinDCbPXi8zS46wcVW_Yn0fxzbSikw@mail.gmail.com>
	<BANLkTikrJ_3f+LwN_R=-AcwCde-KdHJhOQ@mail.gmail.com>
	<BANLkTinT5OJdP38Xq=PCtx1wgxDhjVfndA@mail.gmail.com>
	<BANLkTi=NkZQX2JFa99qkVpLAchRjNoYOhg@mail.gmail.com>
	<4DDDF212.4080700@mellanox.com>
	<BANLkTimrm7bqTT8qAzxdf9tsJuv7+NPO+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimrm7bqTT8qAzxdf9tsJuv7+NPO+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> The obvious answer is no, and therefore we have mlx4_portX =A0attribu=
tes in
> sysfs that are per port. =A0MTU is the same way. =A0For example, you =
suggest
> that CX3 won't have the same limitation of only 4 VLs with 4K MTU. =A0=
In
> that case, think about a system with one CX2 and one CX3 -- should th=
e
> CX3 be limited to 2K MTU because of CX2 limitations?
>
> Rather than having a completely different way of handling MTU, why ca=
n't
> we just handle it the same way as the port type, and have a sysfs att=
ribute
> like "mlx4_mtuN" for each port?

okay, got that. I'd like to make another round of thinking / checking i=
f we
can make 4k mtu being the default and not configurable also for
pre-CX3 devices,
if yes, I guess we can avoid the per port sysfs entry, if not, I'll add=
 that as
part of the patch.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
