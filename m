From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 03/13] opensm/osm_ucast_mgr.c: ensure
 osm_ucast_mgr_process() returns failure when no routing engine runs.
Date: Fri, 12 Nov 2010 15:11:12 -0700
Message-ID: <1289599882-15165-4-git-send-email-jaschut@sandia.gov>
References: <1289599882-15165-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289599882-15165-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If all configured routing engines fail to initialize, the routing engine
list will be empty.  If opensm is also configured for no fallback routing
engine, then osm_ucast_mgr_process() can incorrectly return success even
though no routing engine will run.  The result of that is that heavy
sweeps are attempted in a tight loop, spamming opensm logs and the fabric.

With this fix, heavy sweeps occur only after a trap or the sweep interval,
reducing log spam and making it easier to find the reason for the failure.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_ucast_mgr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_ucast_mgr.c b/opensm/opensm/osm_ucast_mgr.c
index 85495eb..3e9c836 100644
--- a/opensm/opensm/osm_ucast_mgr.c
+++ b/opensm/opensm/osm_ucast_mgr.c
@@ -1086,6 +1086,7 @@ int osm_ucast_mgr_process(IN osm_ucast_mgr_t * p_mgr)
 	    ucast_mgr_setup_all_switches(p_mgr->p_subn) < 0)
 		goto Exit;
 
+	failed = -1;
 	p_osm->routing_engine_used = NULL;
 	while (p_routing_eng) {
 		failed = ucast_mgr_route(p_routing_eng, p_osm);
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
