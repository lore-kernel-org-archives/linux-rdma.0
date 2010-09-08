From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V2] libibmad/fields.c: Change all PortCounter names to match
 the Specification
Date: Wed, 8 Sep 2010 12:13:35 -0700
Message-ID: <20100908121335.814802cb.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 3 Aug 2010 10:40:56 -0700
Subject: [PATCH V2] libibmad/fields.c: Change all PortCounter names to match the Specification

Change from V1:
   Add name change to scripts in infiniband-diags

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/scripts/IBswcountlimits.pm |   56 +++++++++++-----------
 infiniband-diags/scripts/ibcheckerrs.in     |   66 +++++++++++++-------------
 libibmad/src/fields.c                       |   32 +++++++-------
 3 files changed, 77 insertions(+), 77 deletions(-)

diff --git a/infiniband-diags/scripts/IBswcountlimits.pm b/infiniband-diags/scripts/IBswcountlimits.pm
index 6623b8b..7531aef 100755
--- a/infiniband-diags/scripts/IBswcountlimits.pm
+++ b/infiniband-diags/scripts/IBswcountlimits.pm
@@ -47,41 +47,41 @@ $IBswcountlimits::cache_dir       = "/var/cache/infiniband-diags";
 
 # all the PerfMgt counters
 @IBswcountlimits::counters = (
-	"SymbolErrors",        "LinkRecovers",
-	"LinkDowned",          "RcvErrors",
-	"RcvRemotePhysErrors", "RcvSwRelayErrors",
-	"XmtDiscards",         "XmtConstraintErrors",
-	"RcvConstraintErrors", "LinkIntegrityErrors",
-	"ExcBufOverrunErrors", "VL15Dropped",
-	"XmtData",             "RcvData",
-	"XmtPkts",             "RcvPkts"
+	"SymbolErrorCounter",        "LinkErrorRecoveryCounter",
+	"LinkDownedCounter",          "PortRcvErrors",
+	"PortRcvRemotePhysicalErrors", "PortRcvSwitchRelayErrors",
+	"PortXmitDiscards",         "PortXmitConstraintErrors",
+	"PortRcvConstraintErrors", "LocalLinkIntegrityErrors",
+	"ExcessiveBufferOverrunErrors", "VL15Dropped",
+	"PortXmitData",             "PortRcvData",
+	"PortXmitPkts",             "PortRcvPkts"
 );
 
 # non-critical counters
 %IBswcountlimits::error_counters = (
-	"SymbolErrors",
-"No action is required except if counter is increasing along with LinkRecovers",
-	"LinkRecovers",
-"If this is increasing along with SymbolErrors this may indicate a bad link, run ibswportwatch.pl on this port",
-	"LinkDowned",
+	"SymbolErrorCounter",
+"No action is required except if counter is increasing along with LinkErrorRecoveryCounter",
+	"LinkErrorRecoveryCounter",
+"If this is increasing along with SymbolErrorCounter this may indicate a bad link, run ibswportwatch.pl on this port",
+	"LinkDownedCounter",
 	"Number of times the port has gone down (Usually for valid reasons)",
-	"RcvErrors",
+	"PortRcvErrors",
 "This is a bad link, if the link is internal to a 288 try setting SDR, otherwise check the cable",
-	"RcvRemotePhysErrors",
+	"PortRcvRemotePhysicalErrors",
 	"This indicates a problem ELSEWHERE in the fabric.",
-	"XmtDiscards",
+	"PortXmitDiscards",
 "This is a symptom of congestion and may require tweaking either HOQ or switch lifetime values",
-	"XmtConstraintErrors",
+	"PortXmitConstraintErrors",
 	"This is a result of bad partitioning, check partition configuration.",
-	"RcvConstraintErrors",
+	"PortRcvConstraintErrors",
 	"This is a result of bad partitioning, check partition configuration.",
-	"LinkIntegrityErrors",
+	"LocalLinkIntegrityErrors",
 	"May indicate a bad link, run ibswportwatch.pl on this port",
-	"ExcBufOverrunErrors",
+	"ExcessiveBufferOverrunErrors",
 "This is a flow control state machine error and can be caused by packets with physical errors",
 	"VL15Dropped",
 	"check with ibswportwatch.pl, if increasing in SMALL increments, OK",
-	"RcvSwRelayErrors",
+	"PortRcvSwitchRelayErrors",
 	"This counter can increase due to a valid network event"
 );
 
@@ -113,13 +113,13 @@ sub check_counters
 
 # Data counters
 %IBswcountlimits::data_counters = (
-	"XmtData",
+	"PortXmitData",
 "Total number of data octets, divided by 4, transmitted on all VLs from the port",
-	"RcvData",
+	"PortRcvData",
 "Total number of data octets, divided by 4, received on all VLs to the port",
-	"XmtPkts",
+	"PortXmitPkts",
 "Total number of packets, excluding link packets, transmitted on all VLs from the port",
-	"RcvPkts",
+	"PortRcvPkts",
 "Total number of packets, excluding link packets, received on all VLs to the port"
 );
 
@@ -167,9 +167,9 @@ sub calculate_rate
 	return ($rate);
 }
 %IBswcountlimits::rate_dep_thresholds = (
-	"SymbolErrors", 10, "LinkRecovers",        10,
-	"RcvErrors",    10, "LinkIntegrityErrors", 10,
-	"XmtDiscards",  10
+	"SymbolErrorCounter", 10, "LinkErrorRecoveryCounter",        10,
+	"PortRcvErrors",    10, "LocalLinkIntegrityErrors", 10,
+	"PortXmitDiscards",  10
 );
 
 sub check_counter_rates
diff --git a/infiniband-diags/scripts/ibcheckerrs.in b/infiniband-diags/scripts/ibcheckerrs.in
index 15bfd4a..6052ff8 100644
--- a/infiniband-diags/scripts/ibcheckerrs.in
+++ b/infiniband-diags/scripts/ibcheckerrs.in
@@ -30,17 +30,17 @@ function red() {
 }
 
 function show_thresholds() {
-	echo "SymbolErrors=$SymbolErrors"
-	echo "LinkRecovers=$LinkRecovers"
-	echo "LinkDowned=$LinkDowned"
-	echo "RcvErrors=$RcvErrors"
-	echo "RcvRemotePhysErrors=$RcvRemotePhysErrors"
-	echo "RcvSwRelayErrors=$RcvSwRelayErrors"
-	echo "XmtDiscards=$XmtDiscards"
-	echo "XmtConstraintErrors=$XmtConstraintErrors"
-	echo "RcvConstraintErrors=$RcvConstraintErrors"
-	echo "LinkIntegrityErrors=$LinkIntegrityErrors"
-	echo "ExcBufOverrunErrors=$ExcBufOverrunErrors"
+	echo "SymbolErrorCounter=$SymbolErrorCounter"
+	echo "LinkErrorRecoveryCounter=$LinkErrorRecoveryCounter"
+	echo "LinkDownedCounter=$LinkDownedCounter"
+	echo "PortRcvErrors=$PortRcvErrors"
+	echo "PortRcvRemotePhysicalErrors=$PortRcvRemotePhysicalErrors"
+	echo "PortRcvSwitchRelayErrors=$PortRcvSwitchRelayErrors"
+	echo "PortXmitDiscards=$PortXmitDiscards"
+	echo "PortXmitConstraintErrors=$PortXmitConstraintErrors"
+	echo "PortRcvConstraintErrors=$PortRcvConstraintErrors"
+	echo "LocalLinkIntegrityErrors=$LocalLinkIntegrityErrors"
+	echo "ExcessiveBufferOverrunErrors=$ExcessiveBufferOverrunErrors"
 	echo "VL15Dropped=$VL15Dropped"
 }
 
@@ -49,17 +49,17 @@ function get_thresholds() {
 }
 
 # Default thresholds
-SymbolErrors=10
-LinkRecovers=10
-LinkDowned=10
-RcvErrors=10
-RcvRemotePhysErrors=100
-RcvSwRelayErrors=100
-XmtDiscards=100
-XmtConstraintErrors=100
-RcvConstraintErrors=100
-LinkIntegrityErrors=10
-ExcBufOverrunErrors=10
+SymbolErrorCounter=10
+LinkErrorRecoveryCounter=10
+LinkDownedCounter=10
+PortRcvErrors=10
+PortRcvRemotePhysicalErrors=100
+PortRcvSwitchRelayErrors=100
+PortXmitDiscards=100
+PortXmitConstraintErrors=100
+PortRcvConstraintErrors=100
+LocalLinkIntegrityErrors=10
+ExcessiveBufferOverrunErrors=10
 VL15Dropped=100
 
 guid_addr=""
@@ -178,17 +178,17 @@ function blue(s)
 }
 
 BEGIN {
-	th["SymbolErrors"] = '$SymbolErrors'
-	th["LinkRecovers"] = '$LinkRecovers'
-	th["LinkDowned"] = '$LinkDowned'
-	th["RcvErrors"] = '$RcvErrors'
-	th["RcvRemotePhysErrors"] = '$RcvRemotePhysErrors'
-	th["RcvSwRelayErrors"] = '$RcvSwRelayErrors'
-	th["XmtDiscards"] = '$XmtDiscards'
-	th["XmtConstraintErrors"] = '$XmtConstraintErrors'
-	th["RcvConstraintErrors"] = '$RcvConstraintErrors'
-	th["LinkIntegrityErrors"] = '$LinkIntegrityErrors'
-	th["ExcBufOverrunErrors"] = '$ExcBufOverrunErrors'
+	th["SymbolErrorCounter"] = '$SymbolErrorCounter'
+	th["LinkErrorRecoveryCounter"] = '$LinkErrorRecoveryCounter'
+	th["LinkDownedCounter"] = '$LinkDownedCounter'
+	th["PortRcvErrors"] = '$PortRcvErrors'
+	th["PortRcvRemotePhysicalErrors"] = '$PortRcvRemotePhysicalErrors'
+	th["PortRcvSwitchRelayErrors"] = '$PortRcvSwitchRelayErrors'
+	th["PortXmitDiscards"] = '$PortXmitDiscards'
+	th["PortXmitConstraintErrors"] = '$PortXmitConstraintErrors'
+	th["PortRcvConstraintErrors"] = '$PortRcvConstraintErrors'
+	th["LocalLinkIntegrityErrors"] = '$LocalLinkIntegrityErrors'
+	th["ExcessiveBufferOverrunErrors"] = '$ExcessiveBufferOverrunErrors'
 	th["VL15Dropped"] = '$VL15Dropped'
 }
 
diff --git a/libibmad/src/fields.c b/libibmad/src/fields.c
index a5a510a..d992065 100644
--- a/libibmad/src/fields.c
+++ b/libibmad/src/fields.c
@@ -246,24 +246,24 @@ static const ib_field_t ib_mad_f[] = {
 	 */
 	{BITSOFFS(8, 8), "PortSelect", mad_dump_uint},
 	{BITSOFFS(16, 16), "CounterSelect", mad_dump_hex},
-	{BITSOFFS(32, 16), "SymbolErrors", mad_dump_uint},
-	{BITSOFFS(48, 8), "LinkRecovers", mad_dump_uint},
-	{BITSOFFS(56, 8), "LinkDowned", mad_dump_uint},
-	{BITSOFFS(64, 16), "RcvErrors", mad_dump_uint},
-	{BITSOFFS(80, 16), "RcvRemotePhysErrors", mad_dump_uint},
-	{BITSOFFS(96, 16), "RcvSwRelayErrors", mad_dump_uint},
-	{BITSOFFS(112, 16), "XmtDiscards", mad_dump_uint},
-	{BITSOFFS(128, 8), "XmtConstraintErrors", mad_dump_uint},
-	{BITSOFFS(136, 8), "RcvConstraintErrors", mad_dump_uint},
+	{BITSOFFS(32, 16), "SymbolErrorCounter", mad_dump_uint},
+	{BITSOFFS(48, 8), "LinkErrorRecoveryCounter", mad_dump_uint},
+	{BITSOFFS(56, 8), "LinkDownedCounter", mad_dump_uint},
+	{BITSOFFS(64, 16), "PortRcvErrors", mad_dump_uint},
+	{BITSOFFS(80, 16), "PortRcvRemotePhysicalErrors", mad_dump_uint},
+	{BITSOFFS(96, 16), "PortRcvSwitchRelayErrors", mad_dump_uint},
+	{BITSOFFS(112, 16), "PortXmitDiscards", mad_dump_uint},
+	{BITSOFFS(128, 8), "PortXmitConstraintErrors", mad_dump_uint},
+	{BITSOFFS(136, 8), "PortRcvConstraintErrors", mad_dump_uint},
 	{BITSOFFS(144, 8), "CounterSelect2", mad_dump_hex},
-	{BITSOFFS(152, 4), "LinkIntegrityErrors", mad_dump_uint},
-	{BITSOFFS(156, 4), "ExcBufOverrunErrors", mad_dump_uint},
+	{BITSOFFS(152, 4), "LocalLinkIntegrityErrors", mad_dump_uint},
+	{BITSOFFS(156, 4), "ExcessiveBufferOverrunErrors", mad_dump_uint},
 	{BITSOFFS(176, 16), "VL15Dropped", mad_dump_uint},
-	{192, 32, "XmtData", mad_dump_uint},
-	{224, 32, "RcvData", mad_dump_uint},
-	{256, 32, "XmtPkts", mad_dump_uint},
-	{288, 32, "RcvPkts", mad_dump_uint},
-	{320, 32, "XmtWait", mad_dump_uint},
+	{192, 32, "PortXmitData", mad_dump_uint},
+	{224, 32, "PortRcvData", mad_dump_uint},
+	{256, 32, "PortXmitPkts", mad_dump_uint},
+	{288, 32, "PortRcvPkts", mad_dump_uint},
+	{320, 32, "PortXmitWait", mad_dump_uint},
 	{0, 0},			/* IB_PC_LAST_F */
 
 	/*
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
