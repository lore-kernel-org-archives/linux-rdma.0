From: Eli Dorfman <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_mcast_mgr.c: preserve root switch calculation
	functionality
Date: Fri, 5 Feb 2010 16:34:11 +0200
Message-ID: <694d48601002050634t8d2a1fdoedbb37ef1387f9fb@mail.gmail.com>
References: <20100204204713.GJ26338@me> <20100204222213.GL26338@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100204222213.GL26338@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 5, 2010 at 12:22 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
>
> I'm not sure that this is a bug, but anyway. Now for MC group spannin=
g
> tree root switch calculation it uses max hops criteria differently -
> accumulated hops for all MC members connected to the switch against
> previous maximal one.
>
> This patch makes it functionally exactly as it was.

right. otherwise it is sort of average hops.

>
> Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
> =C2=A0opensm/opensm/osm_mcast_mgr.c | =C2=A0 =C2=A03 ++-
> =C2=A01 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_=
mgr.c
> index f33d6a6..322635d 100644
> --- a/opensm/opensm/osm_mcast_mgr.c
> +++ b/opensm/opensm/osm_mcast_mgr.c
> @@ -253,7 +253,8 @@ static float mcast_mgr_compute_max_hops(osm_sm_t =
* sm, cl_qmap_t * m,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sw =3D cl_item=
_obj(i, sw, mgrp_item);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lid =3D cl_nto=
h16(osm_node_get_base_lid(sw->p_node, 0));
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0hops =3D osm_s=
witch_get_least_hops(this_sw, lid);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hops =3D (hops + 1=
) * sw->num_of_mcm + hops * sw->is_mc_member;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!sw->is_mc_mem=
ber)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 hops +=3D 1;

I think that this condition is may be avoided since if the switch is a
member in the MC group then the packet
still needs to get to the CPU that is running on it (enhanced port)
and this is similar to additional hop
in case of host (assuming that host cpu is much faster then switch cpu)=
=2E

Eli
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (hops > max=
_hops)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0max_hops =3D hops;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> --
> 1.6.6.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
