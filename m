From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Problems with link, opensm complains IB_SA_MAD_STATUS_REQ_INVALID
Date: Fri, 16 Dec 2011 08:10:58 -0500
Message-ID: <4EEB4362.1050505@dev.mellanox.co.il>
References: <4EEA8004.4060103@grepit.nl> <20111215160600.ebccb033.weiny2@llnl.gov> <4EEB07C3.90803@grepit.nl> <20111216091416.GA3448@calypso> <4EEB216D.2010407@grepit.nl> <4EEB39E8.5030601@dev.mellanox.co.il> <4EEB3FD3.3080409@grepit.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EEB3FD3.3080409-99SnrGqf+M9mR6Xm/wNWPw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gerben Roest <g.roest-99SnrGqf+M9mR6Xm/wNWPw@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Gerben,

On 12/16/2011 7:55 AM, Gerben Roest wrote:
> Hi Alex, Hal,
> 
> On 16-12-2011 13:30, Hal Rosenstock wrote:
>> On 12/16/2011 5:46 AM, Gerben Roest wrote:
>>> On 16-12-2011 10:14, Alex Netes wrote:
>>>> Hi Gerben,
>>>>
>>>> It's complaining about the link rate:
>>>>
>>>> Dec 15 23:35:05 792236 [46B9F940] 0x04 -> validate_port_caps: Port's RATE 2 is less than 3
>>>>
>>>> Probably, the host that is trying to join is connected via 1x cable.
>>>> The rate is defined by the capabilities of the host that opened a group, so
>>>> you see this problem only when the host with higher rate created the MC group.
>>>
>>> Is it possible to force them to some specified speed?
>>
>> The easiest way to fix this is to specify rate=2 in the partition file
>> for the default partition as documented in the man page under PARTITION
>> CONFIGURATION SECTION as follows:
>>
>> Default=0x7fff,ipoib,rate=2:ALL=full;
> 
> This does the trick! Thanks!
> 
>>
>>> The strange thing is that both hosts show this problem if they start
>>> opensm, 
>>
>> What OpenSM version is this ?
> 
> opensm-3.3.9-1.x86_64
> 
> But opensm from OFED-1.5.4 gave the same error.
> 
>>
>>> they have the same errors in /var/log/opensm.log. This is what
>>> both hosts have:
>>>
>>> [root@titus ~]# lspci -v |grep Infini
>>> 0a:00.0 InfiniBand: Mellanox Technologies MT26418 [ConnectX VPI PCIe 2.0
>>> 5GT/s - IB DDR / 10GigE] (rev a0)
>>>
>>> [root@vespasianus ~]# lspci -v |grep Infini
>>> 0a:00.0 InfiniBand: Mellanox Technologies MT26418 [ConnectX VPI PCIe 2.0
>>> 5GT/s - IB DDR / 10GigE] (rev a0)
>>
>> What (rate) is shown in ibstat or ibstatus for each port ?
> 
> Both machines have one port each. Both machines give Rate=2, before and
> after the opensm partitions.conf edit.
> 
>>
>>> The hosts are connected to each other's single port via one IB cable.
>>
>> I hope they have the same rate on both ports then.
> 
> yes, they had, and have. They should be identical on-board "cards".
> 
> Could this be a cable problem? 

Yes; do you have another cable to try ? If that increases the active
port rate to the full port rate (4x DDR) then you should be able to
either remove the partition config you just added (and use rate=3) or
make the group rate=6 (see below).

> They should be DDR cards. Does Rate=2 mean DDR?

No; it means 1x SDR (lowest speed/width). 4x DDR would be rate 6 (20
Gbps). See IBA 1.2.1 vol 1 PathRecord SA attribute Rate component.

By default, OpenSM sets the rate for the IPoIB broadcast groups when not
explicitly specified is rate 3 (10 Gbps) which is 4x SDR.

-- Hal

> 
> thanks,
> 
> Gerben
> 
>>> [root@vespasianus ~]# grep -A1 -B1 INVALID /var/log/opensm.log| tail
>>>
>>> Dec 16 11:35:10 041359 [483D2940] 0x01 -> mcmr_rcv_join_mgrp: ERR 1B12:
>>> validate_more_comp_fields, validate_port_caps, or JoinState = 0 failed
>>> from port 0x001e8c0000c84b62 (titus HCA-1), sending
>>> IB_SA_MAD_STATUS_REQ_INVALID
>>> Dec 16 11:35:10 041365 [483D2940] 0x10 -> osm_sa_send_error: [
>>> --
>>> Dec 16 11:35:17 351591 [429C9940] 0x04 -> validate_port_caps: Port's
>>> RATE 2 is less than 3
>>> Dec 16 11:35:17 351598 [429C9940] 0x01 -> mcmr_rcv_join_mgrp: ERR 1B12:
>>> validate_more_comp_fields, validate_port_caps, or JoinState = 0 failed
>>> from port 0x001e8c0000b90641 (vespasianus HCA-1), sending
>>> IB_SA_MAD_STATUS_REQ_INVALID
>>> Dec 16 11:35:17 351604 [429C9940] 0x10 -> osm_sa_send_error: [
>>> --
>>> Dec 16 11:35:18 042907 [43DCB940] 0x04 -> validate_port_caps: Port's
>>> RATE 2 is less than 3
>>> Dec 16 11:35:18 042914 [43DCB940] 0x01 -> mcmr_rcv_join_mgrp: ERR 1B12:
>>> validate_more_comp_fields, validate_port_caps, or JoinState = 0 failed
>>> from port 0x001e8c0000c84b62 (titus HCA-1), sending
>>> IB_SA_MAD_STATUS_REQ_INVALID
>>> Dec 16 11:35:18 042920 [43DCB940] 0x10 -> osm_sa_send_error: [
>>>
>>> Gerben
>>>
>>>
>>>>
>>>> On 09:56 Fri 16 Dec     , Gerben Roest wrote:
>>>>> On 16-12-2011 1:06, Ira Weiny wrote:
>>>>>> On Thu, 15 Dec 2011 15:17:24 -0800
>>>>>> Gerben Roest <g.roest-99SnrGqf+M9mR6Xm/wNWPw@public.gmane.org> wrote:
>>>>>>
>>>>>>> Hi,
>>>>>>>
>>>>>>> Starting opensm from OFED 1.5.1, 1.5.3.2, 1.5.4 on a Scientific Linux 5
>>>>>>> machine, directly linked to its neighbour (a twin 1U setup) gives me no
>>>>>>> connection but lots of errors in /var/log/opensm.log, like these:
>>>>>>>
>>>>>>> Dec 15 22:38:35 685651 [45AFD940] 0x01 -> mcmr_rcv_join_mgrp: ERR 1B12:
>>>>>>> validate_more_comp_fields, validate_port_caps, or JoinState = 0 failed
>>>>>>> from port 0x001e8c0000b90641 (vespasianus HCA-1), sending
>>>>>>> IB_SA_MAD_STATUS_REQ_INVALID
>>>>>>> Dec 15 22:38:35 686174 [464FE940] 0x01 -> mcmr_rcv_join_mgrp: ERR 1B12:
>>>>>>> validate_more_comp_fields, validate_port_caps, or JoinState = 0 failed
>>>>>>> from port 0x001e8c0000c84b62 (titus HCA-1), sending
>>>>>>> IB_SA_MAD_STATUS_REQ_INVALID
>>>>>>>
>>>>>>> Does anyone know what happens here? Another twin node has no problems,
>>>>>>> that one uses OFED-1.5.1.
>>>>>>>
>>>>>>> I can send a "-V" log of opensm or any config files if you like,
>>>>>>
>>>>>> Just set -D 0x7 which adds VERBOSE and send the snippet around the above errors.
>>>>>
>>>>> Dec 15 23:35:05 791001 [4399A940] 0x10 -> osm_vendor_send: [
>>>>> Dec 15 23:35:05 791008 [4399A940] 0x04 -> osm_vendor_send: RMPP 0 length 256
>>>>> Dec 15 23:35:05 791021 [4399A940] 0x10 -> osm_vendor_put: [
>>>>> Dec 15 23:35:05 791028 [4399A940] 0x08 -> osm_vendor_put: Retiring UMAD
>>>>> 0x3dd9290
>>>>> Dec 15 23:35:05 791034 [4399A940] 0x10 -> osm_vendor_put: ]
>>>>> Dec 15 23:35:05 791040 [4399A940] 0x08 -> osm_vendor_send: Completed
>>>>> sending response or unsolicited p_madw = 0x3ddf5c0
>>>>> Dec 15 23:35:05 791046 [4399A940] 0x10 -> osm_vendor_send: ]
>>>>> Dec 15 23:35:05 791051 [4399A940] 0x10 -> osm_sa_send_error: ]
>>>>> Dec 15 23:35:05 791057 [4399A940] 0x10 -> mcmr_rcv_join_mgrp: ]
>>>>> Dec 15 23:35:05 791062 [4399A940] 0x10 -> osm_mcmr_rcv_process: ]
>>>>> Dec 15 23:35:05 791068 [4399A940] 0x10 -> sa_mad_ctrl_disp_done_callback: [
>>>>> Dec 15 23:35:05 791073 [4399A940] 0x10 -> osm_vendor_put: [
>>>>> Dec 15 23:35:05 791079 [4399A940] 0x08 -> osm_vendor_put: Retiring UMAD
>>>>> 0x3dd7290
>>>>> Dec 15 23:35:05 791084 [4399A940] 0x10 -> osm_vendor_put: ]
>>>>> Dec 15 23:35:05 791090 [4399A940] 0x10 -> sa_mad_ctrl_disp_done_callback: ]
>>>>> Dec 15 23:35:05 792086 [4B1A6940] 0x10 -> osm_vendor_get: [
>>>>> Dec 15 23:35:05 792106 [4B1A6940] 0x08 -> osm_vendor_get: Acquiring UMAD
>>>>> for p_madw = 0x3ddf5d8, size = 256
>>>>> Dec 15 23:35:05 792117 [4B1A6940] 0x08 -> osm_vendor_get: Acquired UMAD
>>>>> 0x3dd7290, size = 256
>>>>> Dec 15 23:35:05 792126 [4B1A6940] 0x10 -> osm_vendor_get: ]
>>>>> Dec 15 23:35:05 792132 [4B1A6940] 0x10 -> sa_mad_ctrl_rcv_callback: [
>>>>> Dec 15 23:35:05 792139 [4B1A6940] 0x08 -> sa_mad_ctrl_rcv_callback: 4 SA
>>>>> MADs received
>>>>> Dec 15 23:35:05 792152 [4B1A6940] 0x20 -> SA MAD dump:
>>>>>                                 base_ver................0x1
>>>>>                                 mgmt_class..............0x3
>>>>>                                 class_ver...............0x2
>>>>>                                 method..................0x2 (SubnAdmSet)
>>>>>                                 status..................0x0
>>>>>                                 resv....................0x0
>>>>>                                 trans_id................0x53bf6d21e
>>>>>                                 attr_id.................0x38
>>>>> (MCMemberRecord)
>>>>>                                 resv1...................0x0
>>>>>                                 attr_mod................0x0
>>>>>                                 rmpp_version............0x0
>>>>>                                 rmpp_type...............0x0
>>>>>                                 rmpp_flags..............0x0
>>>>>                                 rmpp_status.............0x0
>>>>>                                 seg_num.................0x0
>>>>>                                 payload_len/new_win.....0x0
>>>>>                                 sm_key..................0x0000000000000000
>>>>>                                 attr_offset.............0x0
>>>>>                                 resv2...................0x0
>>>>>                                 comp_mask...............0x0000000000010083
>>>>>
>>>>>
>>>>> Dec 15 23:35:05 792158 [4B1A6940] 0x10 -> sa_mad_ctrl_process: [
>>>>> Dec 15 23:35:05 792165 [4B1A6940] 0x08 -> sa_mad_ctrl_process: Posting
>>>>> Dispatcher message OSM_MSG_MAD_MCMEMBER_RECORD
>>>>> Dec 15 23:35:05 792187 [4B1A6940] 0x10 -> sa_mad_ctrl_process: ]
>>>>> Dec 15 23:35:05 792194 [4B1A6940] 0x10 -> sa_mad_ctrl_rcv_callback: ]
>>>>> Dec 15 23:35:05 792204 [46B9F940] 0x10 -> osm_mcmr_rcv_process: [
>>>>> Dec 15 23:35:05 792211 [46B9F940] 0x10 -> mcmr_rcv_join_mgrp: [
>>>>> Dec 15 23:35:05 792216 [46B9F940] 0x08 -> mcmr_rcv_join_mgrp: Dump of
>>>>> incoming record
>>>>> Dec 15 23:35:05 792228 [46B9F940] 0x08 -> MCMember Record dump:
>>>>>
>>>>> MGID....................ff12:401b:ffff::ffff:ffff
>>>>>                                 PortGid.................fe80::1e:8c00:b9:641
>>>>>                                 qkey....................0x0
>>>>>                                 mlid....................0x0
>>>>>                                 mtu.....................0x0
>>>>>                                 TClass..................0x0
>>>>>                                 pkey....................0xFFFF
>>>>>                                 rate....................0x0
>>>>>                                 pkt_life................0x0
>>>>>                                 SLFlowLabelHopLimit.....0x0
>>>>>                                 ScopeState..............0x1
>>>>>                                 ProxyJoin...............0x0
>>>>> Dec 15 23:35:05 792236 [46B9F940] 0x04 -> validate_port_caps: Port's
>>>>> RATE 2 is less than 3
>>>>> Dec 15 23:35:05 792243 [46B9F940] 0x01 -> mcmr_rcv_join_mgrp: ERR 1B12:
>>>>> validate_more_comp_fields, validate_port_caps, or JoinState = 0 failed
>>>>> from port 0x001e8c0000b90641 (vespasianus HCA-1), sending
>>>>> IB_SA_MAD_STATUS_REQ_INVALID
>>>>> Dec 15 23:35:05 792253 [46B9F940] 0x10 -> osm_sa_send_error: [
>>>>> Dec 15 23:35:05 792260 [46B9F940] 0x10 -> osm_vendor_get: [
>>>>> Dec 15 23:35:05 792266 [46B9F940] 0x08 -> osm_vendor_get: Acquiring UMAD
>>>>> for p_madw = 0x3dd73f8, size = 256
>>>>> Dec 15 23:35:05 792273 [46B9F940] 0x08 -> osm_vendor_get: Acquired UMAD
>>>>> 0x3dd9290, size = 256
>>>>> Dec 15 23:35:05 792279 [46B9F940] 0x10 -> osm_vendor_get: ]
>>>>> Dec 15 23:35:05 792291 [46B9F940] 0x20 -> SA MAD dump:
>>>>>                                 base_ver................0x1
>>>>>                                 mgmt_class..............0x3
>>>>>                                 class_ver...............0x2
>>>>>                                 method..................0x81
>>>>> (SubnAdmGetResp)
>>>>>                                 status..................0x200
>>>>>                                 resv....................0x0
>>>>>                                 trans_id................0x53bf6d21e
>>>>>                                 attr_id.................0x38
>>>>> (MCMemberRecord)
>>>>>                                 resv1...................0x0
>>>>>                                 attr_mod................0x0
>>>>>                                 rmpp_version............0x0
>>>>>                                 rmpp_type...............0x0
>>>>>                                 rmpp_flags..............0x0
>>>>>                                 rmpp_status.............0x0
>>>>>                                 seg_num.................0x0
>>>>>                                 payload_len/new_win.....0x0
>>>>>                                 sm_key..................0x0000000000000000
>>>>>                                 attr_offset.............0x0
>>>>>                                 resv2...................0x0
>>>>>                                 comp_mask...............0x0000000000010083
>>>>>
>>>>>
>>>>> Dec 15 23:35:05 792298 [46B9F940] 0x10 -> osm_vendor_send: [
>>>>> Dec 15 23:35:05 792304 [46B9F940] 0x04 -> osm_vendor_send: RMPP 0 length 256
>>>>> Dec 15 23:35:05 792318 [46B9F940] 0x10 -> osm_vendor_put: [
>>>>> Dec 15 23:35:05 792325 [46B9F940] 0x08 -> osm_vendor_put: Retiring UMAD
>>>>> 0x3dd9290
>>>>> Dec 15 23:35:05 792331 [46B9F940] 0x10 -> osm_vendor_put: ]
>>>>> Dec 15 23:35:05 792337 [46B9F940] 0x08 -> osm_vendor_send: Completed
>>>>> sending response or unsolicited p_madw = 0x3dd73e0
>>>>> Dec 15 23:35:05 792343 [46B9F940] 0x10 -> osm_vendor_send: ]
>>>>> Dec 15 23:35:05 792360 [46B9F940] 0x10 -> osm_sa_send_error: ]
>>>>> Dec 15 23:35:05 792366 [46B9F940] 0x10 -> mcmr_rcv_join_mgrp: ]
>>>>> Dec 15 23:35:05 792371 [46B9F940] 0x10 -> osm_mcmr_rcv_process: ]
>>>>> Dec 15 23:35:05 792377 [46B9F940] 0x10 -> sa_mad_ctrl_disp_done_callback: [
>>>>> Dec 15 23:35:05 792383 [46B9F940] 0x10 -> osm_vendor_put: [
>>>>> Dec 15 23:35:05 792388 [46B9F940] 0x08 -> osm_vendor_put: Retiring UMAD
>>>>> 0x3dd7e40
>>>>> Dec 15 23:35:05 792394 [46B9F940] 0x10 -> osm_vendor_put: ]
>>>>> Dec 15 23:35:05 792400 [46B9F940] 0x10 -> sa_mad_ctrl_disp_done_callback: ]
>>>>> Dec 15 23:35:09 759207 [4A7A5940] 0x08 -> sm_sweeper: Off schedule sweep
>>>>> signalled
>>>>> Dec 15 23:35:09 759229 [4A7A5940] 0x10 -> osm_state_mgr_process: [
>>>>> Dec 15 23:35:09 759240 [4A7A5940] 0x08 -> osm_state_mgr_process:
>>>>> Received signal OSM_SIGNAL_SWEEP in state MASTER
>>>>> Dec 15 23:35:09 759249 [4A7A5940] 0x10 -> state_mgr_sweep_hop_0: [
>>>>> Dec 15 23:35:09 759258 [4A7A5940] 0x04 -> state_mgr_sweep_hop_0:
>>>>>
>>>>>
>>>>>
>>>>> thanks,
>>>>>
>>>>> Gerben
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>>
>>
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
