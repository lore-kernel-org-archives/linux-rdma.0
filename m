From: Alan Cook <acook-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org>
Subject: Re: Unable to Connect Using Active Speed 2.5 Gbps and Active Width of 1
Date: Mon, 28 Mar 2011 19:07:34 +0000 (UTC)
Message-ID: <loom.20110328T210350-244@post.gmane.org>
References: <loom.20110328T194956-774@post.gmane.org> <4D90D9A2.7000107@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hal Rosenstock <hal@...> writes:
> 
> What does smpquery portinfo say for both sides of that link ?
> 

What specifically would be I be looking for in this data to determine if their
is an issue?

For card 1 I have:

# Port info: DR path slid 65535; dlid 65535; 0 port 1
Mkey:............................0x0000000000000000
GidPrefix:.......................0xfe80000000000000
Lid:.............................2
SMLid:...........................1
CapMask:.........................0x2510868
                                IsTrapSupported
                                IsAutomaticMigrationSupported
                                IsSLMappingSupported
                                IsSystemImageGUIDsupported
                                IsCommunicatonManagementSupported
                                IsVendorClassSupported
                                IsCapabilityMaskNoticeSupported
                                IsClientRegistrationSupported
DiagCode:........................0x0000
MkeyLeasePeriod:.................0
LocalPort:.......................1
LinkWidthEnabled:................1X or 4X
LinkWidthSupported:..............1X or 4X
LinkWidthActive:.................1X
LinkSpeedSupported:..............2.5 Gbps or 5.0 Gbps or 10.0 Gbps
LinkState:.......................Active
PhysLinkState:...................LinkUp
LinkDownDefState:................Polling
ProtectBits:.....................0
LMC:.............................0
LinkSpeedActive:.................2.5 Gbps
LinkSpeedEnabled:................2.5 Gbps
NeighborMTU:.....................2048
SMSL:............................0
VLCap:...........................VL0-7
InitType:........................0x00
VLHighLimit:.....................4
VLArbHighCap:....................8
VLArbLowCap:.....................8
InitReply:.......................0x00
MtuCap:..........................2048
VLStallCount:....................0
HoqLife:.........................31
OperVLs:.........................VL0-7
PartEnforceInb:..................0
PartEnforceOutb:.................0
FilterRawInb:....................0
FilterRawOutb:...................0
MkeyViolations:..................0
PkeyViolations:..................0
QkeyViolations:..................0
GuidCap:.........................128
ClientReregister:................0
SubnetTimeout:...................18
RespTimeVal:.....................16
LocalPhysErr:....................8
OverrunErr:......................8
MaxCreditHint:...................0
RoundTrip:.......................0


For card 2 I have:

# Port info: DR path slid 65535; dlid 65535; 0 port 1
Mkey:............................0x0000000000000000
GidPrefix:.......................0xfe80000000000000
Lid:.............................1
SMLid:...........................1
CapMask:.........................0x251086a
                                IsSM
                                IsTrapSupported
                                IsAutomaticMigrationSupported
                                IsSLMappingSupported
                                IsSystemImageGUIDsupported
                                IsCommunicatonManagementSupported
                                IsVendorClassSupported
                                IsCapabilityMaskNoticeSupported
                                IsClientRegistrationSupported
DiagCode:........................0x0000
MkeyLeasePeriod:.................0
LocalPort:.......................1
LinkWidthEnabled:................1X or 4X
LinkWidthSupported:..............1X or 4X
LinkWidthActive:.................1X
LinkSpeedSupported:..............2.5 Gbps or 5.0 Gbps or 10.0 Gbps
LinkState:.......................Active
PhysLinkState:...................LinkUp
LinkDownDefState:................Polling
ProtectBits:.....................0
LMC:.............................0
LinkSpeedActive:.................2.5 Gbps
LinkSpeedEnabled:................2.5 Gbps
NeighborMTU:.....................2048
SMSL:............................0
VLCap:...........................VL0-7
InitType:........................0x00
VLHighLimit:.....................4
VLArbHighCap:....................8
VLArbLowCap:.....................8
InitReply:.......................0x00
MtuCap:..........................2048
VLStallCount:....................0
HoqLife:.........................31
OperVLs:.........................VL0-7
PartEnforceInb:..................0
PartEnforceOutb:.................0
FilterRawInb:....................0
FilterRawOutb:...................0
MkeyViolations:..................0
PkeyViolations:..................0
QkeyViolations:..................0
GuidCap:.........................128
ClientReregister:................0
SubnetTimeout:...................18
RespTimeVal:.....................16
LocalPhysErr:....................8
OverrunErr:......................8
MaxCreditHint:...................0
RoundTrip:.......................0



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
