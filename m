From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: QoS settings not mapped correctly per pkey ?
Date: Thu, 03 Dec 2009 11:04:16 +0200
Message-ID: <4B177F10.1040908@dev.mellanox.co.il>
References: <4B0D0DB2.6080802@bull.net>	<4B0D1F36.1090007@dev.mellanox.co.il>	<4B0D38C7.3080505@bull.net>	<4B0D410E.2010903@dev.mellanox.co.il>	<4B0D49F0.6060400@bull.net>	<4B0D5110.70606@dev.mellanox.co.il>	<4B0E34EB.6020403@bull.net>	<4B0E3B63.40705@dev.mellanox.co.il>	<4B0E4105.5080107@bull.net>	<4B0E50D6.8020401@dev.mellanox.co.il>	<4B177058.9070909@dev.mellanox.co.il> <20091203091758.1975bf32@frecb007965>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091203091758.1975bf32@frecb007965>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Cc: Vincent Ficet <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, BOURDE CELINE <Celine.Bourde-6ktuUTfB/bM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

sebastien dugue wrote:
>   Hi Yevgeny,
>=20
> On Thu, 03 Dec 2009 10:01:28 +0200
> Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>=20
>> Sebastien,
>>
>> I noticed that you found the problem in IPoIB child=20
>> interfaces configuration. Glad that this worked out well.=20
>>
>> My question is about the note that you left in the issue:
>>
>>  " It looks like in 'datagram' mode, the SL weights
>>    do not seem to be applied, or maybe this is an
>>    artifact of IPoIB in 'datagram mode' "
>>
>> Have you checked that in this mode you do get the right
>> SL for each child interface by shutting off the relevant
>> SL (mapping it to VL15)?
>=20
>   Yes, SL to VL mapping is OK.
>=20
>> If yes, then what you're saying is that you see that
>> interfaces use the right SL and VL, but you don't see
>> any arbitration between VLs?
>=20
>   Right, whatever the weights I put in the vlarbs tables have absolut=
ely
> no effect when IPoIB is in datagram mode. I don't know if it's
> an arbitration problem (don't think so) or an IPoIB problem.
>=20
>   Could be that due to the 2044 bytes MTU in datagram mode, iperf
> spends much time not doing transfers and fails to provide enough
> data to the interfaces. Don't know.
>=20
>   Once I switched to connected mode, with a 65520 bytes MTU, things
> started to work OK with a much better overall combined bandwidth.

OK, then "a much better overall combined bandwidth" is an
answer here. VL arbitration kicks in only when you saturate
the link. If you don't, there's no point doing arbitration,
because HW is able so serve any packet that comes w/o the
need to prioritize.

-- Yevgeny
=20
>   Thanks,
>=20
>   S=C3=A9bastien.
>=20
>> -- Yevgeny
>>
>> Yevgeny Kliteynik wrote:
>>> Vincent Ficet wrote:
>>>> Yevgeny Kliteynik wrote:
>>>>> Vincent Ficet wrote:
>>>>>> Hello Yevgeny,
>>>>>>
>>>>>>>>> OK, so there are three possible reasons that I can think of:
>>>>>>>>> 1. Something is wrong in the configuration.
>>>>>>>>> 2. The application does not saturate the link, thus QoS
>>>>>>>>>   and the whole VL arbitration thing doesn't kick in.
>>>>>>>>> 3. There's some bug, somewhere.
>>>>>>>>>
>>>>>>>>> Let's start with reason no. 1.
>>>>>>>>> Please shut off each of the SLs one by one, and
>>>>>>>>> make sure that the application gets zero BW on
>>>>>>>>> these SLs. You can do it by mapping SL to VL15:
>>>>>>>>>
>>>>>>>>> qos_sl2vl      0,15,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>>>>>>>> If I shut down this SL by moving it to VL15, the interfaces st=
op
>>>>>>>> pinging.
>>>>>>>> This is probably because some IPoIB multicast traffic gets cut=
 off=20
>>>>>>>> for
>>>>>>>> pkey 0x7fff .. ?
>>>>>>> Could be, or because ALL interfaces are mapped to
>>>>>>> SL1, which is what the results below suggest.
>>>>>> Yes, you are right (see below).
>>>>>>>> So no results for this one.
>>>>>>>>> and then
>>>>>>>>> qos_sl2vl      0,1,15,3,4,5,6,7,8,9,10,11,12,13,14,15
>>>>>>>>>
>>>>>>>> With this setup, and the following QoS settings:
>>>>>>>>
>>>>>>>> qos_max_vls    8
>>>>>>>> qos_high_limit 1
>>>>>>>> qos_vlarb_high 0:0,1:0,2:0,3:0,4:0,5:0
>>>>>>>> qos_vlarb_low  0:1,1:64,2:128,3:192,4:0,5:0
>>>>>>>> qos_sl2vl      0,1,15,3,4,5,6,7,8,9,10,11,12,13,14,15
>>>>>>>>
>>>>>>>> I get roughly the same values for SL 1 to SL3:
>>>>>>> That doesn't look right.
>>>>>>> You have shut off SL2, so you can't see same
>>>>>>> BW for this SL. Looks like there is a problem
>>>>>>> in configuration (or bug in SM).
>>>>>> Yes, that's correct: There could be a configuration issue or a b=
ug in
>>>>>> SM:
>>>>>>
>>>>>> Current setup and results:
>>>>>>
>>>>>> qos_max_vls    8
>>>>>> qos_high_limit 1
>>>>>> qos_vlarb_high 0:0,1:0,2:0,3:0,4:0,5:0
>>>>>> qos_vlarb_low  0:1,1:64,2:128,3:192,4:0,5:0
>>>>>> qos_sl2vl      0,1,15,3,4,5,6,7,8,9,10,11,12,13,14,15
>>>>>>
>>>>>> [root@pichu22 ~]# while test -e keep_going; do iperf -c pichu16-=
ic0 -t
>>>>>> 10 -P 8 2>&1; done | grep SUM
>>>>>> [SUM]  0.0-10.1 sec  9.78 GBytes  8.28 Gbits/sec
>>>>>> [SUM]  0.0-10.0 sec  5.69 GBytes  4.89 Gbits/sec
>>>>>> [SUM]  0.0-10.0 sec  4.30 GBytes  3.69 Gbits/sec
>>>>>> [root@pichu22 ~]# while test -e keep_going; do iperf -c=20
>>>>>> pichu16-backbone
>>>>>> -t 10 -P 8 2>&1; done | grep SUM
>>>>>> [SUM]  0.0-10.2 sec  6.44 GBytes  5.45 Gbits/sec
>>>>>> [SUM]  0.0-10.1 sec  6.64 GBytes  5.66 Gbits/sec
>>>>>> [SUM]  0.0-10.0 sec  6.03 GBytes  5.15 Gbits/sec
>>>>>> [root@pichu22 ~]# while test -e keep_going; do iperf -c=20
>>>>>> pichu16-admin -t
>>>>>> 10 -P 8 2>&1; done | grep SUM
>>>>>> [SUM]  0.0-10.0 sec  5.80 GBytes  4.98 Gbits/sec
>>>>>> [SUM]  0.0-10.0 sec  7.04 GBytes  6.02 Gbits/sec
>>>>>> [SUM]  0.0-10.0 sec  6.60 GBytes  5.67 Gbits/sec
>>>>>>
>>>>>> The -backbone bandwidth should be 0 here.
>>>>>>
>>>>>>> Have you validated somehow that the interfaces
>>>>>>> have been mapped to the right SLs?
>>>>>> Two things:
>>>>>> 1/ Either the interface have not been mapped properly to the rig=
ht=20
>>>>>> SL's,
>>>>>> but given the config files below, I doubt it:
>>>>>>
>>>>>> [root@pichu22 ~]# tail -n 5 /etc/sysconfig/network-scripts/ifcfg=
-ib0*
>>>>>> =3D=3D> /etc/sysconfig/network-scripts/ifcfg-ib0 <=3D=3D
>>>>>> BOOTPROTO=3Dstatic
>>>>>> IPADDR=3D10.12.1.10
>>>>>> NETMASK=3D255.255.0.0
>>>>>> ONBOOT=3Dyes
>>>>>> MTU=3D2000
>>>>>>
>>>>>> =3D=3D> /etc/sysconfig/network-scripts/ifcfg-ib0.8001 <=3D=3D
>>>>>> BOOTPROTO=3Dstatic
>>>>>> IPADDR=3D10.13.1.10
>>>>>> NETMASK=3D255.255.0.0
>>>>>> ONBOOT=3Dyes
>>>>>> MTU=3D2000
>>>>>>
>>>>>> =3D=3D> /etc/sysconfig/network-scripts/ifcfg-ib0.8002 <=3D=3D
>>>>>> BOOTPROTO=3Dstatic
>>>>>> IPADDR=3D10.14.1.10
>>>>>> NETMASK=3D255.255.0.0
>>>>>> ONBOOT=3Dyes
>>>>>> MTU=3D2000
>>>>>>
>>>>>> partitions.conf:
>>>>>> -----------------
>>>>>>
>>>>>> default=3D0x7fff,ipoib            : ALL=3Dfull;
>>>>>> ip_backbone=3D0x0001,ipoib        : ALL=3Dfull;
>>>>>> ip_admin=3D0x0002,ipoib            : ALL=3Dfull;
>>>>>>
>>>>>> qos-policy.conf:
>>>>>> ----------------
>>>>>> qos-ulps
>>>>>>         default            : 0 # default SL
>>>>>>     ipoib, pkey 0x7FFF    : 1 # IP with default pkey 0x7FFF
>>>>>>     ipoib, pkey 0x1        : 2 # backbone IP with pkey 0x1
>>>>>>     ipoib, pkey 0x2        : 3 # admin IP with pkey 0x2
>>>>>> end-qos-ulps
>>>>>>
>>>>>> ib0.8001 maps to pkey 1 (with MSB set to 1 due to full membershi=
p =3D>
>>>>>> 0x8001 =3D (1<<16 | 1)
>>>>>> ib0.8002 maps to pkey 2 (with MSB set to 1 due to full membershi=
p =3D>
>>>>>> 0x8002 =3D (1<<16 | 2)
>>>>>>
>>>>>> 2/ Somehow, the qos policy parsing does not map pkeys as we woul=
d
>>>>>> expect, which is what the opensm messages would suggest:
>>>>>>
>>>>>> Nov 25 13:13:05 664690 [373E910] 0x01 -> __qos_policy_validate_p=
key:=20
>>>>>> ERR
>>>>>> AC15: pkey 0x0002 in match rule - overriding partition SL (0) wi=
th QoS
>>>>>> Level SL (3)
>>>>>> Nov 25 13:13:05 664681 [373E910] 0x01 -> __qos_policy_validate_p=
key:=20
>>>>>> ERR
>>>>>> AC15: pkey 0x0001 in match rule - overriding partition SL (0) wi=
th QoS
>>>>>> Level SL (2)
>>>>>> Nov 25 13:13:05 664670 [373E910] 0x01 -> __qos_policy_validate_p=
key:=20
>>>>>> ERR
>>>>>> AC15: pkey 0x7FFF in match rule - overriding partition SL (0) wi=
th QoS
>>>>>> Level SL (1)
>>>>>>
>>>>>> If the messages are correct and do reflect what opensm is actual=
ly
>>>>>> doing, this would explain why shutting down SL1 (by moving it to=
 VL15)
>>>>>> prevented all interfaces from running.
>>>>> What SM are you using?
>>>> OpenSM 3.3.2
>>>>> Does it have the following bug fix:
>>>>>
>>>>> http://www.openfabrics.org/git/?p=3D~sashak/management.git;a=3Dco=
mmit;h=3Def4c8ac3fdd50bb0b7af06887abdb5b73b7ed8c3=20
>>>>>
>>>>>
>>>> Yes it does.
>>>>
>>>> The most recent git commit (sorted by date) is for this rpm is:
>>>> * Sun Aug 23 2009 Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>>>> commit 3f4954c73add5e7b598883242782607f87c482b4
>>> OK, in that case I ran out of ideas. Need to debug.
>>> We can do it here, but best would be if you open a
>>> bug at bugzilla.
>>> Please run opensm as follows:
>>>
>>>  opensm -Q -Y <qos_policy_file> -P <partition_config_file> -e -V -s=
 0 -d1 &
>>>
>>> Wait a minute or so, try your test, and attach OSM
>>> log to the issue.
>>>
>>> -- Yevgeny
>>>
>>>
>>>
>>>> Apart from the following commit (with a bogus date):
>>>> * Tue Jul 24 2035 Keshetti Mahesh <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>> commit a0c23ed2194e96816744a075d405ff34c8373fa3
>>>>
>>>> Thanks,
>>>>
>>>> Vincent
>>>>> -- Yevgeny
>>>>>
>>>>>>>> [root@pichu22 ~]# while test -e keep_going; do iperf -c=20
>>>>>>>> pichu16-ic0 -t
>>>>>>>> 10 -P 8 2>&1; done | grep SUM
>>>>>>>> [SUM]  0.0-10.0 sec  6.15 GBytes  5.28 Gbits/sec
>>>>>>>> [SUM]  0.0-10.0 sec  6.00 GBytes  5.16 Gbits/sec
>>>>>>>> [SUM]  0.0-10.1 sec  5.38 GBytes  4.59 Gbits/sec
>>>>>>>>
>>>>>>>> [root@pichu22 ~]# while test -e keep_going; do iperf -c
>>>>>>>> pichu16-backbone
>>>>>>>> -t 10 -P 8 2>&1; done | grep SUM
>>>>>>>> [SUM]  0.0-10.0 sec  6.09 GBytes  5.23 Gbits/sec
>>>>>>>> [SUM]  0.0-10.0 sec  6.41 GBytes  5.51 Gbits/sec
>>>>>>>> [SUM]  0.0-10.0 sec  4.72 GBytes  4.05 Gbits/sec
>>>>>>>>
>>>>>>>> [root@pichu22 ~]# while test -e keep_going; do iperf -c
>>>>>>>> pichu16-admin -t
>>>>>>>> 10 -P 8 2>&1; done | grep SUM
>>>>>>>> [SUM]  0.0-10.1 sec  6.96 GBytes  5.92 Gbits/sec
>>>>>>>> [SUM]  0.0-10.1 sec  5.89 GBytes  5.00 Gbits/sec
>>>>>>>> [SUM]  0.0-10.0 sec  5.35 GBytes  4.58 Gbits/sec
>>>>>>>>
>>>>>>>>> and then
>>>>>>>>> qos_sl2vl      0,1,2,15,4,5,6,7,8,9,10,11,12,13,14,15
>>>>>>>> Same results as the previous 0,1,15,3,... SL2vl mapping.
>>>>>>>>> If this part works well, then we will continue to
>>>>>>>>> reason no. 2.
>>>>>>>> In the above tests, I used -P8 to force 8 threads on the clien=
t
>>>>>>>> side for
>>>>>>>> each test.
>>>>>>>> I have one quad core CPU(Intel  E55400).
>>>>>>>> This makes 24 iperf threads on 4 cores, which __should__ be fi=
ne
>>>>>>>> (well I
>>>>>>>> suppose ...)
>>>>>>> Best would be having one qperf per CPU core,
>>>>>>> which is 4 qperf's in your case.
>>>>>>>
>>>>>>> What is your subnet setup?
>>>>>> Nothing fancy for this test: I just bounce the taffic through a =
switch;
>>>>>>
>>>>>> [root@pichu16 ~]# ibtracert 49 53
>>>>>>> From ca {0x2c9000100d00056c} portnum 1 lid 49-49 "pichu16 HCA-1=
"
>>>>>> [1] -> switch port {0x0002c9000100d0d4}[22] lid 58-58 "bullX cha=
ssis 36
>>>>>> port QDR switch"
>>>>>> [28] -> ca port {0x2c9000100d000679}[1] lid 53-53 "pichu22 HCA-1=
"
>>>>>> To ca {0x2c9000100d000678} portnum 1 lid 53-53 "pichu22 HCA-1"
>>>>>>
>>>>>> Vincent
>>>>>>
>>>>>>> -- Yevgeny
>>>>>>>
>>>>>>>
>>>>>>>> And regarding reason #3. I still get the error I got yesterday=
, which
>>>>>>>> you told me was not important because the SL's set in partitio=
ns.conf
>>>>>>>> would override what was read from qos-policy.conf in the first=
 place.
>>>>>>>>
>>>>>>>> Nov 25 13:13:05 664690 [373E910] 0x01 ->
>>>>>>>> __qos_policy_validate_pkey: ERR
>>>>>>>> AC15: pkey 0x0002 in match rule - overriding partition SL (0) =
with=20
>>>>>>>> QoS
>>>>>>>> Level SL (3)
>>>>>>>> Nov 25 13:13:05 664681 [373E910] 0x01 ->
>>>>>>>> __qos_policy_validate_pkey: ERR
>>>>>>>> AC15: pkey 0x0001 in match rule - overriding partition SL (0) =
with=20
>>>>>>>> QoS
>>>>>>>> Level SL (2)
>>>>>>>> Nov 25 13:13:05 664670 [373E910] 0x01 ->
>>>>>>>> __qos_policy_validate_pkey: ERR
>>>>>>>> AC15: pkey 0x7FFF in match rule - overriding partition SL (0) =
with=20
>>>>>>>> QoS
>>>>>>>> Level SL (1)
>>>>>>>>
>>>>>>>> Thanks for your help.
>>>>>>>>
>>>>>>>> Vincent
>>>>>>>>
>>>>>
>>>>
>>> --=20
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdm=
a" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
