From: Bob Ciotti <Bob.Ciotti-NSQ8wuThN14@public.gmane.org>
Subject: Re: watchdog timer
Date: Fri, 18 May 2012 09:49:37 -0700
Message-ID: <4FB67DA1.606@nasa.gov>
References: <4FB5E69A.7010602@nasa.gov> <4FB649A6.2060602@dev.mellanox.co.il> <4FB65E30.4070805@nasa.gov> <4FB66817.6050106@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FB66817.6050106-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 05/18/2012 08:17 AM, Hal Rosenstock wrote:
> On 5/18/2012 10:35 AM, Bob Ciotti wrote:
>> On 05/18/2012 06:07 AM, Hal Rosenstock wrote:
>>> On 5/18/2012 2:05 AM, Bob Ciotti wrote:
>>>>
>>>>
>>>> I'm seeing lots of these messages in SM log:
>>>>
>>>> May 17 22:36:04 947774 [DA234710] 0x01 ->   log_trap_info: Received
>>>> Generic Notice type:1 num:131 (Flow Control Update watchdog timer
>>>> expired) Producer:2 (Switch) from LID:444 Port 5 TID:0x0000000000000025
>>>>
>>>> the referenced port is a switch to HCA link.
>>>>
>>>> I've seen this in cases where there was bad hardware. Spec says failure
>>>> in flow control machine on other end. But lets assume hardware was good.
>>>> When could this occur?
>>>
>>> Do OperationalVLs match on both sides of the link ? Are you
>>> using/configuring QoS ?
>>>
>>
>>
>> There are two separate fabric on each port of 2 port HCA.
>> Issue is seen on both fabrics.
>
> So these are dual homed hcas onto disjoint IB subnets.

yes

>
>> Normally we use QoS on both fabrics. QoS now disabled on
>> ib0 on hca port 1:
>
> Is watchdog timeout still observed on fabric to which hca for port 1 is
> attached ?
>

yes - on both fabrics. seems to be more on the one without QoS enabled

>>
>> r327i7n0 ~ # smpquery portinfo 248 | grep VL
>> VLCap:...........................VL0-7
>> VLHighLimit:.....................4
>> VLArbHighCap:....................8
>> VLArbLowCap:.....................8
>> VLStallCount:....................0
>> OperVLs:.........................VL0-7
>> r327i7n0 ~ # smpquery -D portinfo 0 1 | grep VL
>> VLCap:...........................VL0-7
>> VLHighLimit:.....................4
>> VLArbHighCap:....................8
>> VLArbLowCap:.....................8
>> VLStallCount:....................0
>> OperVLs:.........................VL0-7
>> r327i7n0 ~ # smpquery -D portinfo 0,1 1 | grep VL
>> VLCap:...........................VL0-7
>> VLHighLimit:.....................4
>> VLArbHighCap:....................8
>> VLArbLowCap:.....................8
>> VLStallCount:....................7
>> OperVLs:.........................VL0-7
>
> It's not an OperVLs mismatch issue.
>
>> r327i7n0 ~ # ibstat
>> CA 'mlx4_0'
>>      CA type: MT4099
>>      Number of ports: 2
>>      Firmware version: 2.10.4350
>>      Hardware version: 0
>>      Node GUID: 0x0002c90300336b20
>>      System image GUID: 0x0002c90300336b23
>>      Port 1:
>>          State: Active
>>          Physical state: LinkUp
>>          Rate: 56
>>          Base lid: 248
>>          LMC: 0
>>          SM lid: 1
>>          Capability mask: 0x02514868
>>          Port GUID: 0x0002c90300336b21
>>          Link layer: InfiniBand
>>      Port 2:
>>          State: Active
>>          Physical state: LinkUp
>>          Rate: 56
>>          Base lid: 1971
>>          LMC: 0
>>          SM lid: 1685
>>          Capability mask: 0x02514868
>>          Port GUID: 0x0002c90300336b22
>>          Link layer: InfiniBand
>>
>> r327i7n0 ~ # smpquery -D nodeinfo 0,1 1
>> # Node info: DR path slid 65535; dlid 65535; 0,1
>> BaseVers:........................1
>> ClassVers:.......................1
>> NodeType:........................Switch
>> NumPorts:........................36
>> SystemGuid:......................0x080069000000a4db
>> Guid:............................0x080069000000a4d8
>> PortGuid:........................0x080069000000a4d8
>> PartCap:.........................8
>> DevId:...........................0xc738
>> Revision:........................0x000000a1
>> LocalPort:.......................1
>> VendorId:........................0x0002c9
>>
>> r327i7n0 ~ # smpquery -D nodedesc 0,1
>> Node Description:.SwitchX -  Mellanox Technologies
>
> What does vendstat -N to this switch say ? Do you know what firmware is
> running there ?

r327i7n0 ~ # vendstat -N -G 0x080069000000a4d8
hw_dev_rev:  0x0001
hw_dev_id:   0xc738
hw_uptime:   0x00038410
fw_version:  09.01.58
fw_build_id: 0x2fb8
fw_date:     04/18/2012
fw_psid:     '030_2617_00X_SX1'
fw_ini_ver:  0
sw_version:  00.00.09

bob

>
> -- Hal
>
>> r327i7n0 ~ # smpquery -D sl2vl 0,1 1
>> # SL2VL table: DR path slid 65535; dlid 65535; 0,1
>> #                 SL: | 0| 1| 2| 3| 4| 5| 6| 7| 8| 9|10|11|12|13|14|15|
>> ports: in  0, out  1: | 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0|
>> ports: in  1, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in  2, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in  3, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in  4, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in  5, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in  6, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in  7, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in  8, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in  9, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 10, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 11, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 12, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 13, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 14, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 15, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 16, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 17, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 18, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 19, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 20, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 21, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 22, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 23, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 24, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 25, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 26, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 27, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 28, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 29, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 30, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 31, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 32, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 33, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 34, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 35, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>> ports: in 36, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 0| 1| 2| 3| 4| 5| 6| 7|
>>
>> r327i7n0 ~ # smpquery -D sl2vl 0 1
>> # SL2VL table: DR path slid 65535; dlid 65535; 0
>> #                 SL: | 0| 1| 2| 3| 4| 5| 6| 7| 8| 9|10|11|12|13|14|15|
>> ports: in  0, out  0: | 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0|
>>
>> r327i7n0 ~ # smpquery -D vlarb 0,1 1
>> # VLArbitration tables: DR path slid 65535; dlid 65535; 0,1 port 1
>> LowCap 8 HighCap 8
>> # Low priority VL Arbitration Table:
>> VL    : |0x0 |0x1 |0x2 |0x3 |0x4 |0x5 |0x6 |0x7 |
>> WEIGHT: |0x1 |0x1 |0x1 |0x1 |0x1 |0x1 |0x1 |0x1 |
>> # High priority VL Arbitration Table:
>> VL    : |0x0 |0x1 |0x2 |0x3 |0x4 |0x5 |0x6 |0x7 |
>> WEIGHT: |0x1 |0x1 |0x1 |0x1 |0x1 |0x1 |0x1 |0x1 |
>>
>> r327i7n0 ~ # smpquery -D vlarb 0 1
>> # VLArbitration tables: DR path slid 65535; dlid 65535; 0 port 1 LowCap
>> 8 HighCap 8
>> # Low priority VL Arbitration Table:
>> VL    : |0x0 |0x1 |0x2 |0x3 |0x4 |0x5 |0x6 |0x7 |
>> WEIGHT: |0x20|0x20|0x20|0x20|0x20|0x20|0x20|0x20|
>> # High priority VL Arbitration Table:
>> VL    : |0x0 |0x1 |0x2 |0x3 |0x4 |0x5 |0x6 |0x7 |
>> WEIGHT: |0x0 |0x0 |0x0 |0x0 |0x0 |0x0 |0x0 |0x0 |
>>
>>
>> on ib1, HCA port 2, Qos is enabled:
>>
>> r327i7n0 ~ # smpquery -P2 -D sl2vl 0 2
>> # SL2VL table: DR path slid 65535; dlid 65535; 0
>> #                 SL: | 0| 1| 2| 3| 4| 5| 6| 7| 8| 9|10|11|12|13|14|15|
>> ports: in  0, out  0: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>>
>> r327i7n0 ~ # smpquery -P2 -D sl2vl 0,2 1
>> # SL2VL table: DR path slid 65535; dlid 65535; 0,2
>> #                 SL: | 0| 1| 2| 3| 4| 5| 6| 7| 8| 9|10|11|12|13|14|15|
>> ports: in  0, out  1: | 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0|
>> ports: in  1, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in  2, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in  3, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in  4, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in  5, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in  6, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in  7, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in  8, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in  9, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 10, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 11, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 12, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 13, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 14, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 15, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 16, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 17, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 18, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 19, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 20, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 21, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 22, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 23, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 24, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 25, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 26, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 27, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 28, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 29, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 30, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 31, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 32, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 33, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 34, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 35, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>> ports: in 36, out  1: | 0| 1| 2| 3| 4| 5| 6| 7| 3| 4| 5| 6| 7| 3| 4| 5|
>>
>> r327i7n0 ~ # smpquery -P2 -D vlarb 0,2 1
>> # VLArbitration tables: DR path slid 65535; dlid 65535; 0,2 port 1
>> LowCap 8 HighCap 8
>> # Low priority VL Arbitration Table:
>> VL    : |0x0 |0x1 |0x2 |0x3 |0x4 |0x5 |0x6 |0x7 |
>> WEIGHT: |0x0 |0x0 |0x0 |0x40|0x40|0x40|0x40|0x40|
>> # High priority VL Arbitration Table:
>> VL    : |0x0 |0x1 |0x2 |0x0 |0x0 |0x0 |0x0 |0x0 |
>> WEIGHT: |0x80|0x40|0x40|0x0 |0x0 |0x0 |0x0 |0x0 |
>>
>> r327i7n0 ~ # smpquery -P2 -D vlarb 0 2
>> # VLArbitration tables: DR path slid 65535; dlid 65535; 0 port 2 LowCap
>> 8 HighCap 8
>> # Low priority VL Arbitration Table:
>> VL    : |0x0 |0x1 |0x2 |0x3 |0x4 |0x5 |0x6 |0x7 |
>> WEIGHT: |0x0 |0x0 |0x0 |0x40|0x40|0x40|0x40|0x40|
>> # High priority VL Arbitration Table:
>> VL    : |0x0 |0x1 |0x2 |0x0 |0x0 |0x0 |0x0 |0x0 |
>> WEIGHT: |0x80|0x40|0x40|0x0 |0x0 |0x0 |0x0 |0x0 |
>>
>>>> Only in the case of FW bug?
>>>
>>> I don't think flow control is performed by FW.
>>>
>>>> Any tunable's that might impact this?
>>>
>>> No IBA standard ones AFAIK. Who's the HCA vendor ?
>>>
>>> -- Hal
>>>
>>>> bob
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
