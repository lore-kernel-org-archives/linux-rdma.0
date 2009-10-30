From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/mcast_tbl: set max_mlid_ho as actually configured
	mlid
Date: Fri, 30 Oct 2009 09:48:09 -0400
Message-ID: <f0e08f230910300648m4d802f57w2910cea678a3cd1f@mail.gmail.com>
References: <4AEAEA86.8080309@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AEAEA86.8080309-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 29, 2009 at 3:19 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
>
> Set switch's mcast table max_mlid_ho as actually configured mlid for =
the
> switch instead of a value extended to MFT block size aligned. This ma=
kes
> mlid handling checks to be more reliable.
>
> Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
> opensm/opensm/osm_mcast_tbl.c | =C2=A0 =C2=A05 +++--
> 1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast_=
tbl.c
> index b5ae6f2..eee9290 100644
> --- a/opensm/opensm/osm_mcast_tbl.c
> +++ b/opensm/opensm/osm_mcast_tbl.c
> @@ -122,7 +122,7 @@ int osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p_=
tbl, IN
> uintn_t mlid_offset)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0uint16_t (*p_mask_tbl)[][IB_MCAST_POSITION=
_MAX];
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mlid_offset < p_tbl->mft_depth)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto done;

Why should max_mlid_ho be changed when < mft_depth ?

Doing so makes group removal not work properly.

-- Hal

> =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 The number of bytes needed in the =
mask table is:
> @@ -144,7 +144,8 @@ int osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p_=
tbl, IN
> uintn_t mlid_offset)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size - p_tbl->mft_de=
pth * (IB_MCAST_POSITION_MAX + 1) *
> IB_MCAST_MASK_SIZE / 8);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_tbl->p_mask_tbl =3D p_mask_tbl;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_tbl->mft_depth =3D mft_depth;
> - =C2=A0 =C2=A0 =C2=A0 p_tbl->max_mlid_ho =3D mft_depth + IB_LID_MCAS=
T_START_HO - 1;
> +done:
> + =C2=A0 =C2=A0 =C2=A0 p_tbl->max_mlid_ho =3D mlid_offset + IB_LID_MC=
AST_START_HO - 1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> }
>
> --
> 1.6.5.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
