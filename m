From: =?UTF-8?B?Q8OpbGluZSBCb3VyZGU=?= <celine.bourde-6ktuUTfB/bM@public.gmane.org>
Subject: Re: qos on service-id
Date: Mon, 23 Nov 2009 15:22:03 +0100
Message-ID: <4B0A9A8B.4020908@bull.net>
References: <4B0A4C71.5080209@bull.net> <4B0A5F64.1030107@bull.net> <f0e08f230911230604m5b33f47ax4599e634712b57e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f0e08f230911230604m5b33f47ax4599e634712b57e-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

You right, it is just an isolated node.
We don't have to take this into account

Hal Rosenstock a =C3=A9crit :
> On Mon, Nov 23, 2009 at 5:09 AM, C=C3=A9line Bourde <celine.bourde@bu=
ll.net> wrote:
>  =20
>> My /var/log/opensm.log output:
>>
>> Nov 20 14:33:58 824870 [9C8566F0] 0x02 -> osm_vendor_init: 1000 pend=
ing
>> umads specified
>> Nov 20 14:33:58 825157 [9C8566F0] 0x80 -> Entering DISCOVERING state
>> Using default GUID 0x2c9000100d00056d
>> Loading Cached Option:qos_max_vls =3D 8
>> Loading Cached Option:qos_high_limit =3D 1
>> Loading Cached Option:qos_vlarb_high =3D 0:1,1:0,2:0,3:0,4:0
>> Loading Cached Option:qos_vlarb_low =3D 0:1,1:2,2:4,3:8,4:0,5:32
>> Loading Cached Option:qos_sl2vl =3D 0,1,2,3,4,5,6,7,8,9,10,11,12,13,=
14,15
>> Entering MASTER state
>>
>> Nov 20 14:33:58 840416 [9C8566F0] 0x02 -> osm_vendor_bind: Binding t=
o port
>> 0x2c9000100d00056d
>> Nov 20 14:33:58 877496 [9C8566F0] 0x02 -> osm_vendor_bind: Binding t=
o port
>> 0x2c9000100d00056d
>> Nov 20 14:33:58 877646 [9C8566F0] 0x02 -> osm_vendor_bind: Binding t=
o port
>> 0x2c9000100d00056d
>> Nov 20 14:33:58 877794 [9C8566F0] 0x02 -> osm_opensm_bind: Setting I=
S_SM on
>> port 0x2c9000100d00056d
>> Nov 20 14:33:58 952249 [98C4F910] 0x80 -> Entering MASTER state
>> Nov 20 14:33:58 952467 [98C4F910] 0x02 -> osm_qos_parse_policy_file:=
 Loading
>> QoS policy file (/etc/opensm/qos-policy.conf)
>> Nov 20 14:33:59 047411 [9824E910] 0x01 -> sm_mad_ctrl_rcv_callback: =
ERR
>> 3111: Error status =3D 0x1C
>> Nov 20 14:33:59 047894 [9824E910] 0x01 -> SMP dump:
>>                               base_ver................0x1
>>                               mgmt_class..............0x81
>>                               class_ver...............0x1
>>                               method..................0x81 (SubnGetR=
esp)
>>                               D bit...................0x1
>>                               status..................0x1C
>>                               hop_ptr.................0x0
>>                               hop_count...............0x2
>>                               trans_id................0x18ef
>>                               attr_id.................0x17
>> (SLtoVLMappingTable)
>>                               resv....................0x0
>>                               attr_mod................0x0
>>                               m_key...................0x000000000000=
0000
>>                               dr_slid.................65535
>>                               dr_dlid.................65535
>>
>>                               Initial path: 0,1,31
>>                               Return path:  0,22,1
>>                               Reserved:     [0][0][0][0][0][0][0]
>>
>>                               01 23 45 67 01 23 45 6F   00 00 00 00 =
00 00 00
>> 00
>>
>>                               00 00 00 00 00 00 00 00   00 00 00 00 =
00 00 00
>> 00
>>
>>                               00 00 00 00 00 00 00 00   00 00 00 00 =
00 00 00
>> 00
>>
>>                               00 00 00 00 00 00 00 00   00 00 00 00 =
00 00 00
>> 00
>>    =20
>
> What node (NodeInfo) is at direct route 0,1,31 relative to the SM nod=
e ?
>
> Is it just this AM failing for the SLtoVLMapping attribute or others =
too ?
>
> -- Hal
>
>  =20
>> C=C3=A9line Bourde a =C3=A9crit :
>>    =20
>>> Hi,
>>>
>>> I'm trying to configure qos-policy.donc file for service-id use.
>>> I've tried basic RDMA_PS_TCP service-id level with service id 0x010=
6
>>>
>>> []# cat /etc/opensm/qos-policy.conf
>>> qos-levels
>>>     qos-level
>>>     name: DEFAULT
>>>     sl: 0
>>>     end-qos-level
>>>     qos-level
>>>         name: TCP
>>>         sl: 4
>>>     end-qos-level
>>>       qos-level
>>>          name: MPI
>>>          sl: 5
>>>      end-qos-level
>>> end-qos-levels
>>>
>>> qos-ulps
>>>  default                       : 0 # default SL
>>>  any, service-id 0x0000000001060000- 0x000000000106FFFF : 4
>>> end-qos-ulps
>>>
>>> I add this rule in my configuration and check by mapping
>>> sl 4 on a vl with a weight of 0
>>>
>>> # QoS default options
>>> qos_max_vls 8
>>> qos_high_limit 1
>>> qos_vlarb_high 0:1,1:0,2:0,3:0,4:0
>>> qos_vlarb_low 0:1,1:2,2:4,3:8,4:0,5:32
>>> qos_sl2vl 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>>>
>>> I've launched qperf on the server side
>>> and listen on client:
>>>
>>> j=3D100; for i in $(seq 0 $j) ; do /usr/bin/qperf -ri mlx4_0:1 -li =
mlx4_0:1
>>> 10.12.1.4 -sl 4 -lp 20004 rc_bw; done;
>>> rc_bw:
>>>  bw  =3D  0 bytes/sec
>>> rc_bw:
>>>  bw  =3D  0 bytes/sec
>>>
>>> j=3D100; for i in $(seq 0 $j) ; do /usr/bin/qperf -ri mlx4_0:1 -li =
mlx4_0:1
>>> 10.12.1.4 -sl 5 -lp 20005 rc_bw; done;
>>> rc_bw:
>>>  bw  =3D  3.37 GB/sec
>>> rc_bw:
>>>  bw  =3D  3.37 GB/sec
>>>
>>> Qperf gives me results I expected due to qos-level configuration pa=
rt, but
>>> no
>>> expected results using qperf tcp_bw, bandwith is not
>>> filtered/blocked by sl weight.
>>>
>>> # j=3D100; for i in $(seq 0 $j) ; do /usr/bin/qperf 10.12.1.4 tcp_b=
w; done;
>>> tcp_bw:
>>>  bw  =3D  923 MB/sec
>>> tcp_bw:
>>>  bw  =3D  935 MB/sec
>>>
>>> j=3D100; for i in $(seq 0 $j) ; do /usr/bin/qperf -ri mlx4_0:1 -li =
mlx4_0:1
>>> 10.12.1.4 -sl 5 -lp 20005 rc_bw; done;
>>> rc_bw:
>>>  bw  =3D  2.23 GB/sec
>>> rc_bw:
>>>  bw  =3D  2.24 GB/sec
>>> rc_bw:
>>>  bw  =3D  2.21 GB/sec
>>>
>>> Could you help me to understanding service-id mechanism or give me =
a
>>> relevant
>>> test to test TCP service id level ?
>>>
>>> Thanks.
>>>
>>> C=C3=A9line Bourde.
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdm=
a" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>      =20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>    =20
>
>
>  =20

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
