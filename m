From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm/man/opensm.8.in: Add section for MKey support
Date: Wed,  1 Aug 2012 14:39:35 -0700
Message-ID: <1343857175-32584-1-git-send-email-foraker1@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, weiny2-i2BcT+NCU+M@public.gmane.org, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 man/opensm.8.in |   84 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 82 insertions(+), 2 deletions(-)

diff --git a/man/opensm.8.in b/man/opensm.8.in
index dd67671..79ff6a5 100644
--- a/man/opensm.8.in
+++ b/man/opensm.8.in
@@ -501,9 +501,12 @@ opensm.mcfdbs. By default, this directory is /var/log.
 
 OSM_CACHE_DIR - opensm stores certain data to the disk such that subsequent
 runs are consistent. The default directory used is /var/cache/opensm.
-The following file is included in it:
+The following files are included in it:
 
- guid2lid - stores the LID range assigned to each GUID
+ guid2lid  - stores the LID range assigned to each GUID
+ guid2mkey - stores the MKey previously assiged to each GUID
+ neighbors - stores a map of the GUIDs at either end of each link
+             in the fabric
 
 .SH NOTES
 .PP
@@ -761,6 +764,83 @@ off-subnet DGID should return a path to the first available router.
 This configuration yields the same behavior formerly achieved by
 compiling opensm with -DROUTER_EXP which has been obsoleted.
 
+.SH MKEY CONFIGURATION
+.PP
+OpenSM supports configuring a single management key (MKey) for use across
+the subnet.
+
+The following configuration options are available:
+
+ m_key                  - the 64-bit MKey to be used on the subnet
+                          (IBA 14.2.4)
+ m_key_protection_level - the numeric value of the MKey ProtectBits
+                          (IBA 14.2.4.1)
+ m_key_lease_period     - the number of seconds a CA will wait for a
+                          response from the SM before resetting the
+                          protection level to 0 (IBA 14.2.4.2).
+
+OpenSM will configure all ports with the MKey specified by m_key, defaulting
+to a value of 0. A m_key value of 0 disables MKey protection on the subnet.
+Switches and HCAs with a non-zero MKey will not accept requests to change
+their configuration unless the request includes the proper MKey.
+
+MKey Protection Levels
+
+MKey protection levels modify how switches and CAs respond to SMPs lacking
+a valid MKey.
+OpenSM will configure each port's ProtectBits to support the level defined by
+the m_key_protection_level parameter.  If no parameter is specified, OpenSM
+defaults to operating at protection level 0.
+
+There are currently 4 protection levels defined by the IBA:
+
+ 0 - Queries return valid data, including MKey.  Configuration changes
+     are not allowed unless the request contains a valid MKey.
+ 1 - Like level 0, but the MKey is set to 0 (0x00000000) in queries,
+     unless the request contains a valid MKey.
+ 2 - Neither queries nor configuration changes are allowed, unless the
+     request contains a valid MKey.
+ 3 - Identical to 2.  Maintained for backwards compatibility.
+
+MKey Lease Period
+
+InfiniBand supports a MKey lease timeout, which is intended to allow
+administrators or a new SM to recover/reset lost MKeys on a fabric.
+
+If MKeys are enabled on the subnet and a switch or CA receives a request that
+requires a valid MKey but does not contain one, it warns the SM by sending a trap
+(Bad M_Key, Trap 256).  If the MKey lease period is non-zero, it also starts a
+countdown timer for the time specified by the lease period.
+If a SM (or other agent) responds with the correct MKey, the timer is stopped
+and reset.  Should the timer reach zero, the switch or CA will reset its MKey
+protection level to 0, exposing the MKey and allowing recovery.
+
+OpenSM will initialize all ports to use a mkey lease period of the number of
+seconds specified in the config file.  If no mkey_lease_period is specified,
+a default of 0 will be used.
+
+OpenSM normally quickly responds to all Bad_M_Key traps, resetting the lease
+timers.  Additionally, OpenSM's subnet sweeps will also cancel
+any running timers.  For maximum protection against accidentally-exposed MKeys,
+the MKey lease time should be a few multiples of the subnet sweep time.
+If OpenSM detects at startup that your sweep interval is greater than your
+MKey lease period, it will reset the lease period to be greater than the
+sweep interval.  Similarly, if sweeping is disabled at startup, it will be
+re-enabled with an interval less than the Mkey lease period.
+
+If OpenSM is required to recover a subnet for which it is missing mkeys,
+it must do so one switch level at a time.  As such, the total time to
+recover the subnet may be as long as the mkey lease period multiplied by
+the maximum number of hops between the SM and an endpoint, plus one.
+
+MKey Effects on Diagnostic Utilities
+
+Setting a MKey may have a detrimental effect on diagnostic software run on
+the subnet, unless your diagnostic software is able to retrieve MKeys from the
+SA or can be explicitly configured with the proper MKey.  This is particularly
+true at protection level 2, where CAs will ignore queries for management
+information that do not contain the proper MKey.
+
 .SH ROUTING
 .PP
 OpenSM now offers nine routing engines:
-- 
1.7.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
