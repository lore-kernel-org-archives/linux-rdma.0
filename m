From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: qos on service-id
Date: Mon, 23 Nov 2009 09:04:24 -0500
Message-ID: <f0e08f230911230604m5b33f47ax4599e634712b57e@mail.gmail.com>
References: <4B0A4C71.5080209@bull.net> <4B0A5F64.1030107@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B0A5F64.1030107-6ktuUTfB/bM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?C=C3=A9line_Bourde?= <celine.bourde-6ktuUTfB/bM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 23, 2009 at 5:09 AM, C=C3=A9line Bourde <celine.bourde@bull=
=2Enet> wrote:
> My /var/log/opensm.log output:
>
> Nov 20 14:33:58 824870 [9C8566F0] 0x02 -> osm_vendor_init: 1000 pendi=
ng
> umads specified
> Nov 20 14:33:58 825157 [9C8566F0] 0x80 -> Entering DISCOVERING state
> Using default GUID 0x2c9000100d00056d
> Loading Cached Option:qos_max_vls =3D 8
> Loading Cached Option:qos_high_limit =3D 1
> Loading Cached Option:qos_vlarb_high =3D 0:1,1:0,2:0,3:0,4:0
> Loading Cached Option:qos_vlarb_low =3D 0:1,1:2,2:4,3:8,4:0,5:32
> Loading Cached Option:qos_sl2vl =3D 0,1,2,3,4,5,6,7,8,9,10,11,12,13,1=
4,15
> Entering MASTER state
>
> Nov 20 14:33:58 840416 [9C8566F0] 0x02 -> osm_vendor_bind: Binding to=
 port
> 0x2c9000100d00056d
> Nov 20 14:33:58 877496 [9C8566F0] 0x02 -> osm_vendor_bind: Binding to=
 port
> 0x2c9000100d00056d
> Nov 20 14:33:58 877646 [9C8566F0] 0x02 -> osm_vendor_bind: Binding to=
 port
> 0x2c9000100d00056d
> Nov 20 14:33:58 877794 [9C8566F0] 0x02 -> osm_opensm_bind: Setting IS=
_SM on
> port 0x2c9000100d00056d
> Nov 20 14:33:58 952249 [98C4F910] 0x80 -> Entering MASTER state
> Nov 20 14:33:58 952467 [98C4F910] 0x02 -> osm_qos_parse_policy_file: =
Loading
> QoS policy file (/etc/opensm/qos-policy.conf)
> Nov 20 14:33:59 047411 [9824E910] 0x01 -> sm_mad_ctrl_rcv_callback: E=
RR
> 3111: Error status =3D 0x1C
> Nov 20 14:33:59 047894 [9824E910] 0x01 -> SMP dump:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 base_ver................0x1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mgmt_class..............0x81
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 class_ver...............0x1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 method..................0x81 (SubnG=
etResp)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 D bit...................0x1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status..................0x1C
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hop_ptr.................0x0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hop_count...............0x2
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 trans_id................0x18ef
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 attr_id.................0x17
> (SLtoVLMappingTable)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 resv....................0x0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 attr_mod................0x0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 m_key...................0x000000000=
0000000
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dr_slid.................65535
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dr_dlid.................65535
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Initial path: 0,1,31
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Return path: =C2=A00,22,1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Reserved: =C2=A0 =C2=A0 [0][0][0][0=
][0][0][0]
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 01 23 45 67 01 23 45 6F =C2=A0 00 0=
0 00 00 00 00 00
> 00
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 00 00 00 00 00 00 00 00 =C2=A0 00 0=
0 00 00 00 00 00
> 00
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 00 00 00 00 00 00 00 00 =C2=A0 00 0=
0 00 00 00 00 00
> 00
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 00 00 00 00 00 00 00 00 =C2=A0 00 0=
0 00 00 00 00 00
> 00

What node (NodeInfo) is at direct route 0,1,31 relative to the SM node =
?

Is it just this AM failing for the SLtoVLMapping attribute or others to=
o ?

-- Hal

>
> C=C3=A9line Bourde a =C3=A9crit :
>>
>> Hi,
>>
>> I'm trying to configure qos-policy.donc file for service-id use.
>> I've tried basic RDMA_PS_TCP service-id level with service id 0x0106
>>
>> []# cat /etc/opensm/qos-policy.conf
>> qos-levels
>> =C2=A0 =C2=A0 qos-level
>> =C2=A0 =C2=A0 name: DEFAULT
>> =C2=A0 =C2=A0 sl: 0
>> =C2=A0 =C2=A0 end-qos-level
>> =C2=A0 =C2=A0 qos-level
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 name: TCP
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 sl: 4
>> =C2=A0 =C2=A0 end-qos-level
>> =C2=A0 =C2=A0 =C2=A0 qos-level
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0name: MPI
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sl: 5
>> =C2=A0 =C2=A0 =C2=A0end-qos-level
>> end-qos-levels
>>
>> qos-ulps
>> =C2=A0default =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 : 0 # default SL
>> =C2=A0any, service-id 0x0000000001060000- 0x000000000106FFFF : 4
>> end-qos-ulps
>>
>> I add this rule in my configuration and check by mapping
>> sl 4 on a vl with a weight of 0
>>
>> # QoS default options
>> qos_max_vls 8
>> qos_high_limit 1
>> qos_vlarb_high 0:1,1:0,2:0,3:0,4:0
>> qos_vlarb_low 0:1,1:2,2:4,3:8,4:0,5:32
>> qos_sl2vl 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>>
>> I've launched qperf on the server side
>> and listen on client:
>>
>> j=3D100; for i in $(seq 0 $j) ; do /usr/bin/qperf -ri mlx4_0:1 -li m=
lx4_0:1
>> 10.12.1.4 -sl 4 -lp 20004 rc_bw; done;
>> rc_bw:
>> =C2=A0bw =C2=A0=3D =C2=A00 bytes/sec
>> rc_bw:
>> =C2=A0bw =C2=A0=3D =C2=A00 bytes/sec
>>
>> j=3D100; for i in $(seq 0 $j) ; do /usr/bin/qperf -ri mlx4_0:1 -li m=
lx4_0:1
>> 10.12.1.4 -sl 5 -lp 20005 rc_bw; done;
>> rc_bw:
>> =C2=A0bw =C2=A0=3D =C2=A03.37 GB/sec
>> rc_bw:
>> =C2=A0bw =C2=A0=3D =C2=A03.37 GB/sec
>>
>> Qperf gives me results I expected due to qos-level configuration par=
t, but
>> no
>> expected results using qperf tcp_bw, bandwith is not
>> filtered/blocked by sl weight.
>>
>> # j=3D100; for i in $(seq 0 $j) ; do /usr/bin/qperf 10.12.1.4 tcp_bw=
; done;
>> tcp_bw:
>> =C2=A0bw =C2=A0=3D =C2=A0923 MB/sec
>> tcp_bw:
>> =C2=A0bw =C2=A0=3D =C2=A0935 MB/sec
>>
>> j=3D100; for i in $(seq 0 $j) ; do /usr/bin/qperf -ri mlx4_0:1 -li m=
lx4_0:1
>> 10.12.1.4 -sl 5 -lp 20005 rc_bw; done;
>> rc_bw:
>> =C2=A0bw =C2=A0=3D =C2=A02.23 GB/sec
>> rc_bw:
>> =C2=A0bw =C2=A0=3D =C2=A02.24 GB/sec
>> rc_bw:
>> =C2=A0bw =C2=A0=3D =C2=A02.21 GB/sec
>>
>> Could you help me to understanding service-id mechanism or give me a
>> relevant
>> test to test TCP service id level ?
>>
>> Thanks.
>>
>> C=C3=A9line Bourde.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>>
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
