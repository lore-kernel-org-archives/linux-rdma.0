From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] ibportstate: on/off option is missing in help
Date: Sun, 20 Oct 2013 10:39:23 +0200
Message-ID: <20131020083923.GA24034@r-ufm5-17.mtr.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/ibportstate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/ibportstate.c b/src/ibportstate.c
index 54933c5..bf3c00c 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -388,7 +388,7 @@ int main(int argc, char **argv)
 	uint64_t val;
 	char *endp;
 	char usage_args[] = "<dest dr_path|lid|guid> <portnum> [<op>]\n"
-	    "\nSupported ops: enable, disable, reset, speed, espeed, fdr10,\n"
+	    "\nSupported ops: enable, disable, on, off, reset, speed, espeed, fdr10,\n"
 	    "\twidth, query, down, arm, active, vls, mtu, lid, smlid, lmc,\n"
 	    "\tmkey, mkeylease, mkeyprot\n";
 	const char *usage_examples[] = {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
