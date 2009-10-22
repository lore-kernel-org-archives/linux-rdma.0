From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_vendor_ibumad.c: Add environment variable to
	change max retries
Date: Thu, 22 Oct 2009 08:56:00 -0400
Message-ID: <f0e08f230910220556h3d7352f4s4bd8e57c0a01a5d0@mail.gmail.com>
References: <20091019183342.GA28926@comcast.net> <20091022122443.GF20210@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091022122443.GF20210@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 22, 2009 at 8:24 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 14:33 Mon 19 Oct =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>
> Why do you need this?

It is useful in some clusters where the default behavior is
insufficient and control over the number of retries helps and there is
no vendor API support for this.

> And why did you choose to use environment variable and not command
> line/config option? I think that it is less obvious.

It was modeled after OSM_UMAD_MAX_PENDING. It could be made a command
line/options file item. Is that your preference ?

-- Hal

> Sasha
>
>> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> diff --git a/opensm/libvendor/osm_vendor_ibumad.c b/opensm/libvendor=
/osm_vendor_ibumad.c
>> index 8d3c680..01250fb 100644
>> --- a/opensm/libvendor/osm_vendor_ibumad.c
>> +++ b/opensm/libvendor/osm_vendor_ibumad.c
>> @@ -446,6 +446,17 @@ osm_vendor_init(IN osm_vendor_t * const p_vend,
>> =C2=A0 =C2=A0 =C2=A0 p_vend->p_log =3D p_log;
>> =C2=A0 =C2=A0 =C2=A0 p_vend->timeout =3D timeout;
>> =C2=A0 =C2=A0 =C2=A0 p_vend->max_retries =3D OSM_DEFAULT_RETRY_COUNT=
;
>> +
>> + =C2=A0 =C2=A0 if ((max =3D getenv("OSM_UMAD_MAX_RETRIES")) !=3D NU=
LL) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int tmp =3D strtol(max, =
NULL, 0);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (tmp > 0)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 p_vend->max_retries =3D tmp;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "Error:"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "OSM_UMAD_MAX_RETRIES=3D%d is invalid\n=
",
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tmp);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>> +
>> =C2=A0 =C2=A0 =C2=A0 pthread_mutex_init(&p_vend->cb_mutex, NULL);
>> =C2=A0 =C2=A0 =C2=A0 pthread_mutex_init(&p_vend->match_tbl_mutex, NU=
LL);
>> =C2=A0 =C2=A0 =C2=A0 p_vend->umad_port_id =3D -1;
>> @@ -476,12 +487,13 @@ osm_vendor_init(IN osm_vendor_t * const p_vend=
,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 p_vend->mtbl.max =3D tmp;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "Error:"
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "OSM_UMAD_MAX_PENDING=3D%d is invalid",
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "OSM_UMAD_MAX_PENDING=3D%d is invalid\n=
",
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tmp);
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> - =C2=A0 =C2=A0 OSM_LOG(p_vend->p_log, OSM_LOG_INFO, "%d pending uma=
ds specified\n",
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_vend->mtbl.max);
>> + =C2=A0 =C2=A0 OSM_LOG(p_vend->p_log, OSM_LOG_INFO,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "%d max retries %d max p=
ending umads specified\n",
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_vend->max_retries, p_v=
end->mtbl.max);
>>
>> =C2=A0 =C2=A0 =C2=A0 p_vend->mtbl.tbl =3D calloc(p_vend->mtbl.max, s=
izeof(*(p_vend->mtbl.tbl)));
>> =C2=A0 =C2=A0 =C2=A0 if (!p_vend->mtbl.tbl) {
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
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
