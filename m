From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: Add infrastructure support for PortInfo
	IsMulticastPkeyTrapSuppressionSupported
Date: Tue, 13 Oct 2009 09:15:36 -0400
Message-ID: <f0e08f230910130615of844fc4lb02265e5eaf25717@mail.gmail.com>
References: <20091009144659.GA17861@comcast.net> <20091012184523.GC13830@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091012184523.GC13830@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 12, 2009 at 2:45 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 10:46 Fri 09 Oct =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> Per published MgtWG errata RefID 4576
>>
>> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> diff --git a/opensm/include/iba/ib_types.h b/opensm/include/iba/ib_t=
ypes.h
>> index 25ed35f..c820372 100644
>> --- a/opensm/include/iba/ib_types.h
>> +++ b/opensm/include/iba/ib_types.h
>> @@ -4432,7 +4432,7 @@ typedef struct _ib_port_info {
>> =C2=A0 =C2=A0 =C2=A0 ib_net16_t p_key_violations;
>> =C2=A0 =C2=A0 =C2=A0 ib_net16_t q_key_violations;
>> =C2=A0 =C2=A0 =C2=A0 uint8_t guid_cap;
>> - =C2=A0 =C2=A0 uint8_t subnet_timeout; /* cli_rereg(1b), resrv(2b),=
 timeout(5b) */
>> + =C2=A0 =C2=A0 uint8_t subnet_timeout; /* cli_rereg(1b), mcast_pkey=
_trap_suppr(1b), resrv(1b), timeout(5b) */
>> =C2=A0 =C2=A0 =C2=A0 uint8_t resp_time_value;
>> =C2=A0 =C2=A0 =C2=A0 uint8_t error_threshold; /* local phy errors(4b=
), overrun errors(4b) */
>> =C2=A0 =C2=A0 =C2=A0 ib_net16_t max_credit_hint;
>> @@ -5282,7 +5282,7 @@ ib_port_info_set_timeout(IN ib_port_info_t * c=
onst p_pi,
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(timeout <=3D 0x1F);
>> =C2=A0 =C2=A0 =C2=A0 p_pi->subnet_timeout =3D
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 (uint8_t) ((p_pi->subnet_timeout & 0x8=
0) | (timeout & 0x1F));
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 (uint8_t) ((p_pi->subnet_timeout & 0xC=
0) | (timeout & 0x1F));
>
> Why not 'p_pi->subnet_timeout & 0xe0' then (IOW why to bother with
> reserved bits reset)?

Per this erratum (RefID 4576), this bit is no longer reserved. It is
now used for MulticastPKeyTrapSuppressionEnabled.

>
>> =C2=A0}
>>
>> =C2=A0/*
>> @@ -5317,7 +5317,7 @@ ib_port_info_set_client_rereg(IN ib_port_info_=
t * const p_pi,
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(client_rereg <=3D 0x1);
>> =C2=A0 =C2=A0 =C2=A0 p_pi->subnet_timeout =3D
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (uint8_t) ((p_pi->
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 subnet_timeout & 0x1F) | ((client_rereg << 7) & 0x80));
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 subnet_timeout & 0x5F) | ((client_rereg << 7) & 0x80));
>
> Ditto.

See above.

>> =C2=A0}
>>
>> =C2=A0/*
>> @@ -5336,6 +5336,43 @@ ib_port_info_set_client_rereg(IN ib_port_info=
_t * const p_pi,
>> =C2=A0* SEE ALSO
>> =C2=A0*********/
>>
>> +/****f* IBA Base: Types/ib_port_info_set_mcast_pkey_trap_suppress
>> +* NAME
>> +* =C2=A0 =C2=A0ib_port_info_set_mcast_pkey_trap_suppress
>> +*
>> +* DESCRIPTION
>> +* =C2=A0 =C2=A0Sets the encoded multicast pkey trap suppresion enab=
led bit value
>> +* =C2=A0 =C2=A0in the PortInfo attribute.
>> +*
>> +* SYNOPSIS
>> +*/
>> +static inline void OSM_API
>> +ib_port_info_set_mcast_pkey_trap_suppress(IN ib_port_info_t * const=
 p_pi,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN c=
onst uint8_t trap_suppress)
>> +{
>> + =C2=A0 =C2=A0 CL_ASSERT(trap_suppress <=3D 0x1);
>> + =C2=A0 =C2=A0 p_pi->subnet_timeout =3D
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 (uint8_t) ((p_pi->
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 subnet_timeout & 0x9F) | ((trap_suppress << 6) & 0x40));
>
> Ditto.

See above.

> And whoudn't this:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_pi->subnet_timeout =3D (p_pi->subnet_tim=
eout & 0xbf) |
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(trap_suppress=
 << 6)
>
> just work?

Sure, Do you want an updated patch with this change ?

-- Hal

> Sasha
>
>> +}
>> +
>> +/*
>> +* PARAMETERS
>> +* =C2=A0 =C2=A0p_pi
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[in] Pointer to a PortIn=
fo attribute.
>> +*
>> +* =C2=A0 =C2=A0trap_suppress
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[in] Multicast pkey trap=
 suppresion enabled value to set
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (either 1=
 or 0).
>> +*
>> +* RETURN VALUES
>> +* =C2=A0 =C2=A0None.
>> +*
>> +* NOTES
>> +*
>> +* SEE ALSO
>> +*********/
>> +
>> =C2=A0/****f* IBA Base: Types/ib_port_info_get_timeout
>> =C2=A0* NAME
>> =C2=A0* =C2=A0 =C2=A0ib_port_info_get_timeout
>> @@ -5392,6 +5429,35 @@ ib_port_info_get_client_rereg(IN ib_port_info=
_t const *p_pi)
>> =C2=A0* SEE ALSO
>> =C2=A0*********/
>>
>> +/****f* IBA Base: Types/ib_port_info_get_mcast_pkey_trap_suppress
>> +* NAME
>> +* =C2=A0 =C2=A0ib_port_info_get_mcast_pkey_trap_suppress
>> +*
>> +* DESCRIPTION
>> +* =C2=A0 =C2=A0Gets the encoded multicast pkey trap suppresion enab=
led bit value
>> +* =C2=A0 =C2=A0in the PortInfo attribute.
>> +*
>> +* SYNOPSIS
>> +*/
>> +static inline uint8_t OSM_API
>> +ib_port_info_get_mcast_pkey_trap_suppress(IN ib_port_info_t const *=
p_pi)
>> +{
>> + =C2=A0 =C2=A0 return ((p_pi->subnet_timeout & 0x40) >> 6);
>> +}
>> +
>> +/*
>> +* PARAMETERS
>> +* =C2=A0 =C2=A0p_pi
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[in] Pointer to a PortIn=
fo attribute.
>> +*
>> +* RETURN VALUES
>> +* =C2=A0 =C2=A0Multicast PKey trap suppression enabled value (eithe=
r 1 or 0).
>> +*
>> +* NOTES
>> +*
>> +* SEE ALSO
>> +*********/
>> +
>> =C2=A0/****f* IBA Base: Types/ib_port_info_set_hoq_lifetime
>> =C2=A0* NAME
>> =C2=A0* =C2=A0 =C2=A0ib_port_info_set_hoq_lifetime
>> diff --git a/opensm/opensm/osm_helper.c b/opensm/opensm/osm_helper.c
>> index 2b3dced..417c256 100644
>> --- a/opensm/opensm/osm_helper.c
>> +++ b/opensm/opensm/osm_helper.c
>> @@ -823,6 +823,7 @@ void osm_dump_port_info(IN osm_log_t * p_log, IN=
 ib_net64_t node_guid,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 "\t\t\t\tq_key_violations........0x%X\n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 "\t\t\t\tguid_cap................0x%X\n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 "\t\t\t\tclient_reregister.......0x%X\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 "\t\t\t\tmcast_pkey_trap_suppr...0x%X\n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 "\t\t\t\tsubnet_timeout..........0x%X\n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 "\t\t\t\tresp_time_value.........0x%X\n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 "\t\t\t\terror_threshold.........0x%X\n"
>> @@ -854,6 +855,7 @@ void osm_dump_port_info(IN osm_log_t * p_log, IN=
 ib_net64_t node_guid,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cl_ntoh16(p_pi->p_key_violations),
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cl_ntoh16(p_pi->q_key_violations), p_pi->guid_cap,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ib_port_info_get_client_rereg(p_pi),
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 ib_port_info_get_mcast_pkey_trap_suppress(p_pi),
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ib_port_info_get_timeout(p_pi), p_pi->resp_time_value,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 p_pi->error_threshold, cl_ntoh16(p_pi->max_credit_hint),
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cl_ntoh32(p_pi->link_rt_latency));
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
