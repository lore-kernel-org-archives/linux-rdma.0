From: "Vu Pham" <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: MLX4 Strangeness
Date: Thu, 18 Feb 2010 16:03:35 -0800
Message-ID: <9FA59C95FFCBB34EA5E42C1A8573784F02662B3F@mtiexch01.mti.com>
References: <4B79AD88.8000101@opengridcomputing.com><4B7A4EF4.9090209@mellanox.co.il><4B7B0E98.9030506@opengridcomputing.com><4B7B35DD.1030609@opengridcomputing.com>
	<4B7C3026.9070500@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-class: urn:content-classes:message
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Tom,

Status 12 = IB_WC_RETRY_EXC_ERR
Vendor_err = 129 --> Timeout and transport error counter exceeded

This indicates that we lost connection to the client ie. something went
wrong on client side (bad operation cause QP error...) please try to
catch any error on the client (qp async event, cq error status and
vendor_err...)

Today I just run vdbench on big file and get error right away (lost
connection and nfsrdma cannot recover from there)

Thanks,
-vu

-----Original Message-----
From: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
[mailto:ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org] On Behalf Of Tom Tucker
Sent: Wednesday, February 17, 2010 10:07 AM
To: Tziporet Koren
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Subject: Re: [ewg] MLX4 Strangeness

Hi Tziporet:

Here is a trace with the data for WR failing with status 12. The vendor 
error is 129.

Feb 17 12:27:33 vic10 kernel: rpcrdma_event_process:154 wr_id 
0000000000000000 status 12 opcode 0 vendor_err 129 byte_len 0 qp 
ffff81002a13ec00 ex 00000000 src_qp 00000000 wc_flags, 0 pkey_index
Feb 17 12:27:33 vic10 kernel: rpcrdma_event_process:154 wr_id 
ffff81002878d800 status 5 opcode 0 vendor_err 244 byte_len 0 qp 
ffff81002a13ec00 ex 00000000 src_qp 00000000 wc_flags, 0 pkey_index
Feb 17 12:27:33 vic10 kernel: rpcrdma_event_process:167 wr_id 
ffff81002878d800 status 5 opcode 0 vendor_err 244 byte_len 0 qp 
ffff81002a13ec00 ex 00000000 src_qp 00000000 wc_flags, 0 pkey_index

Any thoughts?
Tom

Tom Tucker wrote:
> Tom Tucker wrote:
>> Tziporet Koren wrote:
>>> On 2/15/2010 10:24 PM, Tom Tucker wrote:
>>>  
>>>> Hello,
>>>>
>>>> I am seeing some very strange behavior on my MLX4 adapters running
2.7
>>>> firmware and the latest OFED 1.5.1. Two systems are involved and
each
>>>> have dual ported MTHCA DDR adapter and MLX4 adapters.
>>>>
>>>> The scenario starts with NFSRDMA stress testing between the two 
>>>> systems
>>>> running bonnie++ and iozone concurrently. The test completes and
there
>>>> is no issue. Then 6 minutes pass and the server "times out" the
>>>> connection and shuts down the RC connection to the client.
>>>>
>>>>   From this point on, using the RDMA CM, a new RC QP can be brought
up
>>>> and moved to RTS, however, the first RDMA_SEND to the NFS SERVER 
>>>> system
>>>> fails with IB_WC_RETRY_EXC_ERR. I have confirmed:
>>>>
>>>> - that "arp" completed successfully and the neighbor entries are
>>>> populated on both the client and server
>>>> - that the QP are in the RTS state on both the client and server
>>>> - that there are RECV WR posted to the RQ on the server and they 
>>>> did not
>>>> error out
>>>> - that no RECV WR completed successfully or in error on the server
>>>> - that there are SEND WR posted to the QP on the client
>>>> - the client side SEND_WR fails with error 12 as mentioned above
>>>>
>>>> I have also confirmed the following with a different application
(i.e.
>>>> rping):
>>>>
>>>> server# rping -s
>>>> client# rping -c -a 192.168.80.129
>>>>
>>>> fails with the exact same error, i.e.
>>>> client# rping -c -a 192.168.80.129
>>>> cq completion failed status 12
>>>> wait for RDMA_WRITE_ADV state 10
>>>> client DISCONNECT EVENT...
>>>>
>>>> However, if I run rping the other way, it works fine, that is,
>>>>
>>>> client# rping -s
>>>> server# rping -c -a 192.168.80.135
>>>>
>>>> It runs without error until I stop it.
>>>>
>>>> Does anyone have any ideas on how I might debug this?
>>>>
>>>>
>>>>        
>>> Tom
>>> What is the vendor syndrome error when you get a completion with
error?
>>>
>>>   
>> Feb 16 15:08:29 vic10 kernel: rpcrdma: connection to 
>> 192.168.80.129:20049 closed (-103)
>> Feb 16 15:51:27 vic10 kernel: rpcrdma: connection to 
>> 192.168.80.129:20049 on mlx4_0, memreg 5 slots 32 ird 16
>> Feb 16 15:52:01 vic10 kernel: rpcrdma_event_process:160 wr_id 
>> ffff81002879a000 status 5 opcode 0 vendor_err 244 byte_len 0 qp 
>> ffff81003c9e3200 ex 00000000 src_qp 00000000 wc_flags, 0 pkey_index
>> Feb 16 15:52:06 vic10 kernel: rpcrdma: connection to 
>> 192.168.80.129:20049 closed (-103)
>> Feb 16 15:52:06 vic10 kernel: rpcrdma: connection to 
>> 192.168.80.129:20049 on mlx4_0, memreg 5 slots 32 ird 16
>> Feb 16 15:52:40 vic10 kernel: rpcrdma_event_process:160 wr_id 
>> ffff81002879a000 status 5 opcode 0 vendor_err 244 byte_len 0 qp 
>> ffff81002f2d8400 ex 00000000 src_qp 00000000 wc_flags, 0 pkey_index
>>
>> Repeat forever....
>>
>> So the vendor err is 244.
>>
>
> Please ignore this. This log skips the failing WR (:-\). I need to do 
> another trace.
>
>
>
>>> Does the issue occurs only on the ConnectX cards (mlx4) or also on 
>>> the InfiniHost cards (mthca)
>>>
>>> Tziporet
>>>
>>> _______________________________________________
>>> ewg mailing list
>>> ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>>> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
>>>   
>>
>>
>
>

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
