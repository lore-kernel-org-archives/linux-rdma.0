From: jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/1] Libibumad: Clarify the man page for function umad_get_ca_portguids
Date: Mon,  8 Aug 2016 13:49:58 -0400
Message-ID: <1470678598-27218-2-git-send-email-jay.p.patel@intel.com>
References: <1470678598-27218-1-git-send-email-jay.p.patel@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470678598-27218-1-git-send-email-jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jay Patel <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jay Patel <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Clarified the return value explanation of umad_get_ca_portguids() in
corresponding man page.

Signed-off-by: Jay Patel <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 man/umad_get_ca_portguids.3 | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/man/umad_get_ca_portguids.3 b/man/umad_get_ca_portguids.3
index 3512649..ff8d433 100644
--- a/man/umad_get_ca_portguids.3
+++ b/man/umad_get_ca_portguids.3
@@ -29,6 +29,9 @@ uint64_t entries.
 On success,
 .B umad_get_ca_portguids()
 returns a non-negative value equal to the number of port GUIDs actually filled.
+Not all filled entries may be valid. Invalid entries will be 0.
+For example, calling function on computing node with only one port returns a value of 2.
+The value at index zero will be invalid as it is reserved for switches.
 On failure, a negative value is returned.
 .SH "SEE ALSO"
 .BR umad_get_cas_names (3)
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
