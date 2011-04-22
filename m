From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: Re: opensm: switch incorrectly reports
 IB_PORT_CAP_HAS_MCAST_FDB_TOP ?
Date: Fri, 22 Apr 2011 14:30:05 -0600
Message-ID: <4DB1E54D.2090105@sandia.gov>
References: <4DB1C6A0.9000001@sandia.gov>
 <DE4C083D-C975-4DAC-818E-EAB23353DEF0@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DE4C083D-C975-4DAC-818E-EAB23353DEF0-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Weiny, Ira K. wrote:
> On Apr 22, 2011, at 11:19 AM, Jim Schutt wrote:
> 
>> Hi,
>>
>> I've been testing the current opensm development head
>> (commit 83b67527d16 from git://git.openfabrics.org/~alexnetes/opensm),
>> and I've been getting some messages that are new since version 3.3.7:
>>
>> Apr 22 12:08:09 646534 [411CD940] 0x01 -> log_rcv_cb_error: ERR 3111: Received MAD with error status = 0x1C
>>                         SubnGetResp(SwitchInfo), attr_mod 0x0, TID 0x4802
>>                         Initial path: 0,1,1,4 Return path: 0,20,1,7
>>
>> I get one of these messages for each switch in my fabric, on every
>> heavy sweep.
>>
>> It appears these are caused by my switches incorrectly reporting
>> the capability IB_PORT_CAP_HAS_MCAST_FDB_TOP; i.e. this patch stops
>> the messages:
>>
>> diff --git a/opensm/osm_mcast_mgr.c b/opensm/osm_mcast_mgr.c
>> index ea52bfe..63d2968 100644
>> --- a/opensm/osm_mcast_mgr.c
>> +++ b/opensm/osm_mcast_mgr.c
>> @@ -1041,7 +1041,7 @@ static void mcast_mgr_set_mfttop(IN osm_sm_t * sm, IN osm_switch_t * p_sw)
>>  	p_path = osm_physp_get_dr_path_ptr(p_physp);
>>  	p_tbl = osm_switch_get_mcast_tbl_ptr(p_sw);
>>
>> -	if (p_physp->port_info.capability_mask & IB_PORT_CAP_HAS_MCAST_FDB_TOP) {
>> +	if (0 && p_physp->port_info.capability_mask & IB_PORT_CAP_HAS_MCAST_FDB_TOP) {
>>  		/*
>>  		   Set the top of the multicast forwarding table.
>>  		 */
>>
>> IB_PORT_CAP_HAS_MCAST_FDB_TOP is bit 30 of the port capability mask,
>> which in at least IBA v1.2.1 was a reserved bit but apparently is
>> not anymore.
> 
> Yes these have been published as errata to the 1.2.1 specification.
> 
> smpquery portinfo <lid>
> 
> should show you if it is reporting that field.  Also what does
> 
> smpquery switchinfo <lid>
> 
> say?

# smpquery --version
smpquery BUILD VERSION: 1.5.8_f0526f4 Build date: Apr 22 2011 12:36:58

# smpquery -G switchinfo 0x21283a87200040
# Switch info: Lid 3
LinearFdbCap:....................49152
RandomFdbCap:....................0
McastFdbCap:.....................4096
LinearFdbTop:....................105
DefPort:.........................0
DefMcastPrimPort:................255
DefMcastNotPrimPort:.............255
LifeTime:........................18
StateChange:.....................0
OptSLtoVLMapping:................1
LidsPerPort:.....................0
PartEnforceCap:..................32
InboundPartEnf:..................1
OutboundPartEnf:.................1
FilterRawInbound:................1
FilterRawOutbound:...............1
EnhancedPort0:...................0
MulticastFDBTop:.................0x0000

# smpquery portinfo 3
# Port info: Lid 3 port 0
Mkey:............................0x0000000000000000
GidPrefix:.......................0xfe80000000000000
Lid:.............................3
SMLid:...........................48
CapMask:.........................0x42500848
                                 IsTrapSupported
                                 IsSLMappingSupported
                                 IsSystemImageGUIDsupported
                                 IsVendorClassSupported
                                 IsCapabilityMaskNoticeSupported
                                 IsClientRegistrationSupported
                                 IsMulticastFDBTopSupported
DiagCode:........................0x0000
MkeyLeasePeriod:.................0
LocalPort:.......................20
LinkWidthEnabled:................1X or 4X
LinkWidthSupported:..............1X or 4X
LinkWidthActive:.................4X
LinkSpeedSupported:..............2.5 Gbps or 5.0 Gbps or 10.0 Gbps
LinkState:.......................Active
PhysLinkState:...................LinkUp
LinkDownDefState:................Polling
ProtectBits:.....................0
LMC:.............................0
LinkSpeedActive:.................10.0 Gbps
LinkSpeedEnabled:................2.5 Gbps or 5.0 Gbps or 10.0 Gbps
NeighborMTU:.....................4096
SMSL:............................0
VLCap:...........................VL0-3
InitType:........................0x00
VLHighLimit:.....................0
VLArbHighCap:....................0
VLArbLowCap:.....................0
InitReply:.......................0x00
MtuCap:..........................4096
VLStallCount:....................0
HoqLife:.........................0
OperVLs:.........................VL0-3
PartEnforceInb:..................0
PartEnforceOutb:.................0
FilterRawInb:....................0
FilterRawOutb:...................0
MkeyViolations:..................0
PkeyViolations:..................0
QkeyViolations:..................0
GuidCap:.........................1
ClientReregister:................0
McastPkeyTrapSuppressionEnabled:.0
SubnetTimeout:...................18
RespTimeVal:.....................19
LocalPhysErr:....................0
OverrunErr:......................0
MaxCreditHint:...................0
RoundTrip:.......................0

-- Jim

> 
> Ira
> 
>> Should I file a bug report with my switch vendor about setting
>> a port capability bit for a capability they don't support, or
>> is there something else going on that I haven't figured out yet?
>>
>> FWIW I think my switches have a base SP0; maybe it's got something
>> to do with that?
>>
>> Thanks -- Jim
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
