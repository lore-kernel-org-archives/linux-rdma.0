From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_sm_mad_ctrl.c: In sm_mad_ctrl_send_err_cb, set
	init failure on PKeyTable and QoS initialization failure
Date: Fri, 30 Oct 2009 17:45:33 -0400
Message-ID: <f0e08f230910301445q6a4790aam295c254c430f0f82@mail.gmail.com>
References: <20091030012213.GR20136@me>
	 <949139550.4222411256937590346.JavaMail.root@sz0074a.westchester.pa.mail.comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <949139550.4222411256937590346.JavaMail.root-m8vEhog2yEGs1RcX6exeh1Wh7bxQi8rYbcbDuTDi3LmGxX56iWlbXw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 29, 2009 at 9:22 PM,  Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org=
> wrote:
>
>
> On 09:13 Mon 10 Aug =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> diff --git a/opensm/opensm/osm_sm_mad_ctrl.c
>> b/opensm/opensm/osm_sm_mad_ctrl.c
>> index 791c848..f0bc407 100644
>> --- a/opensm/opensm/osm_sm_mad_ctrl.c
>> +++ b/opensm/opensm/osm_sm_mad_ctrl.c
>> @@ -723,7 +723,10 @@ static void sm_mad_ctrl_send_err_cb(IN void *co=
ntext,
>> IN osm_madw_t * p_madw)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0 =C2=A0=
(p_smp->attr_id =3D=3D IB_MAD_ATTR_PORT_INFO ||
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0 =C2=A0=
 p_smp->attr_id =3D=3D IB_MAD_ATTR_MCAST_FWD_TBL ||
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0 =C2=A0=
 p_smp->attr_id =3D=3D IB_MAD_ATTR_SWITCH_INFO ||
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0 =C2=A0 p_sm=
p->attr_id =3D=3D IB_MAD_ATTR_LIN_FWD_TBL)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0 =C2=A0 p_sm=
p->attr_id =3D=3D IB_MAD_ATTR_LIN_FWD_TBL ||
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0 =C2=A0 p_sm=
p->attr_id =3D=3D IB_MAD_ATTR_P_KEY_TABLE ||
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0 =C2=A0 p_sm=
p->attr_id =3D=3D IB_MAD_ATTR_SLVL_TABLE ||
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0 =C2=A0 p_sm=
p->attr_id =3D=3D IB_MAD_ATTR_VL_ARBITRATION)) {
>
> Why this change?

Why not ? Aren't these initialization failures ? Why should they be
excluded ? If I recall correctly, they were originally excluded due to
"newness" but that was years ago.

> Any real issue with current behavior (reporting errors and continue)?

In subnets using SL based routing seems that SLVL is critical. One
might want PKey table failures to be treated similarly when partitions
are configured. It's less compelling for VL arbitration.

-- Hal

>
> Sasha
>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, =
"ERR 3119: "
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0"Set method failed for attribute 0x%X (%s)\n",
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0cl_ntoh16(p_smp->attr_id),
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
