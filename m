From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: Add initial support for optimized
	SLtoVLMappingTable programming
Date: Tue, 1 Dec 2009 14:49:28 -0500
Message-ID: <f0e08f230912011149w402c2c17tc8f85516b84c1aef@mail.gmail.com>
References: <20090804131836.GA15226@comcast.net> <20091030022324.GT20136@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091030022324.GT20136@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 29, 2009 at 9:23 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
<snip...>

>> diff --git a/opensm/opensm/osm_slvl_map_rcv.c b/opensm/opensm/osm_sl=
vl_map_rcv.c
>> index 9c37442..67c71bd 100644
>> --- a/opensm/opensm/osm_slvl_map_rcv.c
>> +++ b/opensm/opensm/osm_slvl_map_rcv.c
>> @@ -2,6 +2,7 @@
>> =C2=A0 * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
>> =C2=A0 * Copyright (c) 2002-2005 Mellanox Technologies LTD. All righ=
ts reserved.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> + * Copyright (c) 2009 HNR Consulting. All rights reserved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> =C2=A0 * licenses. =C2=A0You may choose to be licensed under the ter=
ms of the GNU
>> @@ -72,7 +73,9 @@ void osm_slvl_rcv_process(IN void *context, IN voi=
d *p_data)
>> =C2=A0 =C2=A0 =C2=A0 osm_slvl_context_t *p_context;
>> =C2=A0 =C2=A0 =C2=A0 ib_net64_t port_guid;
>> =C2=A0 =C2=A0 =C2=A0 ib_net64_t node_guid;
>> - =C2=A0 =C2=A0 uint8_t out_port_num, in_port_num;
>> + =C2=A0 =C2=A0 uint32_t attr_mod;
>> + =C2=A0 =C2=A0 uint8_t out_port_num, in_port_num, startinport, star=
toutport,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 endinport, endoutport;
>>
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(sm);
>>
>> @@ -111,6 +114,9 @@ void osm_slvl_rcv_process(IN void *context, IN v=
oid *p_data)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (uint=
8_t) cl_ntoh32(p_smp->attr_mod & 0xFF000000);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 in_port_num =3D
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (uint=
8_t) cl_ntoh32((p_smp->attr_mod & 0x00FF0000) << 8);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 attr_mod =3D cl_ntoh32(p=
_smp->attr_mod);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (attr_mod & 0x30000)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 goto opt_sl2vl;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_physp =3D osm_nod=
e_get_physp_ptr(p_node, out_port_num);
>> =C2=A0 =C2=A0 =C2=A0 } else {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_physp =3D p_port-=
>p_physp;
>> @@ -123,7 +129,7 @@ void osm_slvl_rcv_process(IN void *context, IN v=
oid *p_data)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0all we want is to update the subne=
t.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>> =C2=A0 =C2=A0 =C2=A0 OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Got SLtoVL get response=
 in_port_num %u out_port_num %u with "
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Received SLtoVL GetResp=
 in_port_num %u out_port_num %u with "
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "GUID 0x%" PRIx64 "=
 for parent node GUID 0x%" PRIx64 ", TID 0x%"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 PRIx64 "\n", in_por=
t_num, out_port_num, cl_ntoh64(port_guid),
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cl_ntoh64(node_guid=
), cl_ntoh64(p_smp->trans_id));
>> @@ -142,6 +148,39 @@ void osm_slvl_rcv_process(IN void *context, IN =
void *p_data)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 out_port_num, p_slvl_tbl, OSM_LOG_D=
EBUG);
>>
>> =C2=A0 =C2=A0 =C2=A0 osm_physp_set_slvl_tbl(p_physp, p_slvl_tbl, in_=
port_num);
>> + =C2=A0 =C2=A0 goto Exit;
>> +
>> +opt_sl2vl:
>
> I think that you need to use functions here.
>
>> + =C2=A0 =C2=A0 OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Got optimized SLtoVL ge=
t response in_port_num %u out_port_num "
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "%u with GUID 0x%" PRIx6=
4 " for parent node GUID 0x%" PRIx64
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ", TID 0x%" PRIx64 "\n",=
 in_port_num, out_port_num,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cl_ntoh64(port_guid), cl=
_ntoh64(node_guid),
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cl_ntoh64(p_smp->trans_i=
d));
>> +

Is this a macro/va args limit ?

Does the existing log message this was modeled after need to change
too ? It is virtually the same (maybe one less arg).

-- Hal

<snip...>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
