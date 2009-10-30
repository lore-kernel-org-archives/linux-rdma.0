From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/mcast_tbl: set max_mlid_ho as actually configured
	mlid
Date: Fri, 30 Oct 2009 16:44:47 -0400
Message-ID: <f0e08f230910301344j5b9564a5k9b77fd4e43e48376@mail.gmail.com>
References: <4AEAEA86.8080309@systemfabricworks.com>
	 <f0e08f230910300648m4d802f57w2910cea678a3cd1f@mail.gmail.com>
	 <20091030200620.GB5829@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091030200620.GB5829@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 30, 2009 at 4:06 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 09:48 Fri 30 Oct =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> >
>> > diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mca=
st_tbl.c
>> > index b5ae6f2..eee9290 100644
>> > --- a/opensm/opensm/osm_mcast_tbl.c
>> > +++ b/opensm/opensm/osm_mcast_tbl.c
>> > @@ -122,7 +122,7 @@ int osm_mcast_tbl_realloc(IN osm_mcast_tbl_t *=
 p_tbl, IN
>> > uintn_t mlid_offset)
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0uint16_t (*p_mask_tbl)[][IB_MCAST_POSIT=
ION_MAX];
>> >
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mlid_offset < p_tbl->mft_depth)
>> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto done;
>>
>> Why should max_mlid_ho be changed when < mft_depth ?
>
> To be equal to an actually configured max mlid value (not a size of
> mcast table allocation).
>
>> Doing so makes group removal not work properly.
>
> This may have this issue, but not due to fact of max_mlid_ho change, =
but
> due to invalid check in osm_mcast_tbl_clear_mlid(). I think there it
> should be something like:
>
> diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast_=
tbl.c
> index 0a45904..a599e56 100644
> --- a/opensm/opensm/osm_mcast_tbl.c
> +++ b/opensm/opensm/osm_mcast_tbl.c
> @@ -245,8 +245,8 @@ void osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t =
* p_tbl, IN uint16_t mlid_ho)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CL_ASSERT(p_tbl);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CL_ASSERT(mlid_ho >=3D IB_LID_MCAST_START_=
HO);
>
> - =C2=A0 =C2=A0 =C2=A0 if (p_tbl->p_mask_tbl && mlid_ho <=3D p_tbl->m=
ax_mlid_ho) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mlid_offset =3D ml=
id_ho - IB_LID_MCAST_START_HO;
> + =C2=A0 =C2=A0 =C2=A0 mlid_offset =3D mlid_ho - IB_LID_MCAST_START_H=
O;
> + =C2=A0 =C2=A0 =C2=A0 if (p_tbl->p_mask_tbl && mlid_offset < p_tbl->=
mft_depth) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; =
i <=3D p_tbl->max_position; i++)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0(*p_tbl->p_mask_tbl)[mlid_offset][i] =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> Does it make sense?

Yes, that fixes the removal issue.

Tested-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

-- Hal

> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
