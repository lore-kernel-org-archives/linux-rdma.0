From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: Add a rate based mechanism for SMP transactions
Date: Wed, 2 Jun 2010 06:58:05 -0400
Message-ID: <AANLkTimDPaT0m-2Qa-0dTpng5FmQRhzUhpiBWFdxwGsQ@mail.gmail.com>
References: <20091216151115.GA22639@comcast.net>
	<20100601153234.GR28549@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100601153234.GR28549@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

On Tue, Jun 1, 2010 at 11:32 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> Hi Hal,
>
> On 10:11 Wed 16 Dec =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> In order to better handle non responsive SMAs (when link is physical=
ly up
>> but the SMA does not respond), a rate based mechanism for SMPs is ad=
ded
>> to better enable forward progress in a more timely fashion. So rathe=
r than
>> wait for timeouts and outstanding wire SMPs to drop below some confi=
gured
>> value, there is also a periodic rate for transaction based SMPs. The=
se
>> rate based SMPs are capped at a configured maximum value. In order t=
o
>> accomodate these, the vendor layer ibumad match table is increased b=
y
>> that number in order not to overflow due to these added transactions=
=2E
>>
>> Two new options are added for this:
>> rate_based_smp_usecs indicates the number of microseconds between ra=
te
>> based SMPs.
>> max_rate_based_smps indicates the maximum number of rate based SMPs
>> supported. When this limit is reached, rate based SMPs are no longer
>> sent (until the number of outstanding ones drops below this limit).
>
> As far as I learned the patch.... Wouldn't something like below does =
the
> same work:
>
>
> diff --git a/opensm/opensm/osm_vl15intf.c b/opensm/opensm/osm_vl15int=
f.c
> index ff9e4db..a16d88e 100644
> --- a/opensm/opensm/osm_vl15intf.c
> +++ b/opensm/opensm/osm_vl15intf.c
> @@ -113,6 +113,8 @@ static void vl15_poller(IN void *p_ptr)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0osm_madw_t *p_madw;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0osm_vl15_t *p_vl =3D p_ptr;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cl_qlist_t *p_fifo;
> + =C2=A0 =C2=A0 =C2=A0 int32_t max_smps =3D p_vl->max_wire_smps;
> + =C2=A0 =C2=A0 =C2=A0 int32_t max_wire_smps2 =3D 2 * max_smps; /* FI=
XME: make configurable */
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0OSM_LOG_ENTER(p_vl->p_log);
>
> @@ -156,16 +158,21 @@ static void vl15_poller(IN void *p_ptr)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0EVENT_NO_TIMEOUT, TRUE);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0while (p_vl->p=
_stats->qp0_mads_outstanding_on_wire >=3D
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0(int32_t) p_vl->max_wire_smps &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0max_smps &&
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 p_vl->thread_state =3D=3D OSM_THREAD_STATE_RUN) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0status =3D cl_event_wait_on(&p_vl->signal,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0EVENT_NO_TIMEOUT, TRUE);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (status !=3D CL_SUCCESS) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (status =3D=3D CL_TIMEOUT &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 max_smps < max_wire_smps2) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 max_smps++;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 } else if (status !=3D CL_SUCCESS) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0OSM_LOG(p_vl->p_log, OSM_LOG_=
ERROR, "ERR 3E02: "
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"=
Event wait failed (%s)\n",
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0C=
L_STATUS_MSG(status));
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0}
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 max_smps =3D p_vl->max_wire_smps;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
>
> If yes, we will need only have two configurable max_wire_smps limits.

I had started with an algorithm along these lines but evolved towards
the proposed one based on CPU utilization. An algorithm along the
lines of the above wastes CPU (when "idling" and other times) which
significantly impacts any other apps running.

-- Hal

> Sasha
>
>>
>> The rate based SMP mechanism can be disabled by setting rate_based_s=
mp_usecs
>> to 0. This is equivalent to the (current) algorithm prior to this ch=
ange.
>>
>> Test results:
>>
>> Subnet consists of 55 switches (all 36-port IS4) and couple of HCAs.
>> OpenSM configuration to enlarge the fabric: LMC=3D7, LMC of
>> extended port 0 =3D TRUE.
>>
>> It takes ~8K SMPs to configure this fabric (no QoS).
>>
>> Measured section of the code: LFTs configuration, which is
>> the most SMP-intense phase of the sweep.
>>
>> Existing OpenSM code:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0max_wire_smps=3D1: LFT configuration took=
 ~0.27 sec
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0max_wire_smps=3D4: LFT configuration took=
 ~0.13 sec
>>
>> OpenSM with rate-based SMPs
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0no difference from the existing OpenSM wa=
s observed.
>>
>> Further testing showed that when subnet is OK (no timeouts),
>> SM doesn't send rate-based SMPs at all, or sends just a couple
>> of them (out of total 8K SMPs).
>>
>> Experimenting with "bad" fabric:
>> With 480 timeouts in a row, all the timeouts were failed Set() comma=
nds.
>> OpenSM configuration was as follows:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0max_wire_smps=3D1
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0rate_based_smp_usec=3D10000 (10 msec)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0max_rate_based_smps=3D100
>>
>> Whole sweep time: 21 seconds
>> Virtually all the SMPs were rate-based.
>> Calculating how much this should have taken w/o rate-based SMPs:
>> (480 timeouts) * (3 retries) * (0.2 sec timeout) =3D 4.8 minutes
>> so this is a big improvement in the presence of errors.
>>
>> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> diff --git a/opensm/include/opensm/osm_base.h b/opensm/include/opens=
m/osm_base.h
>> index 4e9aaa9..ddb1265 100644
>> --- a/opensm/include/opensm/osm_base.h
>> +++ b/opensm/include/opensm/osm_base.h
>> @@ -448,6 +448,30 @@ BEGIN_C_DECLS
>> =C2=A0*/
>> =C2=A0#define OSM_DEFAULT_SMP_MAX_ON_WIRE 4
>> =C2=A0/***********/
>> +/****d* OpenSM: Base/OSM_DEFAULT_SMP_RATE
>> +* NAME
>> +* =C2=A0 =C2=A0OSM_DEFAULT_SMP_RATE
>> +*
>> +* DESCRIPTION
>> +* =C2=A0 =C2=A0Specifies the default rate (in usec) for rate based =
SMPs.
>> +* =C2=A0 =C2=A0The default rate is 1 msec (1000 usec). A value of 0
>> +* =C2=A0 =C2=A0(or EVENT_NO_TIMEOUT) disables the rate based SMP me=
chanism.
>> +*
>> +* SYNOPSIS
>> +*/
>> +#define OSM_DEFAULT_SMP_RATE 1000
>> +/***********/
>> +/****d* OpenSM: Base/OSM_DEFAULT_SMP_RATE_MAX
>> +* NAME
>> +* =C2=A0 =C2=A0OSM_DEFAULT_SMP_RATE_MAX
>> +*
>> +* DESCRIPTION
>> +* =C2=A0 =C2=A0Specifies the default maximum number of outstanding =
rate based SMPs.
>> +*
>> +* SYNOPSIS
>> +*/
>> +#define OSM_DEFAULT_SMP_RATE_MAX 1000
>> +/***********/
>> =C2=A0/****d* OpenSM: Base/OSM_SM_DEFAULT_QP0_RCV_SIZE
>> =C2=A0* NAME
>> =C2=A0* =C2=A0 =C2=A0OSM_SM_DEFAULT_QP0_RCV_SIZE
>> diff --git a/opensm/include/opensm/osm_madw.h b/opensm/include/opens=
m/osm_madw.h
>> index 9c63151..a590278 100644
>> --- a/opensm/include/opensm/osm_madw.h
>> +++ b/opensm/include/opensm/osm_madw.h
>> @@ -1,6 +1,6 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
>> - * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights re=
served.
>> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights re=
served.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 * Copyright (c) 2009 HNR Consulting. All rights reserved.
>> =C2=A0 *
>> @@ -421,6 +421,7 @@ typedef struct osm_madw {
>> =C2=A0 =C2=A0 =C2=A0 ib_api_status_t status;
>> =C2=A0 =C2=A0 =C2=A0 cl_disp_msgid_t fail_msg;
>> =C2=A0 =C2=A0 =C2=A0 boolean_t resp_expected;
>> + =C2=A0 =C2=A0 boolean_t rate_based_smp;
>> =C2=A0 =C2=A0 =C2=A0 const ib_mad_t *p_mad;
>> =C2=A0} osm_madw_t;
>> =C2=A0/*
>> @@ -461,6 +462,10 @@ typedef struct osm_madw {
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TRUE if a response =
is expected to this MAD.
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FALSE otherwise.
>> =C2=A0*
>> +* =C2=A0 =C2=A0rate_based_smp
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TRUE if send is being re=
quested based on rate based SMP
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0algorithm. FALSE otherwi=
se.
>> +*
>> =C2=A0* =C2=A0 =C2=A0p_mad
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Pointer to the wire=
 MAD. =C2=A0The MAD itself cannot be part of the
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0wrapper, since wire=
 MADs typically reside in special memory
>> @@ -490,6 +495,7 @@ static inline void osm_madw_init(IN osm_madw_t *=
 p_madw,
>> =C2=A0 =C2=A0 =C2=A0 if (p_mad_addr)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_madw->mad_addr =3D=
 *p_mad_addr;
>> =C2=A0 =C2=A0 =C2=A0 p_madw->resp_expected =3D FALSE;
>> + =C2=A0 =C2=A0 p_madw->rate_based_smp =3D FALSE;
>> =C2=A0}
>>
>> =C2=A0/*
>> diff --git a/opensm/include/opensm/osm_stats.h b/opensm/include/open=
sm/osm_stats.h
>> index 4331cfa..bb1400a 100644
>> --- a/opensm/include/opensm/osm_stats.h
>> +++ b/opensm/include/opensm/osm_stats.h
>> @@ -1,6 +1,6 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
>> - * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights re=
served.
>> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights re=
served.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> @@ -84,6 +84,7 @@ BEGIN_C_DECLS
>> =C2=A0typedef struct osm_stats {
>> =C2=A0 =C2=A0 =C2=A0 atomic32_t qp0_mads_outstanding;
>> =C2=A0 =C2=A0 =C2=A0 atomic32_t qp0_mads_outstanding_on_wire;
>> + =C2=A0 =C2=A0 atomic32_t qp0_rate_based_smps_outstanding;
>> =C2=A0 =C2=A0 =C2=A0 atomic32_t qp0_mads_rcvd;
>> =C2=A0 =C2=A0 =C2=A0 atomic32_t qp0_mads_sent;
>> =C2=A0 =C2=A0 =C2=A0 atomic32_t qp0_unicasts_sent;
>> @@ -112,6 +113,11 @@ typedef struct osm_stats {
>> =C2=A0* =C2=A0 =C2=A0qp0_mads_outstanding_on_wire
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0The number of MADs =
outstanding on the wire at any moment.
>> =C2=A0*
>> +* =C2=A0 =C2=A0qp0_rate_based_smps_outstanding
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0The number of rate based=
 SMPs outstanding on QP0.
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0This count is included i=
n qp0_mads_outstanding.
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0It is used for rate base=
d SMP accounting.
>> +*
>> =C2=A0* =C2=A0 =C2=A0qp0_mads_rcvd
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Total number of QP0=
 MADs received.
>> =C2=A0*
>> diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/ope=
nsm/osm_subnet.h
>> index c484d60..b0ca174 100644
>> --- a/opensm/include/opensm/osm_subnet.h
>> +++ b/opensm/include/opensm/osm_subnet.h
>> @@ -1,6 +1,6 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
>> - * Copyright (c) 2002-2008 Mellanox Technologies LTD. All rights re=
served.
>> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights re=
served.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 * Copyright (c) 2008 Xsigo Systems Inc. =C2=A0All rights rese=
rved.
>> =C2=A0 * Copyright (c) 2009 System Fabric Works, Inc. All rights res=
erved.
>> @@ -149,6 +149,8 @@ typedef struct osm_subn_opt {
>> =C2=A0 =C2=A0 =C2=A0 ib_net16_t m_key_lease_period;
>> =C2=A0 =C2=A0 =C2=A0 uint32_t sweep_interval;
>> =C2=A0 =C2=A0 =C2=A0 uint32_t max_wire_smps;
>> + =C2=A0 =C2=A0 uint32_t rate_based_smp_usecs;
>> + =C2=A0 =C2=A0 uint32_t max_rate_based_smps;
>> =C2=A0 =C2=A0 =C2=A0 uint32_t transaction_timeout;
>> =C2=A0 =C2=A0 =C2=A0 uint32_t transaction_retries;
>> =C2=A0 =C2=A0 =C2=A0 uint8_t sm_priority;
>> @@ -260,6 +262,14 @@ typedef struct osm_subn_opt {
>> =C2=A0* =C2=A0 =C2=A0max_wire_smps
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0The maximum number =
of SMPs sent in parallel. =C2=A0Default is 4.
>> =C2=A0*
>> +* =C2=A0 =C2=A0rate_based_smp_usecs
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0The wait time in usec fo=
r rate based SMPs. =C2=A0Default is 1000
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0usec (1 msec).
>> +*
>> +* =C2=A0 =C2=A0max_rate_based_smps
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0The maximum number of ra=
te based SMPs allowed to be outstanding.
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Default is 1000.
>> +*
>> =C2=A0* =C2=A0 =C2=A0transaction_timeout
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0The maximum time in=
 milliseconds allowed for a transaction
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0to complete. =C2=A0=
Default is 200.
>> diff --git a/opensm/include/opensm/osm_vl15intf.h b/opensm/include/o=
pensm/osm_vl15intf.h
>> index 15ed56c..b52af83 100644
>> --- a/opensm/include/opensm/osm_vl15intf.h
>> +++ b/opensm/include/opensm/osm_vl15intf.h
>> @@ -1,6 +1,6 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
>> - * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights re=
served.
>> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights re=
served.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> @@ -117,6 +117,8 @@ typedef struct osm_vl15 {
>> =C2=A0 =C2=A0 =C2=A0 osm_thread_state_t thread_state;
>> =C2=A0 =C2=A0 =C2=A0 osm_vl15_state_t state;
>> =C2=A0 =C2=A0 =C2=A0 uint32_t max_wire_smps;
>> + =C2=A0 =C2=A0 uint32_t rate_based_smp_usecs;
>> + =C2=A0 =C2=A0 uint32_t max_rate_based_smps;
>> =C2=A0 =C2=A0 =C2=A0 cl_event_t signal;
>> =C2=A0 =C2=A0 =C2=A0 cl_thread_t poller;
>> =C2=A0 =C2=A0 =C2=A0 cl_qlist_t rfifo;
>> @@ -137,6 +139,12 @@ typedef struct osm_vl15 {
>> =C2=A0* =C2=A0 =C2=A0max_wire_smps
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Maximum number of V=
L15 MADs allowed on the wire at one time.
>> =C2=A0*
>> +* =C2=A0 =C2=A0rate_based_smp_usecs
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Wait time in usec for ra=
te based SMPs.
>> +*
>> +* =C2=A0 =C2=A0max_rate_based_smps
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Maximum number of rate b=
ased SMPs allowed to be outstanding.
>> +*
>> =C2=A0* =C2=A0 =C2=A0signal
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Event on which the =
poller sleeps.
>> =C2=A0*
>> @@ -243,7 +251,9 @@ void osm_vl15_destroy(IN osm_vl15_t * p_vl15, IN=
 struct osm_mad_pool *p_pool);
>> =C2=A0*/
>> =C2=A0ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_vl15, IN osm_v=
endor_t * p_vend,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN osm_log_t * p_log, IN osm_stats_t * p_s=
tats,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 IN int32_t max_wire_smps);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 IN int32_t max_wire_smps,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 IN uint32_t rate_based_smp_usecs,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 IN uint32_t max_rate_based_smps);
>> =C2=A0/*
>> =C2=A0* PARAMETERS
>> =C2=A0* =C2=A0 =C2=A0p_vl15
>> @@ -261,6 +271,13 @@ ib_api_status_t osm_vl15_init(IN osm_vl15_t * p=
_vl15, IN osm_vendor_t * p_vend,
>> =C2=A0* =C2=A0 =C2=A0max_wire_smps
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[in] Maximum number=
 of MADs allowed on the wire at one time.
>> =C2=A0*
>> +* =C2=A0 =C2=A0rate_based_smp_usecs
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[in] Wait time in usec f=
or rate based SMPs.
>> +*
>> +* =C2=A0 =C2=A0max_rate_based_smps
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[in] Maximum number of r=
ate based SMPs allowed to be
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 outstandi=
ng.
>> +*
>> =C2=A0* RETURN VALUES
>> =C2=A0* =C2=A0 =C2=A0IB_SUCCESS if the VL15 object was initialized s=
uccessfully.
>> =C2=A0*
>> diff --git a/opensm/include/vendor/osm_vendor_api.h b/opensm/include=
/vendor/osm_vendor_api.h
>> index 4973417..dfefd8a 100644
>> --- a/opensm/include/vendor/osm_vendor_api.h
>> +++ b/opensm/include/vendor/osm_vendor_api.h
>> @@ -1,6 +1,6 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2004, 2005 Voltaire, Inc. All rights reserved=
=2E
>> - * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights re=
served.
>> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights re=
served.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> @@ -132,7 +132,8 @@ typedef void (*osm_vend_mad_send_err_callback_t)=
 (IN void *bind_context,
>> =C2=A0* SYNOPSIS
>> =C2=A0*/
>> =C2=A0osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t timeout);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t max_rate_based_smps);
>> =C2=A0/*
>> =C2=A0* PARAMETERS
>> =C2=A0* =C2=A0p_log
>> @@ -141,6 +142,9 @@ osm_vendor_t *osm_vendor_new(IN osm_log_t * cons=
t p_log,
>> =C2=A0* =C2=A0timeout
>> =C2=A0* =C2=A0 =C2=A0 [in] transaction timeout
>> =C2=A0*
>> +* =C2=A0max_rate_based_smps
>> +* =C2=A0 =C2=A0 [in] maximum number of rate based SMPs
>> +*
>> =C2=A0* RETURN VALUES
>> =C2=A0* =C2=A0Returns a pointer to the vendor object.
>> =C2=A0*
>> @@ -220,7 +224,8 @@ osm_vendor_get_all_port_attr(IN osm_vendor_t * c=
onst p_vend,
>> =C2=A0*/
>> =C2=A0ib_api_status_t
>> =C2=A0osm_vendor_init(IN osm_vendor_t * const p_vend, IN osm_log_t *=
 const p_log,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN const uint32_t timeou=
t);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN const uint32_t timeou=
t,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN const uint32_t max_ra=
te_based_smps);
>> =C2=A0/*
>> =C2=A0* PARAMETERS
>> =C2=A0* =C2=A0p_vend
>> @@ -234,6 +239,9 @@ osm_vendor_init(IN osm_vendor_t * const p_vend, =
IN osm_log_t * const p_log,
>> =C2=A0* =C2=A0 =C2=A0 [in] Transaction timeout value in milliseconds=
=2E
>> =C2=A0* =C2=A0 =C2=A0 A value of 0 disables timeouts.
>> =C2=A0*
>> +* =C2=A0max_rate_based_smps
>> +* =C2=A0 =C2=A0 [in] Maximum number of rate based SMPs.
>> +*
>> =C2=A0* RETURN VALUE
>> =C2=A0*
>> =C2=A0* NOTES
>> diff --git a/opensm/libvendor/osm_vendor_al.c b/opensm/libvendor/osm=
_vendor_al.c
>> index 3ac05c9..7184957 100644
>> --- a/opensm/libvendor/osm_vendor_al.c
>> +++ b/opensm/libvendor/osm_vendor_al.c
>> @@ -1,6 +1,6 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
>> - * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights re=
served.
>> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights re=
served.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> @@ -329,7 +329,8 @@ __osm_al_rcv_callback(IN void *mad_svc_context, =
IN ib_mad_element_t * p_elem)
>>
>> =C2=A0ib_api_status_t
>> =C2=A0osm_vendor_init(IN osm_vendor_t * const p_vend,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN osm_log_t * const p_l=
og, IN const uint32_t timeout)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN osm_log_t * const p_l=
og, IN const uint32_t timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN const uint32_t max_ra=
te_based_smps)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 ib_api_status_t status;
>> =C2=A0 =C2=A0 =C2=A0 OSM_LOG_ENTER(p_log);
>> @@ -356,7 +357,8 @@ Exit:
>> =C2=A0}
>>
>> =C2=A0osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t timeout)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t max_rate_based_smps)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 ib_api_status_t status;
>> =C2=A0 =C2=A0 =C2=A0 osm_vendor_t *p_vend;
>> @@ -373,7 +375,7 @@ osm_vendor_t *osm_vendor_new(IN osm_log_t * cons=
t p_log,
>>
>> =C2=A0 =C2=A0 =C2=A0 memset(p_vend, 0, sizeof(*p_vend));
>>
>> - =C2=A0 =C2=A0 status =3D osm_vendor_init(p_vend, p_log, timeout);
>> + =C2=A0 =C2=A0 status =3D osm_vendor_init(p_vend, p_log, timeout, m=
ax_rate_based_smps);
>> =C2=A0 =C2=A0 =C2=A0 if (status !=3D IB_SUCCESS) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(p_vend);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_vend =3D NULL;
>> diff --git a/opensm/libvendor/osm_vendor_ibumad.c b/opensm/libvendor=
/osm_vendor_ibumad.c
>> index 6927060..73e4f59 100644
>> --- a/opensm/libvendor/osm_vendor_ibumad.c
>> +++ b/opensm/libvendor/osm_vendor_ibumad.c
>> @@ -1,6 +1,6 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
>> - * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights re=
served.
>> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights re=
served.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 * Copyright (c) 2009 HNR Consulting. All rights reserved.
>> =C2=A0 * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserv=
ed.
>> @@ -439,7 +439,8 @@ static void umad_receiver_stop(umad_receiver_t *=
 p_ur)
>>
>> =C2=A0ib_api_status_t
>> =C2=A0osm_vendor_init(IN osm_vendor_t * const p_vend,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN osm_log_t * const p_l=
og, IN const uint32_t timeout)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN osm_log_t * const p_l=
og, IN const uint32_t timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN const uint32_t max_ra=
te_based_smps)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 char *max =3D NULL;
>> =C2=A0 =C2=A0 =C2=A0 int r, n_cas;
>> @@ -471,7 +472,7 @@ osm_vendor_init(IN osm_vendor_t * const p_vend,
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> =C2=A0 =C2=A0 =C2=A0 p_vend->ca_count =3D n_cas;
>> - =C2=A0 =C2=A0 p_vend->mtbl.max =3D DEFAULT_OSM_UMAD_MAX_PENDING;
>> + =C2=A0 =C2=A0 p_vend->mtbl.max =3D max_rate_based_smps + DEFAULT_O=
SM_UMAD_MAX_PENDING;
>>
>> =C2=A0 =C2=A0 =C2=A0 if ((max =3D getenv("OSM_UMAD_MAX_PENDING")) !=3D=
 NULL) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int tmp =3D strtol(=
max, NULL, 0);
>> @@ -500,7 +501,8 @@ Exit:
>> =C2=A0}
>>
>> =C2=A0osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t timeout)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t max_rate_based_smps)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 osm_vendor_t *p_vend =3D NULL;
>>
>> @@ -521,7 +523,7 @@ osm_vendor_t *osm_vendor_new(IN osm_log_t * cons=
t p_log,
>>
>> =C2=A0 =C2=A0 =C2=A0 memset(p_vend, 0, sizeof(*p_vend));
>>
>> - =C2=A0 =C2=A0 if (osm_vendor_init(p_vend, p_log, timeout) < 0) {
>> + =C2=A0 =C2=A0 if (osm_vendor_init(p_vend, p_log, timeout, max_rate=
_based_smps) < 0) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(p_vend);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_vend =3D NULL;
>> =C2=A0 =C2=A0 =C2=A0 }
>> diff --git a/opensm/libvendor/osm_vendor_mlx.c b/opensm/libvendor/os=
m_vendor_mlx.c
>> index 9ae59a9..af7a7c2 100644
>> --- a/opensm/libvendor/osm_vendor_mlx.c
>> +++ b/opensm/libvendor/osm_vendor_mlx.c
>> @@ -1,6 +1,6 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
>> - * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights re=
served.
>> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights re=
served.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> @@ -64,7 +64,8 @@ static void __osm_vendor_internal_unbind(osm_bind_=
handle_t h_bind);
>> =C2=A0 */
>>
>> =C2=A0osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t timeout)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t max_rate_based_smps)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 ib_api_status_t status;
>> =C2=A0 =C2=A0 =C2=A0 osm_vendor_t *p_vend;
>> @@ -77,7 +78,8 @@ osm_vendor_t *osm_vendor_new(IN osm_log_t * const =
p_log,
>> =C2=A0 =C2=A0 =C2=A0 if (p_vend !=3D NULL) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(p_vend, 0, s=
izeof(*p_vend));
>>
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status =3D osm_vendor_in=
it(p_vend, p_log, timeout);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status =3D osm_vendor_in=
it(p_vend, p_log, timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0max_r=
ate_based_smps);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (status !=3D IB_=
SUCCESS) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 osm_vendor_delete(&p_vend);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> @@ -147,7 +149,8 @@ void osm_vendor_delete(IN osm_vendor_t ** const =
pp_vend)
>>
>> =C2=A0ib_api_status_t
>> =C2=A0osm_vendor_init(IN osm_vendor_t * const p_vend,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN osm_log_t * const p_l=
og, IN const uint32_t timeout)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN osm_log_t * const p_l=
og, IN const uint32_t timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN const uint32_t max_ra=
te_based_smps)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 ib_api_status_t status =3D IB_SUCCESS;
>>
>> diff --git a/opensm/libvendor/osm_vendor_mlx_anafa.c b/opensm/libven=
dor/osm_vendor_mlx_anafa.c
>> index fbaab1d..4ab840a 100644
>> --- a/opensm/libvendor/osm_vendor_mlx_anafa.c
>> +++ b/opensm/libvendor/osm_vendor_mlx_anafa.c
>> @@ -1,6 +1,6 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
>> - * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights re=
served.
>> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights re=
served.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> @@ -71,7 +71,8 @@ static void __osm_vendor_internal_unbind(osm_bind_=
handle_t h_bind);
>> =C2=A0 */
>>
>> =C2=A0osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t timeout)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t max_rate_based_smps)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 ib_api_status_t status;
>> =C2=A0 =C2=A0 =C2=A0 osm_vendor_t *p_vend;
>> @@ -83,7 +84,8 @@ osm_vendor_t *osm_vendor_new(IN osm_log_t * const =
p_log,
>> =C2=A0 =C2=A0 =C2=A0 p_vend =3D malloc(sizeof(*p_vend));
>> =C2=A0 =C2=A0 =C2=A0 if (p_vend !=3D NULL) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(p_vend, 0, s=
izeof(*p_vend));
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status =3D osm_vendor_in=
it(p_vend, p_log, timeout);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status =3D osm_vendor_in=
it(p_vend, p_log, timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0max_r=
ate_based_smps);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (status !=3D IB_=
SUCCESS) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 osm_vendor_delete(&p_vend);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> @@ -159,7 +161,8 @@ void osm_vendor_delete(IN osm_vendor_t ** const =
pp_vend)
>>
>> =C2=A0ib_api_status_t
>> =C2=A0osm_vendor_init(IN osm_vendor_t * const p_vend,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN osm_log_t * const p_l=
og, IN const uint32_t timeout)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN osm_log_t * const p_l=
og, IN const uint32_t timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN const uint32_t max_ra=
te_based_smps)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 ib_api_status_t status =3D IB_SUCCESS;
>> =C2=A0 =C2=A0 =C2=A0 char device_file[16];
>> diff --git a/opensm/libvendor/osm_vendor_mtl.c b/opensm/libvendor/os=
m_vendor_mtl.c
>> index ede3c71..85228e2 100644
>> --- a/opensm/libvendor/osm_vendor_mtl.c
>> +++ b/opensm/libvendor/osm_vendor_mtl.c
>> @@ -1,6 +1,6 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
>> - * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights re=
served.
>> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights re=
served.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> @@ -302,7 +302,8 @@ void osm_vendor_delete(IN osm_vendor_t ** const =
pp_vend)
>>
>> =C2=A0ib_api_status_t
>> =C2=A0osm_vendor_init(IN osm_vendor_t * const p_vend,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN osm_log_t * const p_l=
og, IN const uint32_t timeout)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN osm_log_t * const p_l=
og, IN const uint32_t timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN const uint32_t max_ra=
te_based_smps)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 osm_vendor_mgt_bind_t *ib_mgt_hdl_p;
>> =C2=A0 =C2=A0 =C2=A0 ib_api_status_t status =3D IB_SUCCESS;
>> @@ -342,7 +343,8 @@ Exit:
>> =C2=A0 * =C2=A0Create and Initialize osm_vendor_t Object
>> =C2=A0 *************************************************************=
*********/
>> =C2=A0osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t timeout)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t max_rate_based_smps)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 ib_api_status_t status;
>> =C2=A0 =C2=A0 =C2=A0 osm_vendor_t *p_vend;
>> @@ -354,7 +356,8 @@ osm_vendor_t *osm_vendor_new(IN osm_log_t * cons=
t p_log,
>> =C2=A0 =C2=A0 =C2=A0 p_vend =3D malloc(sizeof(*p_vend));
>> =C2=A0 =C2=A0 =C2=A0 if (p_vend !=3D NULL) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(p_vend, 0, s=
izeof(*p_vend));
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status =3D osm_vendor_in=
it(p_vend, p_log, timeout);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status =3D osm_vendor_in=
it(p_vend, p_log, timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0max_r=
ate_based_smps);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (status !=3D IB_=
SUCCESS) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 osm_vendor_delete(&p_vend);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> diff --git a/opensm/libvendor/osm_vendor_test.c b/opensm/libvendor/o=
sm_vendor_test.c
>> index 9f7b104..3a3ca55 100644
>> --- a/opensm/libvendor/osm_vendor_test.c
>> +++ b/opensm/libvendor/osm_vendor_test.c
>> @@ -75,7 +75,8 @@ void osm_vendor_delete(IN osm_vendor_t ** const pp=
_vend)
>>
>> =C2=A0ib_api_status_t
>> =C2=A0osm_vendor_init(IN osm_vendor_t * const p_vend,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN osm_log_t * const p_l=
og, IN const uint32_t timeout)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN osm_log_t * const p_l=
og, IN const uint32_t timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN const uint32_t max_ra=
te_based_smps)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 OSM_LOG_ENTER(p_log);
>>
>> @@ -89,7 +90,8 @@ osm_vendor_init(IN osm_vendor_t * const p_vend,
>> =C2=A0}
>>
>> =C2=A0osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t timeout)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t max_rate_based_smps)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 ib_api_status_t status;
>> =C2=A0 =C2=A0 =C2=A0 osm_vendor_t *p_vend;
>> @@ -101,7 +103,8 @@ osm_vendor_t *osm_vendor_new(IN osm_log_t * cons=
t p_log,
>> =C2=A0 =C2=A0 =C2=A0 if (p_vend !=3D NULL) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(p_vend, 0, s=
izeof(*p_vend));
>>
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status =3D osm_vendor_in=
it(p_vend, p_log, timeout);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status =3D osm_vendor_in=
it(p_vend, p_log, timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0max_r=
ate_based_smps);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (status !=3D IB_=
SUCCESS) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 osm_vendor_delete(&p_vend);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> diff --git a/opensm/libvendor/osm_vendor_ts.c b/opensm/libvendor/osm=
_vendor_ts.c
>> index f4f1df1..a418098 100644
>> --- a/opensm/libvendor/osm_vendor_ts.c
>> +++ b/opensm/libvendor/osm_vendor_ts.c
>> @@ -1,6 +1,6 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
>> - * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights re=
served.
>> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights re=
served.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> @@ -211,7 +211,8 @@ void osm_vendor_delete(IN osm_vendor_t ** const =
pp_vend)
>>
>> =C2=A0ib_api_status_t
>> =C2=A0osm_vendor_init(IN osm_vendor_t * const p_vend,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN osm_log_t * const p_l=
og, IN const uint32_t timeout)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN osm_log_t * const p_l=
og, IN const uint32_t timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN const uint32_t max_ra=
te_based_smps)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 ib_api_status_t status =3D IB_SUCCESS;
>>
>> @@ -234,7 +235,8 @@ osm_vendor_init(IN osm_vendor_t * const p_vend,
>> =C2=A0 * =C2=A0Create and Initialize osm_vendor_t Object
>> =C2=A0 *************************************************************=
*********/
>> =C2=A0osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t timeout)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t max_rate_based_smps)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 ib_api_status_t status;
>> =C2=A0 =C2=A0 =C2=A0 osm_vendor_t *p_vend;
>> @@ -247,7 +249,8 @@ osm_vendor_t *osm_vendor_new(IN osm_log_t * cons=
t p_log,
>> =C2=A0 =C2=A0 =C2=A0 if (p_vend !=3D NULL) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(p_vend, 0, s=
izeof(*p_vend));
>>
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status =3D osm_vendor_in=
it(p_vend, p_log, timeout);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status =3D osm_vendor_in=
it(p_vend, p_log, timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0max_r=
ate_based_smps);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (status !=3D IB_=
SUCCESS) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 osm_vendor_delete(&p_vend);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> diff --git a/opensm/libvendor/osm_vendor_umadt.c b/opensm/libvendor/=
osm_vendor_umadt.c
>> index b4d707d..b03351a 100644
>> --- a/opensm/libvendor/osm_vendor_umadt.c
>> +++ b/opensm/libvendor/osm_vendor_umadt.c
>> @@ -1,6 +1,6 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
>> - * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights re=
served.
>> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights re=
served.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> @@ -126,7 +126,8 @@ __match_tid_context(const cl_list_item_t * const=
 p_list_item, void *context);
>> =C2=A0void __osm_vendor_timer_callback(IN void *context);
>>
>> =C2=A0osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t timeout)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IN const uint32_t max_rate_based_smps)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 ib_api_status_t status;
>> =C2=A0 =C2=A0 =C2=A0 umadt_obj_t *p_umadt_obj;
>> @@ -138,7 +139,7 @@ osm_vendor_t *osm_vendor_new(IN osm_log_t * cons=
t p_log,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(p_umadt_obj,=
 0, sizeof(umadt_obj_t));
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status =3D osm_vend=
or_init((osm_vendor_t *) p_umadt_obj, p_log,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0timeo=
ut);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0timeo=
ut, max_rate_based_smps);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (status !=3D IB_=
SUCCESS) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 osm_vendor_delete((osm_vendor_t **) & p_umadt_obj);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> @@ -189,7 +190,8 @@ void osm_vendor_delete(IN osm_vendor_t ** const =
pp_vend)
>> =C2=A0/* =C2=A0*/
>> =C2=A0ib_api_status_t
>> =C2=A0osm_vendor_init(IN osm_vendor_t * const p_vend,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN osm_log_t * const p_l=
og, IN const uint32_t timeout)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN osm_log_t * const p_l=
og, IN const uint32_t timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN const uint32_t max_ra=
te_based_smps)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 FSTATUS Status;
>> =C2=A0 =C2=A0 =C2=A0 PUMADT_GET_INTERFACE uMadtGetInterface;
>> diff --git a/opensm/opensm/osm_console.c b/opensm/opensm/osm_console=
=2Ec
>> index 206e7f7..f2327df 100644
>> --- a/opensm/opensm/osm_console.c
>> +++ b/opensm/opensm/osm_console.c
>> @@ -1,6 +1,7 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2005-2009 Voltaire, Inc. All rights reserved.
>> =C2=A0 * Copyright (c) 2009 HNR Consulting. All rights reserved.
>> + * Copyright (c) 2009 Mellanox Technologies LTD. All rights reserve=
d.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> =C2=A0 * licenses. =C2=A0You may choose to be licensed under the ter=
ms of the GNU
>> @@ -393,19 +394,21 @@ static void print_status(osm_opensm_t * p_osm,=
 FILE * out)
>> =C2=A0#endif
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(out, "\n =C2=
=A0 MAD stats\n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 " =C2=A0 ---------\n"
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 QP0 MADs outstanding =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : =
%d\n"
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 QP0 MADs outstanding (on wire) : %d\n"
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 QP0 MADs rcvd =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0: %d\n"
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 QP0 MADs sent =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0: %d\n"
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 QP0 unicasts sent =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0: %d\n"
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 QP0 unknown MADs rcvd =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0: =
%d\n"
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 SA MADs outstanding =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0: %d\n"
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 SA MADs rcvd =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 : %d\n"
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 SA MADs sent =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 : %d\n"
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 SA unknown MADs rcvd =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : =
%d\n"
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 SA MADs ignored =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0: %d\n",
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 QP0 MADs outstanding =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0: %d\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 QP0 MADs outstanding (on wire) =C2=A0: %d\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 QP0 rate based SMPs outstanding : %d\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 QP0 MADs rcvd =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 : %d\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 QP0 MADs sent =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 : %d\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 QP0 unicasts sent =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 : %d\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 QP0 unknown MADs rcvd =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 :=
 %d\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 SA MADs outstanding =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 : %d\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 SA MADs rcvd =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0: %d\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 SA MADs sent =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0: %d\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 SA unknown MADs rcvd =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0: %d\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 " =C2=A0 SA MADs ignored =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 : %d\n",
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 p_osm->stats.qp0_mads_outstanding,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 p_osm->stats.qp0_mads_outstanding_on_wire,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 p_osm->stats.qp0_rate_based_smps_outstanding,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 p_osm->stats.qp0_mads_rcvd,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 p_osm->stats.qp0_mads_sent,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 p_osm->stats.qp0_unicasts_sent,
>> diff --git a/opensm/opensm/osm_opensm.c b/opensm/opensm/osm_opensm.c
>> index 5b3b364..cc587aa 100644
>> --- a/opensm/opensm/osm_opensm.c
>> +++ b/opensm/opensm/osm_opensm.c
>> @@ -1,6 +1,6 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
>> - * Copyright (c) 2002-2006 Mellanox Technologies LTD. All rights re=
served.
>> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights re=
served.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> @@ -379,7 +379,8 @@ ib_api_status_t osm_opensm_init(IN osm_opensm_t =
* p_osm,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto Exit;
>>
>> =C2=A0 =C2=A0 =C2=A0 p_osm->p_vendor =3D
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 osm_vendor_new(&p_osm->log, p_opt->tra=
nsaction_timeout);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 osm_vendor_new(&p_osm->log, p_opt->tra=
nsaction_timeout,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0p_opt->max_rate_based_smps);
>> =C2=A0 =C2=A0 =C2=A0 if (p_osm->p_vendor =3D=3D NULL) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status =3D IB_INSUF=
=46ICIENT_RESOURCES;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto Exit;
>> @@ -391,7 +392,9 @@ ib_api_status_t osm_opensm_init(IN osm_opensm_t =
* p_osm,
>>
>> =C2=A0 =C2=A0 =C2=A0 status =3D osm_vl15_init(&p_osm->vl15, p_osm->p=
_vendor,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&p_osm->log, &p_osm->stats,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p_opt->max_wire_smps);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p_opt->max_wire_smps,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p_opt->rate_based_smp_usecs,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p_opt->max_rate_based_smps);
>> =C2=A0 =C2=A0 =C2=A0 if (status !=3D IB_SUCCESS)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto Exit;
>>
>> diff --git a/opensm/opensm/osm_sm_mad_ctrl.c b/opensm/opensm/osm_sm_=
mad_ctrl.c
>> index 3ae1eb6..ce61792 100644
>> --- a/opensm/opensm/osm_sm_mad_ctrl.c
>> +++ b/opensm/opensm/osm_sm_mad_ctrl.c
>> @@ -82,6 +82,8 @@ static void sm_mad_ctrl_retire_trans_mad(IN osm_sm=
_mad_ctrl_t * p_ctrl,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Retiring MAD with =
TID 0x%" PRIx64 "\n",
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cl_ntoh64(osm_madw_=
get_smp_ptr(p_madw)->trans_id));
>>
>> + =C2=A0 =C2=A0 if (p_madw->rate_based_smp)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cl_atomic_dec(&p_ctrl->p=
_stats->qp0_rate_based_smps_outstanding);
>> =C2=A0 =C2=A0 =C2=A0 osm_mad_pool_put(p_ctrl->p_mad_pool, p_madw);
>>
>> =C2=A0 =C2=A0 =C2=A0 outstanding =3D osm_stats_dec_qp0_outstanding(p=
_ctrl->p_stats);
>> @@ -211,6 +213,7 @@ static void sm_mad_ctrl_process_get_resp(IN osm_=
sm_mad_ctrl_t * p_ctrl,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0can return the original MAD to the=
 pool.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>> =C2=A0 =C2=A0 =C2=A0 osm_madw_copy_context(p_madw, p_old_madw);
>> + =C2=A0 =C2=A0 p_madw->rate_based_smp =3D p_old_madw->rate_based_sm=
p;
>> =C2=A0 =C2=A0 =C2=A0 osm_mad_pool_put(p_ctrl->p_mad_pool, p_old_madw=
);
>>
>> =C2=A0 =C2=A0 =C2=A0 /*
>> diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
>> index 032ef38..0c5f84d 100644
>> --- a/opensm/opensm/osm_subnet.c
>> +++ b/opensm/opensm/osm_subnet.c
>> @@ -297,6 +297,8 @@ static const opt_rec_t opt_tbl[] =3D {
>> =C2=A0 =C2=A0 =C2=A0 { "m_key_lease_period", OPT_OFFSET(m_key_lease_=
period), opts_parse_net16, NULL, 1 },
>> =C2=A0 =C2=A0 =C2=A0 { "sweep_interval", OPT_OFFSET(sweep_interval),=
 opts_parse_uint32, NULL, 1 },
>> =C2=A0 =C2=A0 =C2=A0 { "max_wire_smps", OPT_OFFSET(max_wire_smps), o=
pts_parse_uint32, NULL, 1 },
>> + =C2=A0 =C2=A0 { "rate_based_smp_usecs", OPT_OFFSET(rate_based_smp_=
usecs), opts_parse_uint32, NULL, 1 },
>> + =C2=A0 =C2=A0 { "max_rate_based_smps", OPT_OFFSET(max_rate_based_s=
mps), opts_parse_uint32, NULL, 1 },
>> =C2=A0 =C2=A0 =C2=A0 { "console", OPT_OFFSET(console), opts_parse_ch=
arp, NULL, 0 },
>> =C2=A0 =C2=A0 =C2=A0 { "console_port", OPT_OFFSET(console_port), opt=
s_parse_uint16, NULL, 0 },
>> =C2=A0 =C2=A0 =C2=A0 { "transaction_timeout", OPT_OFFSET(transaction=
_timeout), opts_parse_uint32, NULL, 1 },
>> @@ -680,6 +682,8 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t =
* p_opt)
>> =C2=A0 =C2=A0 =C2=A0 p_opt->m_key_lease_period =3D 0;
>> =C2=A0 =C2=A0 =C2=A0 p_opt->sweep_interval =3D OSM_DEFAULT_SWEEP_INT=
ERVAL_SECS;
>> =C2=A0 =C2=A0 =C2=A0 p_opt->max_wire_smps =3D OSM_DEFAULT_SMP_MAX_ON=
_WIRE;
>> + =C2=A0 =C2=A0 p_opt->rate_based_smp_usecs =3D OSM_DEFAULT_SMP_RATE=
;
>> + =C2=A0 =C2=A0 p_opt->max_rate_based_smps =3D OSM_DEFAULT_SMP_RATE_=
MAX;
>> =C2=A0 =C2=A0 =C2=A0 p_opt->console =3D strdup(OSM_DEFAULT_CONSOLE);
>> =C2=A0 =C2=A0 =C2=A0 p_opt->console_port =3D OSM_DEFAULT_CONSOLE_POR=
T;
>> =C2=A0 =C2=A0 =C2=A0 p_opt->transaction_timeout =3D OSM_DEFAULT_TRAN=
S_TIMEOUT_MILLISEC;
>> @@ -1080,6 +1084,9 @@ int osm_subn_verify_config(IN osm_subn_opt_t *=
 p_opts)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_opts->max_wire_sm=
ps =3D OSM_DEFAULT_SMP_MAX_ON_WIRE;
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> + =C2=A0 =C2=A0 if (p_opts->rate_based_smp_usecs =3D=3D 0)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_opts->rate_based_smp_u=
secs =3D EVENT_NO_TIMEOUT;
>> +
>> =C2=A0 =C2=A0 =C2=A0 if (strcmp(p_opts->console, OSM_DISABLE_CONSOLE=
)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 && strcmp(p_opts->console, OSM_LO=
CAL_CONSOLE)
>> =C2=A0#ifdef ENABLE_OSM_CONSOLE_SOCKET
>> @@ -1483,6 +1490,11 @@ int osm_subn_output_conf(FILE *out, IN osm_su=
bn_opt_t * p_opts)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "#\n# TIMING AND TH=
READING OPTIONS\n#\n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "# Maximum number o=
f SMPs sent in parallel\n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "max_wire_smps %u\n=
\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "# The rate in [usec] at=
 which rate based SMPs are sent\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "# A value of 0 disables=
 the rate based SMP mechanism\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "rate_based_smp_usecs %u=
\n\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "# Maximum number of rat=
e based SMPs allowed to be outstanding\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "max_rate_based_smps %u\=
n\n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "# The maximum time=
 in [msec] allowed for a transaction to complete\n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "transaction_timeou=
t %u\n\n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "# The maximum numb=
er of retries allowed for a transaction to complete\n"
>> @@ -1495,6 +1507,8 @@ int osm_subn_output_conf(FILE *out, IN osm_sub=
n_opt_t * p_opts)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "# Use a single thr=
ead for handling SA queries\n"
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "single_thread %s\n=
\n",
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_opts->max_wire_sm=
ps,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_opts->rate_based_smp_u=
secs,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_opts->max_rate_based_s=
mps,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_opts->transaction=
_timeout,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_opts->transaction=
_retries,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_opts->max_msg_fif=
o_timeout,
>> diff --git a/opensm/opensm/osm_vl15intf.c b/opensm/opensm/osm_vl15in=
tf.c
>> index cc3ff33..e2b3888 100644
>> --- a/opensm/opensm/osm_vl15intf.c
>> +++ b/opensm/opensm/osm_vl15intf.c
>> @@ -1,7 +1,7 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserv=
ed.
>> =C2=A0 * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
>> - * Copyright (c) 2002-2006 Mellanox Technologies LTD. All rights re=
served.
>> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights re=
served.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> @@ -54,7 +54,8 @@
>> =C2=A0#include <opensm/osm_log.h>
>> =C2=A0#include <opensm/osm_helper.h>
>>
>> -static void vl15_send_mad(osm_vl15_t * p_vl, osm_madw_t * p_madw)
>> +static void vl15_send_mad(osm_vl15_t * p_vl, osm_madw_t * p_madw,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 boolean_t rate_based)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 ib_api_status_t status;
>>
>> @@ -63,7 +64,7 @@ static void vl15_send_mad(osm_vl15_t * p_vl, osm_m=
adw_t * p_madw)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0since we can have no confirmation =
that they arrived
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0at their destination.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>> - =C2=A0 =C2=A0 if (p_madw->resp_expected =3D=3D TRUE)
>> + =C2=A0 =C2=A0 if (p_madw->resp_expected =3D=3D TRUE) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Note t=
hat other threads may not see the response MAD
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0arrive=
 before send() even returns.
>> @@ -71,8 +72,12 @@ static void vl15_send_mad(osm_vl15_t * p_vl, osm_=
madw_t * p_madw)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0To avo=
id this confusion, preincrement the counts on the
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0assump=
tion that send() will succeed.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rate_based) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 p_madw->rate_based_smp =3D rate_based;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 cl_atomic_inc(&p_vl->p_stats->qp0_rate_based_smps_outstanding);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cl_atomic_inc(&p_vl=
->p_stats->qp0_mads_outstanding_on_wire);
>> - =C2=A0 =C2=A0 else
>> + =C2=A0 =C2=A0 } else
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cl_atomic_inc(&p_vl=
->p_stats->qp0_unicasts_sent);
>>
>> =C2=A0 =C2=A0 =C2=A0 cl_atomic_inc(&p_vl->p_stats->qp0_mads_sent);
>> @@ -106,6 +111,8 @@ static void vl15_send_mad(osm_vl15_t * p_vl, osm=
_madw_t * p_madw)
>> =C2=A0 =C2=A0 =C2=A0 cl_atomic_dec(&p_vl->p_stats->qp0_mads_sent);
>> =C2=A0 =C2=A0 =C2=A0 if (!p_madw->resp_expected)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cl_atomic_dec(&p_vl=
->p_stats->qp0_unicasts_sent);
>> + =C2=A0 =C2=A0 else if (rate_based)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cl_atomic_dec(&p_vl->p_s=
tats->qp0_rate_based_smps_outstanding);
>> =C2=A0}
>>
>> =C2=A0static void vl15_poller(IN void *p_ptr)
>> @@ -114,6 +121,7 @@ static void vl15_poller(IN void *p_ptr)
>> =C2=A0 =C2=A0 =C2=A0 osm_madw_t *p_madw;
>> =C2=A0 =C2=A0 =C2=A0 osm_vl15_t *p_vl =3D p_ptr;
>> =C2=A0 =C2=A0 =C2=A0 cl_qlist_t *p_fifo;
>> + =C2=A0 =C2=A0 boolean_t rate_based =3D FALSE;
>>
>> =C2=A0 =C2=A0 =C2=A0 OSM_LOG_ENTER(p_vl->p_log);
>>
>> @@ -148,7 +156,7 @@ static void vl15_poller(IN void *p_ptr)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 osm_madw_get_smp_ptr(p_madw),
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 OSM_LOG_FRAMES);
>>
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 vl15_send_mad(p_vl, p_madw);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 vl15_send_mad(p_vl, p_madw, rate_based);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 /*
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0The VL15 FIFO is empty, so we have nothing left to=
 do.
>> @@ -156,11 +164,20 @@ static void vl15_poller(IN void *p_ptr)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 status =3D cl_event_wait_on(&p_vl->signal,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 EVENT_NO_TIMEOUT, TRUE);
>>
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rate_based =3D FALSE;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 while (p_vl->p_stat=
s->qp0_mads_outstanding_on_wire >=3D
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0(int32_t) p_vl->max_wire_smps &&
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0p_vl->thread_state =3D=3D OSM_THREAD_STATE_RUN) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 status =3D cl_event_wait_on(&p_vl->signal,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 EVENT_NO_TIMEOUT, TRUE);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 p_vl->rate_based_smp_usecs,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 TRUE);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (status =3D=3D CL_TIMEOUT) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (p_vl->p_stats->qp0_rate_based_smps_=
outstanding >=3D
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (int32_t) p_vl->max_rate_=
based_smps)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rate_based =3D TRUE;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 }
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (status !=3D CL_SUCCESS) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(p_vl->p_log, OSM_LOG_ERROR,=
 "ERR 3E02: "
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Event =
wait failed (%s)\n",
>> @@ -237,7 +254,9 @@ void osm_vl15_destroy(IN osm_vl15_t * p_vl, IN s=
truct osm_mad_pool *p_pool)
>>
>> =C2=A0ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_vl, IN osm_ven=
dor_t * p_vend,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN osm_log_t * p_log, IN osm_stats_t * p_s=
tats,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 IN int32_t max_wire_smps)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 IN int32_t max_wire_smps,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 IN uint32_t rate_based_smp_usecs,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 IN uint32_t max_rate_based_smps)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 ib_api_status_t status =3D IB_SUCCESS;
>>
>> @@ -247,6 +266,8 @@ ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_=
vl, IN osm_vendor_t * p_vend,
>> =C2=A0 =C2=A0 =C2=A0 p_vl->p_log =3D p_log;
>> =C2=A0 =C2=A0 =C2=A0 p_vl->p_stats =3D p_stats;
>> =C2=A0 =C2=A0 =C2=A0 p_vl->max_wire_smps =3D max_wire_smps;
>> + =C2=A0 =C2=A0 p_vl->rate_based_smp_usecs =3D rate_based_smp_usecs;
>> + =C2=A0 =C2=A0 p_vl->max_rate_based_smps =3D max_rate_based_smps;
>>
>> =C2=A0 =C2=A0 =C2=A0 status =3D cl_event_init(&p_vl->signal, FALSE);
>> =C2=A0 =C2=A0 =C2=A0 if (status !=3D IB_SUCCESS)
>> @@ -354,6 +375,8 @@ void osm_vl15_shutdown(IN osm_vl15_t * p_vl, IN =
osm_mad_pool_t * p_mad_pool)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(p_vl->p_log=
, OSM_LOG_DEBUG,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 "Releasing Request p_madw =3D %p\n", p_madw);
>>
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (p_madw->rate_based_s=
mp)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 cl_atomic_dec(&p_vl->p_stats->qp0_rate_based_smps_outstanding);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 osm_mad_pool_put(p_=
mad_pool, p_madw);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 osm_stats_dec_qp0_o=
utstanding(p_vl->p_stats);
>>
>> diff --git a/opensm/osmtest/osmtest.c b/opensm/osmtest/osmtest.c
>> index 50f94db..d362c57 100644
>> --- a/opensm/osmtest/osmtest.c
>> +++ b/opensm/osmtest/osmtest.c
>> @@ -1,6 +1,6 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2006-2009 Voltaire, Inc. All rights reserved.
>> - * Copyright (c) 2002-2007 Mellanox Technologies LTD. All rights re=
served.
>> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights re=
served.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 * Copyright (c) 2009 HNR Consulting. All rights reserved.
>> =C2=A0 *
>> @@ -498,7 +498,7 @@ osmtest_init(IN osmtest_t * const p_osmt,
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(status =3D=3D CL_SUCCESS);
>>
>> =C2=A0 =C2=A0 =C2=A0 p_osmt->p_vendor =3D osm_vendor_new(&p_osmt->lo=
g,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_op=
t->transaction_timeout);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_op=
t->transaction_timeout, 0);
>>
>> =C2=A0 =C2=A0 =C2=A0 if (p_osmt->p_vendor =3D=3D NULL) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status =3D IB_INSUF=
=46ICIENT_RESOURCES;
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
