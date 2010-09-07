From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libvendor/osm_vendor_ibumad_sa.c: remove useless "if" statement
Date: Tue, 7 Sep 2010 13:47:00 -0400
Message-ID: <AANLkTingExvAshGM6uOQhy3TNFwH7dSrF6fWXYzGxke4@mail.gmail.com>
References: <4C8656B0.5050104@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C8656B0.5050104-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 7, 2010 at 11:13 AM, Yevgeny Kliteynik
<kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org> wrote:
> Content of p_query_req_copy is used in the function,
> so no point checking if it's NULL before the free().
>
> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> ---
> =C2=A0opensm/libvendor/osm_vendor_ibumad_sa.c | =C2=A0 =C2=A03 +--

Same change could be done for osm_vendor_mlx_sa.c too.

-- Hal

> =C2=A01 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/opensm/libvendor/osm_vendor_ibumad_sa.c b/opensm/libvend=
or/osm_vendor_ibumad_sa.c
> index 75bc303..1fdcc47 100644
> --- a/opensm/libvendor/osm_vendor_ibumad_sa.c
> +++ b/opensm/libvendor/osm_vendor_ibumad_sa.c
> @@ -199,8 +199,7 @@ static void __osmv_sa_mad_err_cb(IN void *bind_co=
ntext, IN osm_madw_t * p_madw)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((p_query_req_copy->flags & OSM_SA_FLAG=
S_SYNC) =3D=3D OSM_SA_FLAGS_SYNC)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cl_event_signa=
l(&p_bind->sync_event);
>
> - =C2=A0 =C2=A0 =C2=A0 if (p_query_req_copy)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(p_query_req_c=
opy);
> + =C2=A0 =C2=A0 =C2=A0 free(p_query_req_copy);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0OSM_LOG_EXIT(p_bind->p_log);
> =C2=A0}
>
> --
> 1.6.2.4
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
