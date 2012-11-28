From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 7/8] opensm: Update doc for changes to torus routing for,
 endport support
Date: Wed, 28 Nov 2012 14:03:39 -0500
Message-ID: <50B6600B.7040504@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Change CA links to endport links

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 doc/current-routing.txt |   19 ++++++++++---------
 man/torus-2QoS.8.in     |   19 ++++++++++---------
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/doc/current-routing.txt b/doc/current-routing.txt
index c984801..dcd64a7 100644
--- a/doc/current-routing.txt
+++ b/doc/current-routing.txt
@@ -748,21 +748,22 @@ will be ignored, and a warning will be generated.
 
 For inter-switch links, Torus-2QoS uses VL values 0-3 to implement one of
 its supported QoS levels, and VL values 4-7 to implement the other. For
-CA links, Torus-2QoS uses VL value 0 for one of its supported QoS
-levels and VL value 1 to implement the other.  Hard-to-diagnose application
-issues may arise if traffic is not delivered fairly across each of these
-two VL ranges. For inter-switch links, Torus-2QoS will detect and warn if
-VL arbitration is configured unfairly across VLs in the range 0-3, and also
-in the range 4-7. Note that the default OpenSM VL arbitration configuration
-does not meet this constraint, so all torus-2QoS users should configure VL
+endport links (CA, router, switch management port), Torus-2QoS uses VL
+value 0 for one of its supported QoS levels and VL value 1 to implement
+the other.  Hard-to-diagnose application issues may arise if traffic is
+not delivered fairly across each of these two VL ranges. For
+inter-switch links, Torus-2QoS will detect and warn if VL arbitration is
+configured unfairly across VLs in the range 0-3, and also in the range
+4-7. Note that the default OpenSM VL arbitration configuration does
+not meet this constraint, so all torus-2QoS users should configure VL
 arbitration via qos_ca_vlarb_high, qos_swe_vlarb_high, qos_ca_vlarb_low,
 qos_swe_vlarb_low, etc.
 
 Note that torus-2QoS maps SL values to VL values differently
-for inter-switch and CA links.  This is why qos_vlarb_high and
+for inter-switch and endport links.  This is why qos_vlarb_high and
 qos_vlarb_low should not be used, as using them may result in
 VL arbitration for a QoS level being different across inter-switch
-links vs. across CA links.
+links vs. across endport links.
 
 Operational Considerations:
 
diff --git a/man/torus-2QoS.8.in b/man/torus-2QoS.8.in
index d62beba..f192066 100644
--- a/man/torus-2QoS.8.in
+++ b/man/torus-2QoS.8.in
@@ -406,21 +406,22 @@ torus-2QoS, any configuration via qos_sl2vl, qos_swe_sl2vl,
 .P
 For inter-switch links, Torus-2QoS uses VL values 0-3 to implement one of
 its supported QoS levels, and VL values 4-7 to implement the other. For
-CA links, Torus-2QoS uses VL value 0 for one of its supported QoS
-levels and VL value 1 to implement the other.  Hard-to-diagnose application
-issues may arise if traffic is not delivered fairly across each of these
-two VL ranges. For inter-switch links, Torus-2QoS will detect and warn if
-VL arbitration is configured unfairly across VLs in the range 0-3, and also
-in the range 4-7. Note that the default OpenSM VL arbitration configuration
-does not meet this constraint, so all torus-2QoS users should configure VL
+endport links (CA, router, switch management port), Torus-2QoS uses VL
+value 0 for one of its supported QoS levels and VL value 1 to implement
+the other.  Hard-to-diagnose application issues may arise if traffic is
+not delivered fairly across each of these two VL ranges. For
+inter-switch links, Torus-2QoS will detect and warn if VL arbitration is
+configured unfairly across VLs in the range 0-3, and also in the range
+4-7. Note that the default OpenSM VL arbitration configuration does
+not meet this constraint, so all torus-2QoS users should configure VL
 arbitration via qos_ca_vlarb_high, qos_swe_vlarb_high, qos_ca_vlarb_low,
 qos_swe_vlarb_low, \fIetc.\fR
 .P
 Note that torus-2QoS maps SL values to VL values differently
-for inter-switch and CA links.  This is why qos_vlarb_high and
+for inter-switch and endport links.  This is why qos_vlarb_high and
 qos_vlarb_low should not be used, as using them may result in
 VL arbitration for a QoS level being different across inter-switch
-links vs. across CA links.
+links vs. across endport links.
 .
 .SH OPERATIONAL CONSIDERATIONS
 .
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
