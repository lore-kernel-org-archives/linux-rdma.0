From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: Add configurable retries for transactions
Date: Fri, 30 Oct 2009 11:48:58 -0400
Message-ID: <f0e08f230910300848i3a36ceedh4472478b6f492a7d@mail.gmail.com>
References: <20091024140538.GA5213@comcast.net> <20091030025541.GU20136@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091030025541.GU20136@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 29, 2009 at 10:55 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org=
> wrote:
> On 10:05 Sat 24 Oct =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> As part of this change, transaction timeouts (and retries) are per
>> umad agent (supplied at osm_vendor_bind).
>>
>> Old ABI is supported without these bind parameters.
>>
>> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> diff --git a/opensm/include/opensm/osm_madw.h b/opensm/include/opens=
m/osm_madw.h
>> index afa7047..10a065b 100644
>> --- a/opensm/include/opensm/osm_madw.h
>> +++ b/opensm/include/opensm/osm_madw.h
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
>> @@ -76,6 +77,8 @@ typedef struct osm_bind_info {
>> =C2=A0 =C2=A0 =C2=A0 boolean_t is_report_processor;
>> =C2=A0 =C2=A0 =C2=A0 uint32_t send_q_size;
>> =C2=A0 =C2=A0 =C2=A0 uint32_t recv_q_size;
>> + =C2=A0 =C2=A0 uint32_t timeout;
>> + =C2=A0 =C2=A0 uint32_t retries;
>> =C2=A0} osm_bind_info_t;
>> =C2=A0/*
>> =C2=A0* FIELDS
>> @@ -103,6 +106,12 @@ typedef struct osm_bind_info {
>> =C2=A0* =C2=A0 =C2=A0recv_q_size
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Receive Queue Size
>> =C2=A0*
>> +* =C2=A0 =C2=A0timeout
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Transaction timeout
>> +*
>> +* =C2=A0 =C2=A0retries
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Number of retries for tr=
ansaction
>> +*
>> =C2=A0* SEE ALSO
>> =C2=A0*********/
>>
>> diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/ope=
nsm/osm_subnet.h
>> index b63c97e..77347c8 100644
>> --- a/opensm/include/opensm/osm_subnet.h
>> +++ b/opensm/include/opensm/osm_subnet.h
>> @@ -4,6 +4,7 @@
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 * Copyright (c) 2008 Xsigo Systems Inc. =C2=A0All rights rese=
rved.
>> =C2=A0 * Copyright (c) 2009 System Fabric Works, Inc. All rights res=
erved.
>> + * Copyright (c) 2009 HNR Consulting. All rights reserved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> =C2=A0 * licenses. =C2=A0You may choose to be licensed under the ter=
ms of the GNU
>> @@ -149,6 +150,7 @@ typedef struct osm_subn_opt {
>> =C2=A0 =C2=A0 =C2=A0 uint32_t sweep_interval;
>> =C2=A0 =C2=A0 =C2=A0 uint32_t max_wire_smps;
>> =C2=A0 =C2=A0 =C2=A0 uint32_t transaction_timeout;
>> + =C2=A0 =C2=A0 uint32_t transaction_retries;
>> =C2=A0 =C2=A0 =C2=A0 uint8_t sm_priority;
>> =C2=A0 =C2=A0 =C2=A0 uint8_t lmc;
>> =C2=A0 =C2=A0 =C2=A0 boolean_t lmc_esp0;
>> @@ -261,6 +263,9 @@ typedef struct osm_subn_opt {
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0The maximum time in=
 milliseconds allowed for a transaction
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0to complete. =C2=A0=
Default is 200.
>> =C2=A0*
>> +* =C2=A0 =C2=A0transaction_retries
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0The number of retries fo=
r a transaction. Default is 3.
>> +*
>> =C2=A0* =C2=A0 =C2=A0sm_priority
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0The priority of thi=
s SM as specified by the user. =C2=A0This
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0value is made avail=
able in the SMInfo attribute.
>> diff --git a/opensm/libvendor/osm_vendor_ibumad.c b/opensm/libvendor=
/osm_vendor_ibumad.c
>> index 8d3c680..c98141e 100644
>> --- a/opensm/libvendor/osm_vendor_ibumad.c
>> +++ b/opensm/libvendor/osm_vendor_ibumad.c
>> @@ -85,6 +85,8 @@ typedef struct _osm_umad_bind_info {
>> =C2=A0 =C2=A0 =C2=A0 int port_id;
>> =C2=A0 =C2=A0 =C2=A0 int agent_id;
>> =C2=A0 =C2=A0 =C2=A0 int agent_id1; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
/* SMI requires two agents */
>> + =C2=A0 =C2=A0 uint32_t timeout;
>> + =C2=A0 =C2=A0 uint32_t max_retries;
>
> You don't need fixed size types for those values, do you? And umad_se=
nd()
> and umad_recv() accept timeout and retries parameters as 'int' - woul=
d
> be better to be consistent with types.
>
>> =C2=A0} osm_umad_bind_info_t;
>>
>> =C2=A0typedef struct _umad_receiver {
>> @@ -476,7 +478,7 @@ osm_vendor_init(IN osm_vendor_t * const p_vend,
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
>> @@ -819,6 +821,13 @@ osm_vendor_bind(IN osm_vendor_t * const p_vend,
>> =C2=A0 =C2=A0 =C2=A0 p_bind->send_err_callback =3D send_err_callback=
;
>> =C2=A0 =C2=A0 =C2=A0 p_bind->p_mad_pool =3D p_mad_pool;
>> =C2=A0 =C2=A0 =C2=A0 p_bind->port_guid =3D port_guid;
>> + =C2=A0 =C2=A0 if (p_vend->timeout =3D=3D -1) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_bind->timeout =3D p_us=
er_bind->timeout;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_bind->max_retries =3D =
p_user_bind->retries;
>> + =C2=A0 =C2=A0 } else {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_bind->timeout =3D p_ve=
nd->timeout;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_bind->max_retries =3D =
p_vend->max_retries;
>> + =C2=A0 =C2=A0 }
>
> Hmm, shouldn't we respect user requested data? Something like:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_bind->timeout =3D p_user_bind->timeout ?=
 p_user_bind->timeout :
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p_vend->timeout;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_bind->retries =3D p_user_bind->retries ?=
 p_user_bind->retries :
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p_vend->retries;
>
> ?

The -1 is for the new ABI.

>>
>> =C2=A0 =C2=A0 =C2=A0 memset(method_mask, 0, sizeof method_mask);
>> =C2=A0 =C2=A0 =C2=A0 if (p_user_bind->is_responder) {
>> @@ -1086,8 +1095,8 @@ Resp:
>> =C2=A0#endif
>> =C2=A0 =C2=A0 =C2=A0 if ((ret =3D umad_send(p_bind->port_id, p_bind-=
>agent_id, p_vw->umad,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0sent_mad_size,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0resp_expected ? p_vend->timeout : 0,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0p_vend->max_retries)) < 0) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0resp_expected ? p_bind->timeout : 0,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0p_bind->max_retries)) < 0) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(p_vend->p_l=
og, OSM_LOG_ERROR, "ERR 5430: "
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 "Send p_madw =3D %p of size %d failed %d (%m)\n",
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 p_madw, sent_mad_size, ret);
>> diff --git a/opensm/man/opensm.8.in b/opensm/man/opensm.8.in
>> index 03002c0..bd8ab4e 100644
>> --- a/opensm/man/opensm.8.in
>> +++ b/opensm/man/opensm.8.in
>> @@ -1,4 +1,4 @@
>> -.TH OPENSM 8 "September 14, 2009" "OpenIB" "OpenIB Management"
>> +.TH OPENSM 8 "October 22, 2009" "OpenIB" "OpenIB Management"
>>
>> =C2=A0.SH NAME
>> =C2=A0opensm \- InfiniBand subnet manager and administration (SM/SA)
>> @@ -31,6 +31,7 @@ opensm \- InfiniBand subnet manager and administra=
tion (SM/SA)
>> =C2=A0[\-o(nce)]
>> =C2=A0[\-s(weep) <interval>]
>> =C2=A0[\-t(imeout) <milliseconds>]
>> +[\-\-retries <number>]
>> =C2=A0[\-maxsmps <number>]
>> =C2=A0[\-console [off | local | socket | loopback]]
>> =C2=A0[\-console-port <port>]
>> @@ -233,6 +234,12 @@ Specifying -t 0 disables timeouts.
>> =C2=A0Without -t, OpenSM defaults to a timeout value of
>> =C2=A0200 milliseconds.
>> =C2=A0.TP
>> +\fB\-\-retries\fR <number>
>> +This option specifies the number of retries used
>> +for transactions.
>> +Without --retries, OpenSM defaults to 3 retries
>> +for transactions.
>> +.TP
>> =C2=A0\fB\-maxsmps\fR <number>
>> =C2=A0This option specifies the number of VL15 SMP MADs
>> =C2=A0allowed on the wire at any one time.
>> diff --git a/opensm/opensm/main.c b/opensm/opensm/main.c
>> index 2e28c83..b697994 100644
>> --- a/opensm/opensm/main.c
>> +++ b/opensm/opensm/main.c
>> @@ -248,6 +248,11 @@ static void show_usage(void)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0" =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Specifying -t 0 disables timeouts.\n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0" =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Without -t, OpenSM defaults to a timeout value of\n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0" =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0200 milliseconds.\n\n");
>> + =C2=A0 =C2=A0 printf("--retries <number>\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0" =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0This option specifies the number of retries used\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0" =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0for transactions.\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0" =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Without --retries, OpenSM defaults to %u retries\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0" =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0for transactions.\n\n", OSM_DEFAULT_RETRY_COUNT);
>> =C2=A0 =C2=A0 =C2=A0 printf("--maxsmps, -n <number>\n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0" =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0This option specifies the number of VL15 SMP MADs\n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0" =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0allowed on the wire at any one time.\n"
>> @@ -610,6 +615,7 @@ int main(int argc, char *argv[])
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 {"do_mesh_analysis"=
, 0, NULL, 5},
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 {"lash_start_vl", 1=
, NULL, 6},
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 {"sm_sl", 1, NULL, =
7},
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 {"retries", 1, NULL, 8},
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 {NULL, 0, NULL, 0} =
=C2=A0 =C2=A0 =C2=A0/* Required at the end of the array */
>> =C2=A0 =C2=A0 =C2=A0 };
>>
>> @@ -983,6 +989,11 @@ int main(int argc, char *argv[])
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 opt.sm_sl =3D (uint8_t) temp;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 printf(" SMSL =3D %d\n", opt.sm_sl);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 break;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 8:
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 opt.transaction_retries =3D strtol(optarg, NULL, 0);
>
> Please use strtoul().

OK. What about transaction_timeout ?

>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 printf(" Transaction retries =3D %u\n",
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0opt.transaction_retries);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 break;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 'h':
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case '?':
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case ':':
>> diff --git a/opensm/opensm/osm_opensm.c b/opensm/opensm/osm_opensm.c
>> index 1f2b067..52668ca 100644
>> --- a/opensm/opensm/osm_opensm.c
>> +++ b/opensm/opensm/osm_opensm.c
>> @@ -2,6 +2,7 @@
>> =C2=A0 * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
>> =C2=A0 * Copyright (c) 2002-2006 Mellanox Technologies LTD. All righ=
ts reserved.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> + * Copyright (c) 2009 HNR Consulting. All rights reserved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> =C2=A0 * licenses. =C2=A0You may choose to be licensed under the ter=
ms of the GNU
>> @@ -392,8 +393,7 @@ ib_api_status_t osm_opensm_init(IN osm_opensm_t =
* p_osm,
>> =C2=A0 =C2=A0 =C2=A0 if (status !=3D IB_SUCCESS)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto Exit;
>>
>> - =C2=A0 =C2=A0 p_osm->p_vendor =3D
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 osm_vendor_new(&p_osm->log, p_opt->tra=
nsaction_timeout);
>> + =C2=A0 =C2=A0 p_osm->p_vendor =3D osm_vendor_new(&p_osm->log, -1);
>
> Why to not make p_opt->transaction_timeout as default for newly
> allocated vendor object?

To support old and new ABI.

-- Hal

> Sasha
>
>> =C2=A0 =C2=A0 =C2=A0 if (p_osm->p_vendor =3D=3D NULL) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status =3D IB_INSUF=
=46ICIENT_RESOURCES;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto Exit;
>> diff --git a/opensm/opensm/osm_perfmgr.c b/opensm/opensm/osm_perfmgr=
=2Ec
>> index f95610e..f0ec92d 100644
>> --- a/opensm/opensm/osm_perfmgr.c
>> +++ b/opensm/opensm/osm_perfmgr.c
>> @@ -264,6 +264,8 @@ ib_api_status_t osm_perfmgr_bind(osm_perfmgr_t *=
 pm, ib_net64_t port_guid)
>> =C2=A0 =C2=A0 =C2=A0 bind_info.is_trap_processor =3D FALSE;
>> =C2=A0 =C2=A0 =C2=A0 bind_info.recv_q_size =3D OSM_PM_DEFAULT_QP1_RC=
V_SIZE;
>> =C2=A0 =C2=A0 =C2=A0 bind_info.send_q_size =3D OSM_PM_DEFAULT_QP1_SE=
ND_SIZE;
>> + =C2=A0 =C2=A0 bind_info.timeout =3D pm->subn->opt.transaction_time=
out;
>> + =C2=A0 =C2=A0 bind_info.retries =3D pm->subn->opt.transaction_retr=
ies;
>>
>> =C2=A0 =C2=A0 =C2=A0 OSM_LOG(pm->log, OSM_LOG_VERBOSE,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Binding to port GU=
ID 0x%" PRIx64 "\n", cl_ntoh64(port_guid));
>> diff --git a/opensm/opensm/osm_sa_mad_ctrl.c b/opensm/opensm/osm_sa_=
mad_ctrl.c
>> index f22411b..04b6693 100644
>> --- a/opensm/opensm/osm_sa_mad_ctrl.c
>> +++ b/opensm/opensm/osm_sa_mad_ctrl.c
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
>> @@ -528,6 +529,8 @@ ib_api_status_t osm_sa_mad_ctrl_bind(IN osm_sa_m=
ad_ctrl_t * p_ctrl,
>> =C2=A0 =C2=A0 =C2=A0 bind_info.port_guid =3D port_guid;
>> =C2=A0 =C2=A0 =C2=A0 bind_info.recv_q_size =3D OSM_SM_DEFAULT_QP1_RC=
V_SIZE;
>> =C2=A0 =C2=A0 =C2=A0 bind_info.send_q_size =3D OSM_SM_DEFAULT_QP1_SE=
ND_SIZE;
>> + =C2=A0 =C2=A0 bind_info.timeout =3D p_ctrl->sa->p_subn->opt.transa=
ction_timeout;
>> + =C2=A0 =C2=A0 bind_info.retries =3D p_ctrl->sa->p_subn->opt.transa=
ction_retries;
>>
>> =C2=A0 =C2=A0 =C2=A0 OSM_LOG(p_ctrl->p_log, OSM_LOG_VERBOSE,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Binding to port GU=
ID 0x%" PRIx64 "\n", cl_ntoh64(port_guid));
>> diff --git a/opensm/opensm/osm_sm_mad_ctrl.c b/opensm/opensm/osm_sm_=
mad_ctrl.c
>> index f96aff4..c51c158 100644
>> --- a/opensm/opensm/osm_sm_mad_ctrl.c
>> +++ b/opensm/opensm/osm_sm_mad_ctrl.c
>> @@ -885,6 +885,8 @@ ib_api_status_t osm_sm_mad_ctrl_bind(IN osm_sm_m=
ad_ctrl_t * p_ctrl,
>> =C2=A0 =C2=A0 =C2=A0 bind_info.port_guid =3D port_guid;
>> =C2=A0 =C2=A0 =C2=A0 bind_info.recv_q_size =3D OSM_SM_DEFAULT_QP0_RC=
V_SIZE;
>> =C2=A0 =C2=A0 =C2=A0 bind_info.send_q_size =3D OSM_SM_DEFAULT_QP0_SE=
ND_SIZE;
>> + =C2=A0 =C2=A0 bind_info.timeout =3D p_ctrl->p_subn->opt.transactio=
n_timeout;
>> + =C2=A0 =C2=A0 bind_info.retries =3D p_ctrl->p_subn->opt.transactio=
n_retries;
>>
>> =C2=A0 =C2=A0 =C2=A0 OSM_LOG(p_ctrl->p_log, OSM_LOG_VERBOSE,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Binding to port 0x=
%" PRIx64 "\n", cl_ntoh64(port_guid));
>> diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
>> index 8976b5f..a9a7981 100644
>> --- a/opensm/opensm/osm_subnet.c
>> +++ b/opensm/opensm/osm_subnet.c
>> @@ -4,6 +4,7 @@
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 * Copyright (c) 2008 Xsigo Systems Inc. =C2=A0All rights rese=
rved.
>> =C2=A0 * Copyright (c) 2009 System Fabric Works, Inc. All rights res=
erved.
>> + * Copyright (c) 2009 HNR Consulting. All rights reserved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> =C2=A0 * licenses. =C2=A0You may choose to be licensed under the ter=
ms of the GNU
>> @@ -299,6 +300,7 @@ static const opt_rec_t opt_tbl[] =3D {
>> =C2=A0 =C2=A0 =C2=A0 { "console", OPT_OFFSET(console), opts_parse_ch=
arp, NULL, 0 },
>> =C2=A0 =C2=A0 =C2=A0 { "console_port", OPT_OFFSET(console_port), opt=
s_parse_uint16, NULL, 0 },
>> =C2=A0 =C2=A0 =C2=A0 { "transaction_timeout", OPT_OFFSET(transaction=
_timeout), opts_parse_uint32, NULL, 1 },
>> + =C2=A0 =C2=A0 { "transaction_retries", OPT_OFFSET(transaction_retr=
ies), opts_parse_uint32, NULL, 1 },
>> =C2=A0 =C2=A0 =C2=A0 { "max_msg_fifo_timeout", OPT_OFFSET(max_msg_fi=
fo_timeout), opts_parse_uint32, NULL, 1 },
>> =C2=A0 =C2=A0 =C2=A0 { "sm_priority", OPT_OFFSET(sm_priority), opts_=
parse_uint8, opts_setup_sm_priority, 1 },
>> =C2=A0 =C2=A0 =C2=A0 { "lmc", OPT_OFFSET(lmc), opts_parse_uint8, NUL=
L, 1 },
>> @@ -694,6 +696,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t =
* p_opt)
>> =C2=A0 =C2=A0 =C2=A0 p_opt->console =3D strdup(OSM_DEFAULT_CONSOLE);
>> =C2=A0 =C2=A0 =C2=A0 p_opt->console_port =3D OSM_DEFAULT_CONSOLE_POR=
T;
>> =C2=A0 =C2=A0 =C2=A0 p_opt->transaction_timeout =3D OSM_DEFAULT_TRAN=
S_TIMEOUT_MILLISEC;
>> + =C2=A0 =C2=A0 p_opt->transaction_retries =3D OSM_DEFAULT_RETRY_COU=
NT;
>> =C2=A0 =C2=A0 =C2=A0 /* by default we will consider waiting for 50x =
transaction timeout normal */
>> =C2=A0 =C2=A0 =C2=A0 p_opt->max_msg_fifo_timeout =3D 50 * OSM_DEFAUL=
T_TRANS_TIMEOUT_MILLISEC;
>> =C2=A0 =C2=A0 =C2=A0 p_opt->sm_priority =3D OSM_DEFAULT_SM_PRIORITY;
>> @@ -1500,6 +1503,8 @@ int osm_subn_output_conf(FILE *out, IN osm_sub=
n_opt_t * p_opts)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "max_wire_smps %u\n=
\n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "# The maximum time=
 in [msec] allowed for a transaction to complete\n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "transaction_timeou=
t %u\n\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 " The maximum number of =
retries allowed for a transaction to complete\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "transaction_retries %u\=
n\n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "# Maximal time in =
[msec] a message can stay in the incoming message queue.\n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "# If there is more=
 than one message in the queue and the last message\n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "# stayed in the qu=
eue more than this value, any SA request will be\n"
>> @@ -1509,6 +1514,7 @@ int osm_subn_output_conf(FILE *out, IN osm_sub=
n_opt_t * p_opts)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "single_thread %s\n=
\n",
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_opts->max_wire_sm=
ps,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_opts->transaction=
_timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_opts->transaction_retr=
ies,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_opts->max_msg_fif=
o_timeout,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_opts->single_thre=
ad ? "TRUE" : "FALSE");
>>
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
