From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_sa_path_record.c: livelock in
	pr_rcv_get_path_parms
Date: Mon, 19 Apr 2010 14:20:56 -0400
Message-ID: <j2uf0e08f231004191120oc1e78130l683b9ae0ca51003a@mail.gmail.com>
References: <4BCC1F3F.5080000@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BCC1F3F.5080000-UdXhSnd/wVw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Line Holen <Line.Holen-xsfywfwIY+M@public.gmane.org>
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 19, 2010 at 5:15 AM, Line Holen <Line.Holen-xsfywfwIY+M@public.gmane.org> wrote:
> SA path request handling can end up in a livelock in pr_rcv_get_path_=
parms().
> This can happen if a path request is handled while LFT updates to the=
 fabric
> are in progress.
> The LFT of the switch data structure is updated as part of the LFT re=
sponse
> processing. So while the SM is busy pushing the LFT updates, some swi=
tches have
> up to date LFT info while others are not yet updated and contains the=
 LFT of
> the previous routing. For a (short) time interval there is a potentia=
l for
> loops in the fabric. The livelock occurs if a path request is receive=
d during
> this time interval.
> Both LFT response handling and path request processing needs the SM l=
ock.
> When the livelock occurs the LFT response handling blocks forever wai=
ting for
> the lock to be released.
>
> The suggested fix is simply to introduce a max number of hops that sh=
ould
> be traversed while handling the path request. If this max is reached =
then
> the request will return with NO_RECORD response

To me, this begs the question of whether this should return a BUSY
status rather than no record (and whether SA clients should handle
those two differently) but that is a bigger change (and may require
some end node change as well).

Also, should a similar change be made in SA MPR mpr_rcv_get_path_parms =
?

-- Hal

> and release the SM lock.
> This way the LFT processing will be able to complete.
>
> Signed-off-by: Line Holen <Line.Holen-xsfywfwIY+M@public.gmane.org>
>
> ---
>
> diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_s=
a_path_record.c
> index c4c3f86..b399b70 100644
> --- a/opensm/opensm/osm_sa_path_record.c
> +++ b/opensm/opensm/osm_sa_path_record.c
> @@ -4,6 +4,7 @@
> =C2=A0* Copyright (c) 1996-2003 Intel Corporation. All rights reserve=
d.
> =C2=A0* Copyright (c) 2008 Xsigo Systems Inc. All rights reserved.
> =C2=A0* Copyright (c) 2009 HNR Consulting. All rights reserved.
> + * Copyright (c) 2010 Sun Microsystems, Inc. All rights reserved.
> =C2=A0*
> =C2=A0* This software is available to you under a choice of one of tw=
o
> =C2=A0* licenses. =C2=A0You may choose to be licensed under the terms=
 of the GNU
> @@ -69,6 +70,9 @@
> =C2=A0#include <opensm/osm_prefix_route.h>
> =C2=A0#include <opensm/osm_ucast_lash.h>
>
> +
> +#define MAX_HOPS 128
> +
> =C2=A0typedef struct osm_pr_item {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cl_list_item_t list_item;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ib_path_rec_t path_rec;
> @@ -178,6 +182,7 @@ static ib_api_status_t pr_rcv_get_path_parms(IN o=
sm_sa_t * sa,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0osm_qos_level_t *p_qos_level =3D NULL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0uint16_t valid_sl_mask =3D 0xffff;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int is_lash;
> + =C2=A0 =C2=A0 =C2=A0 int hops =3D 0;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0OSM_LOG_ENTER(sa->p_log);
>
> @@ -369,6 +374,25 @@ static ib_api_status_t pr_rcv_get_path_parms(IN =
osm_sa_t * sa,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto Exit;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* update number o=
f hops traversed */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hops++;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (hops > MAX_HOP=
S) {
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 OSM_LOG(sa->p_log, OSM_LOG_ERROR,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 "Path from GUID 0x%016" PRIx64 " (%s) to lid %u G=
UID 0x%016"
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 PRIx64 " (%s) needs more than %d hops, "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 "max %d hops allowed\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 cl_ntoh64(osm_physp_get_port_guid(p_src_physp)),
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 p_src_physp->p_node->print_desc,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 dest_lid_ho,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 cl_ntoh64(osm_physp_get_port_guid(p_dest_physp)),
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 p_dest_physp->p_node->print_desc,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 hops, MAX_HOPS);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 status =3D IB_NOT_FOUND;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto Exit;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
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
