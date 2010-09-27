From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm: Fix some typos
Date: Mon, 27 Sep 2010 09:46:40 -0400
Message-ID: <20100927134640.GA1373@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Fix some typos in the opensm man page (man/opensm.8.in) and in the
partition config doc (doc/partition-config.txt)

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/doc/partition-config.txt b/opensm/doc/partition-config.txt
index fdec218..537f6a7 100644
--- a/opensm/doc/partition-config.txt
+++ b/opensm/doc/partition-config.txt
@@ -75,7 +75,7 @@ PortGUID     - GUID of partition member EndPort. Hexadecimal numbers
 full or      - indicates full or limited membership for this port. When
   limited      omitted (or unrecognized) limited membership is assumed.
 
-There are two useful keywords for PortGUID definition:
+There are several useful keywords for PortGUID definition:
 
 - 'ALL' means all end ports in this subnet.
 - 'ALL_CAS' means all Channel Adapter end ports in this subnet.
diff --git a/opensm/man/opensm.8.in b/opensm/man/opensm.8.in
index 9053611..cf6d8f9 100644
--- a/opensm/man/opensm.8.in
+++ b/opensm/man/opensm.8.in
@@ -175,7 +175,7 @@ the host comes back online.
 \fB\-z\fR, \fB\-\-connect_roots\fR
 This option enforces routing engines (up/down and
 fat-tree) to make connectivity between root switches and in
-this way to be fully IBA complaint. In many cases this can
+this way to be fully IBA compliant. In many cases this can
 violate "pure" deadlock free algorithm, so use it carefully.
 .TP
 \fB\-M\fR, \fB\-\-lid_matrix_file\fR <file name>
@@ -517,7 +517,7 @@ PortGUIDs list:
                     port.  When omitted (or unrecognized) limited
                     membership is assumed.
 
-There are two useful keywords for PortGUID definition:
+There are several useful keywords for PortGUID definition:
 
  - 'ALL' means all end ports in this subnet.
  - 'ALL_CAS' means all Channel Adapter end ports in this subnet.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
