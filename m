From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 11/15 ibacm] Add description of preloading GID and LID destination
 caches to acm_notes.txt
Date: Fri, 21 Jun 2013 07:02:27 -0400
Message-ID: <51C432C3.9000801@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 acm_notes.txt |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/acm_notes.txt b/acm_notes.txt
index 99eaf9a..5c20129 100644
--- a/acm_notes.txt
+++ b/acm_notes.txt
@@ -128,3 +128,14 @@ The current implementation of the IB ACM has several additional restrictions:
   limited to 4.
 - The number of multicast groups that an endpoint can support is limited to 2.
 
+The ibacm contains several internal caches.  These include  caches  for
+GID  and  LID  destination  addresses.   These caches can be optionally
+preloaded. ibacm supports the OpenSM dump_pr plugin  "full"  PathRecord
+format which is used to preload these caches.  The file format is specified
+in the ibacm_opts.cfg file via the path_rec_fmt  parameter  which should
+be  set  to  full_opensm_v1  for  this file format which is the
+default.  See dump_pr.notes.txt in dump_pr for more information on both
+this  file  format and how to configure OpenSM to output this file.  By
+default, if the -p option  is  specified,  the  default  file  used  to
+preload these caches is ACM_CONF_DIR/ibacm_path_record.dump
+
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
