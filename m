From: Michael Robbert <mrobbert-/qOHPfZA4H6HXe+LvDLADg@public.gmane.org>
Subject: Re: ibstat stuck in state initialized after reboot
Date: Wed, 24 Mar 2010 12:26:08 -0600
Message-ID: <7AF35A54-F939-47AE-A5F0-1579C0933254@mines.edu>
References: <E25E098F-AFCA-4FEA-BE46-5AF59C408293@mines.edu>
 <20100324093805.4c7c1034.weiny2@llnl.gov>
 <4256D4F9-36CC-4C21-A459-B69B363F29C9@mines.edu>
 <6203933669E90E4AB42B5BC4EDE38D350C9B6386B6@orsmsx510.amr.corp.intel.com>
 <230744DB-D7A7-4A1C-973E-E0D7097554DE@mines.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <230744DB-D7A7-4A1C-973E-E0D7097554DE-/qOHPfZA4H6HXe+LvDLADg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Robbert <mrobbert-/qOHPfZA4H6HXe+LvDLADg@public.gmane.org>
Cc: "Meyer, Donald J" <donald.j.meyer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I just discovered another interesting point. I tried to start opensm on one of my hosts and it went into STANDBY state. Here is the log of it trying to start up:

Mar 24 12:23:25 117170 [66DAC170] 0x80 -> OpenSM 3.3.5
Entering DISCOVERING state

Mar 24 12:23:25 117863 [66DAC170] 0x02 -> osm_vendor_init: 1000 pending umads specified
Mar 24 12:23:25 118022 [66DAC170] 0x80 -> Entering DISCOVERING state
Mar 24 12:23:25 120961 [66DAC170] 0x02 -> osm_vendor_bind: Binding to port 0x5ad00000bf1e1
Mar 24 12:23:25 129023 [66DAC170] 0x02 -> osm_vendor_bind: Binding to port 0x5ad00000bf1e1
Mar 24 12:23:25 129069 [66DAC170] 0x02 -> osm_opensm_bind: Setting IS_SM on port 0x0005ad00000bf1e1
Mar 24 12:23:26 120384 [42E1E940] 0x01 -> umad_receiver: ERR 5411: DR SMP Send completed with error -- dropping
                        Method 0x1, Attr 0x11, TID 0xf00001a51, Hop Ptr: 0x0
Mar 24 12:23:26 120444 [42E1E940] 0x01 -> Received SMP on a 4 hop path: Initial path = 0,0,0,0,0, Return path  = 0,0,0,0,0
Mar 24 12:23:26 120461 [42E1E940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR 3113: MAD completed in error (IB_TIMEOUT): SubnGet(NodeInfo), attr_mod 0x0, TID 0x1a51
Using default GUID 0x5ad00000bf1e1
Entering STANDBY state

Mar 24 12:23:26 120538 [42C1D940] 0x80 -> Entering STANDBY state

Does that change the diagnosis at all? I'm still waiting for a response from tac-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org

Thanks,
Mike

On Mar 24, 2010, at 11:34 AM, Michael Robbert wrote:

> Interesting note! The 7024 is our large switch where all the hosts are connected, but I was told that we were sold the 7000D because the 7024 didn't have a subnet manager. Unfortunately the 7000D has a different CLI and that command is not available and I don't have the password for our 7024 so I can't log onto it. 
> On another note I just noticed the uptime on the 7000D is just over 1 day so that must have been the start of the problem, but I have no idea why it rebooted nor why it didn't come up working. I'm pretty sure we tested a reboot of the device during acceptance testing.
> 
> Oh, I just got your second note:
> ==================================
> BTW, I highly recommend running the opensm on a server instead of using the sm on the switch.  We found running the sm on the switch was much less reliable.  I also recommend using a server dedicated to opensm only.
> ==================================
> 
> I will take that into consideration, but we bought this as a "turn-key" solution from Dell. They designed it and we had no experience with IB so we trusted their knowledge. 
> 
> Thanks,
> Mike
> 
> 
> On Mar 24, 2010, at 11:12 AM, Meyer, Donald J wrote:
> 
>> http://www.cisco.com/en/US/docs/server_nw_virtual/7024/release_4.1/hardware/installation/guide/7024hig.pdf
>> 
>> smControl
>> Starts and stops the embedded subnet manager.
>> Syntax:
>> smControl start | stop | restart | status
>> 
>> Thanks,
>> Don Meyer
>> Senior Network/System Engineer/Programmer
>> US+ (253) 371-9532 iNet 8-371-9532
>> *Other names and brands may be claimed as the property of others
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Michael Robbert
>> Sent: Wednesday, March 24, 2010 10:00 AM
>> To: Ira Weiny
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Re: ibstat stuck in state initialized after reboot
>> 
>> Ira,
>> Thanks for the quick response. That is what I was afraid of. I've been looking through the switch documentation, but it doesn't cover starting, stopping, or even checking the status of the SM service. I'll look into opening a TAC case, but since Cisco has gotten out of the IB business I'm not looking forward to seeing what kind of product support they still have. I can tell you a little more about our topology since it is pretty simple. All of our hosts are connected to the single large SFS switch, then the 7000D which is our subnet-manager is only plugged into that larger switch. 
>> 
>> Thanks for the help and wish me luck with support!
>> 
>> Mike
>> 
>> On Mar 24, 2010, at 10:38 AM, Ira Weiny wrote:
>> 
>>> On Wed, 24 Mar 2010 10:26:02 -0600
>>> Michael Robbert <mrobbert-/qOHPfZA4H6HXe+LvDLADg@public.gmane.org> wrote:
>>> 
>>>> I hope this is the correct place to get help with the problem I have. I have
>>>> an IB fabric running on a Cisco SFS switch with a 7000D as the subnet
>>>> manager and the whole thing has been running great for well over a year now,
>>>> but today I noticed that after any node gets rebooted its IB link doesn't
>>>> initialize. This has happened on 4 hosts now. What I see is as follows:
>>>> 
>>>> [root@compute-2-7 ~]# ibstat
>>>> CA 'mthca0'
>>>>     CA type: MT25204
>>>>     Number of ports: 1
>>>>     Firmware version: 1.2.917
>>>>     Hardware version: 20
>>>>     Node GUID: 0x0005ad00000c0990
>>>>     System image GUID: 0x0005ad000100d050
>>>>     Port 1:
>>>>             State: Initializing
>>>>             Physical state: LinkUp
>>>>             Rate: 20
>>>>             Base lid: 0
>>>>             LMC: 0
>>>>             SM lid: 0
>>>>             Capability mask: 0x02510a68
>>>>             Port GUID: 0x0005ad00000c0991
>>>> 
>>>> I don't know much about subnet managers, since ours is in hardware and we've
>>>> never had to configure anything on it, but I can login to the device and it
>>>> isn't showing any errors. On a node that hasn't been rebooted recently and
>>>> is still working I can see what appears to be a working subnet manager:
>>>> 
>>>> [root@compute-2-10 ~]# sminfo 
>>>> sminfo: sm lid 2 sm guid 0x5ad00001df2a0, activity count 2146213408 priority 10 state 3 SMINFO_MASTER
>>>> 
>>>> The same command on a non-working node shows this:
>>>> 
>>>> [root@compute-2-7 ~]# sminfo 
>>>> sminfo: sm lid 0 sm guid 0x0, activity count 0 priority 0 state 2 SMINFO_STANDBY
>>>> 
>>>> So far I have reseated all the cables involved on both ends and I have moved
>>>> the cables on the switch end to new ports and none of that has made a
>>>> difference even after reboots. I am hoping to find a node that I can take
>>>> offline tomorrow so I can actually test the cables, but since this seems to
>>>> be happening to any host that reboots it doesn't appear to be a cabling
>>>> problem. Can anybody suggest where I should go from here? Is there anything
>>>> I can do from a working or non-working host to diagnose the problem? Should
>>>> I try rebooting the subnet manager switch? Will that affect the rest of the
>>>> fabric? 
>>> 
>>> Have you spoken to Cisco about the problem?  You say you can log into the
>>> "device" (the SM switch?) if so talk to Cisco about how you may be able to
>>> restart the SM there.
>>> 
>>> It does sound like the SM on the switch is failing to transition the links.
>>> If you can restart the SM on the switch I would try that first.  Otherwise yes
>>> rebooting the switch is probably your best bet, and yes it will affect the
>>> fabric, although I can't say how much without knowing the topology.
>>> 
>>> Ira
>>> 
>>>> 
>>>> Thanks,
>>>> Mike Robbert
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://*vger.kernel.org/majordomo-info.html
>>>> 
>>> 
>>> 
>>> -- 
>>> Ira Weiny
>>> Math Programmer/Computer Scientist
>>> Lawrence Livermore National Lab
>>> 925-423-8008
>>> weiny2-i2BcT+NCU+M@public.gmane.org
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
