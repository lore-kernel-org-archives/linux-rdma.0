From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] mlx4: Fix unneeded return error in eth_link_query_port
Date: Sun, 24 Oct 2010 20:05:08 +0200
Message-ID: <AANLkTimb++kFYFXCWajBGACpA1OpCXyyeyD-98Ed3uTu@mail.gmail.com>
References: <20101024075835.GA11359@mtldesk30>
	<adahbgbppgx.fsf@cisco.com>
	<20101024160018.GA32499@mtldesk30>
	<adaocajo90s.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaocajo90s.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 24, 2010 at 6:22 PM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrot=
e:
> =A0> No you did not. It was there already but we never noticed before
> =A0> Yossi's patch.
>
> But AFAICT Yossi's patch (5eb620c8) went into 2.6.22 about 2.5 years
> ago... wasn't that already there way before the IBoE stuff started?
>

I see... I think the reason it started failing comes from this portion
of patch 8:

+       mlx4_ib_port_link_layer(ibdev, port) =3D=3D IB_LINK_LAYER_INFIN=
IBAND ?
+               ib_link_query_port(ibdev, port, props, out_mad) :
+               eth_link_query_port(ibdev, port, props, out_mad);

I discarded the value returned and you added it as it should be.
So the fix is valid anyway, but the changelog has to be changed,
probably to something like:

eth_link_query_port() returns error if a netdevice was not yet associat=
ed with
the IBoE port. This is not required since we already initialize the lin=
k as
down.  Failure to do so can cause mlx4_ib loading to fail.
=46ix this by always returning success.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
