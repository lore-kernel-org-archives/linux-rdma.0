From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: QoS settings not mapped correctly per pkey ?
Date: Wed, 25 Nov 2009 17:45:20 +0200
Message-ID: <4B0D5110.70606@dev.mellanox.co.il>
References: <4B0D0DB2.6080802@bull.net> <4B0D1F36.1090007@dev.mellanox.co.il> <4B0D38C7.3080505@bull.net> <4B0D410E.2010903@dev.mellanox.co.il> <4B0D49F0.6060400@bull.net>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B0D49F0.6060400-6ktuUTfB/bM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vincent Ficet <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, BOURDE CELINE <Celine.Bourde-6ktuUTfB/bM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Vincent Ficet wrote:
> Yevgeny,
>> OK, so there are three possible reasons that I can think of:
>> 1. Something is wrong in the configuration.
>> 2. The application does not saturate the link, thus QoS
>>   and the whole VL arbitration thing doesn't kick in.
>> 3. There's some bug, somewhere.
>>
>> Let's start with reason no. 1.
>> Please shut off each of the SLs one by one, and
>> make sure that the application gets zero BW on
>> these SLs. You can do it by mapping SL to VL15:
>>
>> qos_sl2vl      0,15,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> If I shut down this SL by moving it to VL15, the interfaces stop pinging.
> This is probably because some IPoIB multicast traffic gets cut off for
> pkey 0x7fff .. ?

Could be, or because ALL interfaces are mapped to
SL1, which is what the results below suggest.

> So no results for this one.
>> and then
>> qos_sl2vl      0,1,15,3,4,5,6,7,8,9,10,11,12,13,14,15
>>
> With this setup, and the following QoS settings:
> 
> qos_max_vls    8
> qos_high_limit 1
> qos_vlarb_high 0:0,1:0,2:0,3:0,4:0,5:0
> qos_vlarb_low  0:1,1:64,2:128,3:192,4:0,5:0
> qos_sl2vl      0,1,15,3,4,5,6,7,8,9,10,11,12,13,14,15
> 
> I get roughly the same values for SL 1 to SL3:

That doesn't look right.
You have shut off SL2, so you can't see same
BW for this SL. Looks like there is a problem
in configuration (or bug in SM).

Have you validated somehow that the interfaces
have been mapped to the right SLs?

> [root@pichu22 ~]# while test -e keep_going; do iperf -c pichu16-ic0 -t
> 10 -P 8 2>&1; done | grep SUM
> [SUM]  0.0-10.0 sec  6.15 GBytes  5.28 Gbits/sec
> [SUM]  0.0-10.0 sec  6.00 GBytes  5.16 Gbits/sec
> [SUM]  0.0-10.1 sec  5.38 GBytes  4.59 Gbits/sec
> 
> [root@pichu22 ~]# while test -e keep_going; do iperf -c pichu16-backbone
> -t 10 -P 8 2>&1; done | grep SUM
> [SUM]  0.0-10.0 sec  6.09 GBytes  5.23 Gbits/sec
> [SUM]  0.0-10.0 sec  6.41 GBytes  5.51 Gbits/sec
> [SUM]  0.0-10.0 sec  4.72 GBytes  4.05 Gbits/sec
> 
> [root@pichu22 ~]# while test -e keep_going; do iperf -c pichu16-admin -t
> 10 -P 8 2>&1; done | grep SUM
> [SUM]  0.0-10.1 sec  6.96 GBytes  5.92 Gbits/sec
> [SUM]  0.0-10.1 sec  5.89 GBytes  5.00 Gbits/sec
> [SUM]  0.0-10.0 sec  5.35 GBytes  4.58 Gbits/sec
> 
>> and then
>> qos_sl2vl      0,1,2,15,4,5,6,7,8,9,10,11,12,13,14,15
> Same results as the previous 0,1,15,3,... SL2vl mapping.
>> If this part works well, then we will continue to
>> reason no. 2.
> In the above tests, I used -P8 to force 8 threads on the client side for
> each test.
> I have one quad core CPU(Intel  E55400).
> This makes 24 iperf threads on 4 cores, which __should__ be fine (well I
> suppose ...)

Best would be having one qperf per CPU core,
which is 4 qperf's in your case.

What is your subnet setup?

-- Yevgeny


> And regarding reason #3. I still get the error I got yesterday, which
> you told me was not important because the SL's set in partitions.conf
> would override what was read from qos-policy.conf in the first place.
> 
> Nov 25 13:13:05 664690 [373E910] 0x01 -> __qos_policy_validate_pkey: ERR
> AC15: pkey 0x0002 in match rule - overriding partition SL (0) with QoS
> Level SL (3)
> Nov 25 13:13:05 664681 [373E910] 0x01 -> __qos_policy_validate_pkey: ERR
> AC15: pkey 0x0001 in match rule - overriding partition SL (0) with QoS
> Level SL (2)
> Nov 25 13:13:05 664670 [373E910] 0x01 -> __qos_policy_validate_pkey: ERR
> AC15: pkey 0x7FFF in match rule - overriding partition SL (0) with QoS
> Level SL (1)
> 
> Thanks for your help.
> 
> Vincent
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
