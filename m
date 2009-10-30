From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_mcast_tbl: remove redundant checks
Date: Fri, 30 Oct 2009 09:47:30 -0400
Message-ID: <f0e08f230910300647w7a3d1fa3m1761e8c5db6715c4@mail.gmail.com>
References: <20091023234856.GA1482@comcast.net> <20091029191732.GB20136@me>
	 <20091029191906.GD20136@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091029191906.GD20136@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 29, 2009 at 3:19 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
>
> Remove some redundant checks introduced by MFTs reallocation patch.

See below.

> Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
> =C2=A0opensm/opensm/osm_mcast_tbl.c | =C2=A0 12 ++----------
> =C2=A01 files changed, 2 insertions(+), 10 deletions(-)
>
> diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast_=
tbl.c
> index 6cc97b1..b5ae6f2 100644
> --- a/opensm/opensm/osm_mcast_tbl.c
> +++ b/opensm/opensm/osm_mcast_tbl.c
> @@ -99,11 +99,9 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl,=
 IN uint16_t mlid_ho,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0uintn_t bit_mask;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int16_t block_num;
>
> - =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(p_tbl);
> + =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(p_tbl && p_tbl->p_mask_tbl);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CL_ASSERT(mlid_ho >=3D IB_LID_MCAST_START_=
HO);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CL_ASSERT(mlid_ho <=3D p_tbl->max_mlid_ho)=
;
> - =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(mlid_ho - IB_LID_MCAST_START_HO < p_=
tbl->mft_depth);
> - =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(p_tbl->p_mask_tbl);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mlid_offset =3D mlid_ho - IB_LID_MCAST_STA=
RT_HO;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mask_offset =3D port / IB_MCAST_MASK_SIZE;
> @@ -168,8 +166,6 @@ boolean_t osm_mcast_tbl_is_port(IN const osm_mcas=
t_tbl_t * p_tbl,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CL_ASSERT(mlid=
_ho <=3D p_tbl->max_mlid_ho);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mlid_offset =3D=
 mlid_ho - IB_LID_MCAST_START_HO;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mlid_offset >=3D=
 p_tbl->mft_depth)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return FALSE;

This check is needed for group removal to work properly.

> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mask_offset =3D=
 port_num / IB_MCAST_MASK_SIZE;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bit_mask =3D c=
l_ntoh16((uint16_t)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (1 << (port_nu=
m % IB_MCAST_MASK_SIZE)));
> @@ -197,8 +193,6 @@ boolean_t osm_mcast_tbl_is_any_port(IN const osm_=
mcast_tbl_t * p_tbl,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CL_ASSERT(mlid=
_ho <=3D p_tbl->max_mlid_ho);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mlid_offset =3D=
 mlid_ho - IB_LID_MCAST_START_HO;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mlid_offset >=3D=
 p_tbl->mft_depth)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return FALSE;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (position =
=3D 0; position <=3D p_tbl->max_position; position++)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0result |=3D (*p_tbl->p_mask_tbl)[mlid_offset][position];
> @@ -250,10 +244,8 @@ void osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t=
 * p_tbl, IN uint16_t mlid_ho)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CL_ASSERT(p_tbl);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CL_ASSERT(mlid_ho >=3D IB_LID_MCAST_START_=
HO);
>
> - =C2=A0 =C2=A0 =C2=A0 if (p_tbl->p_mask_tbl && (mlid_ho <=3D p_tbl->=
max_mlid_ho)) {
> + =C2=A0 =C2=A0 =C2=A0 if (p_tbl->p_mask_tbl && mlid_ho <=3D p_tbl->m=
ax_mlid_ho) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mlid_offset =3D=
 mlid_ho - IB_LID_MCAST_START_HO;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mlid_offset >=3D=
 p_tbl->mft_depth)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return;

This should be done the same as osm_mcast_tbl_is_port.

-- Hal

> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; =
i <=3D p_tbl->max_position; i++)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0(*p_tbl->p_mask_tbl)[mlid_offset][i] =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
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
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
