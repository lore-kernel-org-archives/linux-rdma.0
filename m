From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibnetdiscover: report number of used MADs
Date: Sat, 10 Apr 2010 03:58:19 +0300
Message-ID: <20100410005819.GM4808@me>
References: <20100218124931.4d6ef34b.weiny2@llnl.gov>
 <20100410005245.GH4808@me>
 <20100410005536.GI4808@me>
 <20100410005752.GL4808@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100410005752.GL4808@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


When '--max_hops,-m' option is specified report (in comment) a total
number of used MADs for discovery aside of number of hops.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/src/ibnetdiscover.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/infiniband-diags/src/ibnetdiscover.c b/infiniband-diags/src/ibnetdiscover.c
index 1ff8ef6..32776ad 100644
--- a/infiniband-diags/src/ibnetdiscover.c
+++ b/infiniband-diags/src/ibnetdiscover.c
@@ -444,8 +444,9 @@ int dump_topology(int group, ibnd_fabric_t * fabric)
 
 	fprintf(f, "#\n# Topology file: generated on %s#\n", ctime(&t));
 	if (report_max_hops)
-		fprintf(f, "# Reported max hops discovered: %d\n",
-			fabric->maxhops_discovered);
+		fprintf(f, "# Reported max hops discovered: %u\n"
+			"# Total MADs used: %u\n",
+			fabric->maxhops_discovered, fabric->total_mads_used);
 	fprintf(f, "# Initiated from node %016" PRIx64 " port %016" PRIx64 "\n",
 		fabric->from_node->guid,
 		mad_get_field64(fabric->from_node->info, 0,
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
