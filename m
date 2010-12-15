From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: ibnetdiscover issue
Date: Wed, 15 Dec 2010 14:58:58 +0200
Message-ID: <4D08BB92.7010802@gmail.com>
References: <4CFFC4F3.3040805@utah.edu> <4CFFCE3A.6010901@dev.mellanox.co.il> <4D001173.9030001@utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D001173.9030001-wbocuHtxKic@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "elid-smomgflXvOZWk0Htik3J/w@public.gmane.org" <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "dorfman.eii-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <dorfman.eii-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tom Ammon wrote:
> Eli,
> 
> Is there a quick workaround we could put in place? I want to map out our
> fabric, and I especially need the spine GUIDs on the GD4200 because I'm
> going to be doing up/down routing and want to specify the root GUIDs. I
> can also submit a support case to Voltaire, if you think that would make
> it go faster. I want to make sure we are using OFED as distributed from
> OFA.

Hi Tom,

You should take the following patches:

commit 5b034c90d72f9fbf382df414a1569e0a9f7ac679
Author: Eli Dorfman (Voltaire) <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date:   Sun Sep 5 11:30:37 2010 +0300

    inifiband-diags: Support Voltaire switch ISR4200

    Support Voltaire switch (ISR4200) grouping.

    Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>

commit e6a10b921627099f42bc4aea7ae68abcf4c1c970
Author: Eli Dorfman (Voltaire) <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date:   Sun Sep 5 11:28:57 2010 +0300

    infiniband-diags: Do not exit when unexpected node found

    Show error message but do not exit when unexpected node is found.

    Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>

Eli

> 
> Tom
> 
> On 12/8/2010 11:28 AM, Hal Rosenstock wrote:
>> Hi Tom,
>>
>> On 12/8/2010 12:48 PM, Tom Ammon wrote:
>>> Hi,
>>>
>>> I get the following when I try to run ibnetdiscover from a server
>>> plugged in to a voltaire 4036 switch. We're using OFED 1.5.2:
>>>
>>> [root@sm1 ~]# ibnetdiscover
>>> src/chassis.c:535; Unexpected node found: guid 0x0008f1050075134c
>>> ibnetdiscover: iberror: failed: discover failed
>>
>> Looks to me like there's a missing is_spine_4200() clause missing in
>> get_router_slot in libibnetdisc/src/chassis.c. Eli had added changes to
>> support the 4200 so he's the best one to comment.
>>
>> -- Hal
>>
>>>
>>> However, ibdiagnet runs fine:
>>>
>>> [root@sm1 ~]# ibdiagnet
>>> Loading IBDIAGNET from: /usr/lib64/ibdiagnet1.5.4
>>> -W- Topology file is not specified.
>>> Reports regarding cluster links will use direct routes.
>>> Loading IBDM from: /usr/lib64/ibdm1.5.4
>>> -I- Using port 1 as the local port.
>>> -I- Discovering ... 277 nodes (23 Switches&  254 CA-s) discovered.
>>>
>>>
>>> -I---------------------------------------------------
>>> -I- Bad Guids/LIDs Info
>>> -I---------------------------------------------------
>>> -I- No bad Guids were found
>>>
>>> -I---------------------------------------------------
>>> -I- Links With Logical State = INIT
>>> -I---------------------------------------------------
>>> -I- No bad Links (with logical state = INIT) were found
>>>
>>> -I---------------------------------------------------
>>> -I- General Device Info
>>> -I---------------------------------------------------
>>>
>>> -I---------------------------------------------------
>>> -I- PM Counters Info
>>> -I---------------------------------------------------
>>> -W- lid=0x0007 guid=0x0008f105006515ba dev=23131 Port=33
>>> Performance Monitor counter : Value
>>> link_error_recovery_counter : 0xff (overflow)
>>> -W- lid=0x0010 guid=0x0008f10500201d7c dev=23130 Port=14
>>> Performance Monitor counter : Value
>>> symbol_error_counter : 0xffff (overflow)
>>> -W- lid=0x0001 guid=0x0008f10500108a76 dev=23130 Port=30
>>> Performance Monitor counter : Value
>>> symbol_error_counter : 0xffff (overflow)
>>>
>>> -I---------------------------------------------------
>>> -I- Fabric Partitions Report (see ibdiagnet.pkey for a full hosts list)
>>> -I---------------------------------------------------
>>> -I- PKey:0x7fff Hosts:254 full:254 limited:0
>>>
>>> -I---------------------------------------------------
>>> -I- IPoIB Subnets Check
>>> -I---------------------------------------------------
>>> -I- Subnet: IPv4 PKey:0x7fff QKey:0x00000b1b MTU:2048Byte rate:10Gbps
>>> SL:0x00
>>>
>>> -I---------------------------------------------------
>>> -I- Bad Links Info
>>> -I- No bad link were found
>>> -I---------------------------------------------------
>>> ----------------------------------------------------------------
>>> -I- Stages Status Report:
>>> STAGE Errors Warnings
>>> Bad GUIDs/LIDs Check 0 0
>>> Link State Active Check 0 0
>>> General Devices Info Report 0 0
>>> Performance Counters Report 0 3
>>> Partitions Check 0 0
>>> IPoIB Subnets Check 0 0
>>>
>>> Please see /tmp/ibdiagnet.log for complete log
>>> ----------------------------------------------------------------
>>>
>>> -I- Done. Run time was 21 seconds.
>>>
>>> Any ideas?
>>>
>>> Tom
>>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
