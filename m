From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_sa.c: In osm_sa_respond, only fill in attr
	offset if RMPP method
Date: Wed, 9 Jun 2010 08:40:25 -0400
Message-ID: <AANLkTikTxpvb-Nw2V1PrBcX4rZ1GwElXV22CBtBZx1iK@mail.gmail.com>
References: <20100603134209.GA12225@comcast.net>
	<20100609054341.GK28549@me>
	<AANLkTilkr6KYG_TVJYwvNl7sZ8XBKmFljktxg8qCA9t9@mail.gmail.com>
	<20100609121036.GC20172@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100609121036.GC20172@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stan Smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 9, 2010 at 8:10 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> =
wrote:
> On 06:23 Wed 09 Jun =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> >>
>> >> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >> ---
>> >> =C2=A0opensm/opensm/osm_sa.c | =C2=A0 12 ++++++++++--
>> >> =C2=A01 files changed, 10 insertions(+), 2 deletions(-)
>> >>
>> >> diff --git a/opensm/opensm/osm_sa.c b/opensm/opensm/osm_sa.c
>> >> index 0aca81f..8325632 100644
>> >> --- a/opensm/opensm/osm_sa.c
>> >> +++ b/opensm/opensm/osm_sa.c
>> >> @@ -3,6 +3,7 @@
>> >> =C2=A0 * Copyright (c) 2002-2010 Mellanox Technologies LTD. All r=
ights reserved.
>> >> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights re=
served.
>> >> =C2=A0 * Copyright (c) 2008 Xsigo Systems Inc. =C2=A0All rights r=
eserved.
>> >> + * Copyright (c) 2010 HNR Consulting. All rights reserved.
>> >> =C2=A0 *
>> >> =C2=A0 * This software is available to you under a choice of one =
of two
>> >> =C2=A0 * licenses. =C2=A0You may choose to be licensed under the =
terms of the GNU
>> >> @@ -454,8 +455,15 @@ void osm_sa_respond(osm_sa_t *sa, osm_madw_t=
 *madw, size_t attr_size,
>> >> =C2=A0 =C2=A0 =C2=A0 /* C15-0.1.5 - always return SM_Key =3D 0 (t=
able 185 p 884) */
>> >> =C2=A0 =C2=A0 =C2=A0 resp_sa_mad->sm_key =3D 0;
>> >>
>> >> - =C2=A0 =C2=A0 /* Fill in the offset (paylen will be done by the=
 rmpp SAR) */
>> >> - =C2=A0 =C2=A0 resp_sa_mad->attr_offset =3D num_rec ? ib_get_att=
r_offset(attr_size) : 0;
>> >> +#ifdef DUAL_SIDED_RMPP
>> >> + =C2=A0 =C2=A0 if (resp_sa_mad->method =3D=3D IB_MAD_METHOD_GETT=
ABLE_RESP ||
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 resp_sa_mad->method =3D=3D IB_MAD_M=
ETHOD_GETMULTI_RESP) {
>> >> +#else
>> >> + =C2=A0 =C2=A0 if (resp_sa_mad->method =3D=3D IB_MAD_METHOD_GETT=
ABLE_RESP) {
>> >> +#endif
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Fill in the offset=
 (paylen will be done by the rmpp SAR) */
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 resp_sa_mad->attr_off=
set =3D num_rec ? ib_get_attr_offset(attr_size) : 0;
>> >> + =C2=A0 =C2=A0 }
>> >
>> > What is wrong with current implementation?
>>
>> It's now needed for the debug version of OpenSM not to assert due to=
:
>>
>> 7fc6cd3037f07190e483a047f17d37b6bebbb2b3
>> Author: Smith, Stan <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Date: =C2=A0 Fri May 21 10:49:27 2010 -0700
>>
>> =C2=A0 =C2=A0 ib_types.h add debug assert
>>
>> =C2=A0 =C2=A0 Add a debug assert to catch incorrect MAD attr offset =
size.
>> =C2=A0 =C2=A0 This proved to be useful in catching incorrect struct =
sizes as MAD attrs nee
>> d to be a multiple of 8 bytes.
>>
>> =C2=A0 =C2=A0 Signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> =C2=A0 =C2=A0 Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>>
>> as not all SA attributes are multiple of 8 bytes.
>
> Then it seems that such assertion is incorrect and the patch should b=
e
> reverted. Right?

I think the use of ib_get_attr_offset is being "overused". I'd rather
see this patch used as it is the simplest way to address that rather
than conditionalize ib_get_attr_offset on the SA attribute or would
you rather see a patch along those lines ?

-- Hal

>
> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
