From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [opensm] routing segfault + LMC > 0 routing bug?
Date: Tue, 22 Mar 2011 18:23:32 -0700
Message-ID: <1300843412.3128.135.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-0/oz4moBjoexAarNOAbg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org, alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-0/oz4moBjoexAarNOAbg
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hey Jim, Alex,

Just hit a segfault on the main tree.  It appears patch 

commit 9ddcf3419eade13bdc0a54f93930c49fe67efd63
Author: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Date:   Fri Sep 3 10:43:12 2010 -0600

opensm: Avoid havoc in minhop caused by torus-2QoS persistent use of
osm_port_t:priv.

segfaults opensm on one of our systems w/ updn routing and lmc > 0
(would likely segfault dor, minhop, and maybe others too).  Our system
has older switches that do not support enhanced port zero, thus do not
support LMC > 0.  (I imagine setting lmc_esp0 to FALSE, results in the
same behavior.)  Subsequently even if you set LMC > 0 in your opensm
config file, there can be ports with LMC = 0 and LMC != 0 (e.g. from
HCAs). Subsequently in alloc_ports_priv(), some ports will have priv set
to NULL and some will not.  Because of assumptions in osm_switch.c about
priv != NULL when lmc > 0, we hit a segfault.  The issue didn't exist
before b/c we allocated p_port->priv non-NULL no matter what.

The attached patch fixes the problem w/ updn.  I haven't looked through
all of the 2Qos code thoroughly to figure out the consequences of this
change, so I'm just considering this a starting point for discussion.

In addition, with the possibility that SP0 ports will be LMC = 0, this
code in osm_ucast_mgr.c ucast_mgr_process_tbl() does not look good.

lids_per_port = 1 << p_mgr->p_subn->opt.lmc;
for (i = 0; i < lids_per_port; i++) {
     cl_qlist_t *list = &p_mgr->port_order_list;
     cl_list_item_t *item;
     for (item = cl_qlist_head(list); item != cl_qlist_end(list);
          item = cl_qlist_next(item)) {
          osm_port_t *port = cl_item_obj(item, port, list_item);
          ucast_mgr_process_port(p_mgr, p_sw, port, i);
     }
}

It iterates over all ports with the configured LMC, not the LMC of the
port?  I haven't thought about this too deeply or investigated deeply,
so consider this another starting point for discussion.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-0/oz4moBjoexAarNOAbg
Content-Disposition: attachment; filename=0001-fix-segfault-corner-case-w-updn-routing-and-LMC-0.patch
Content-Type: message/rfc822; name=0001-fix-segfault-corner-case-w-updn-routing-and-LMC-0.patch

From: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 22 Mar 2011 17:36:16 -0700
Subject: [PATCH] fix segfault corner case w/ updn routing and LMC > 0
Message-Id: <1300840996.3128.109.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_ucast_mgr.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index 4019589..211d6e0 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -318,10 +318,6 @@ static void alloc_ports_priv(osm_ucast_mgr_t * mgr)
 	     item = cl_qmap_next(item)) {
 		port = (osm_port_t *) item;
 		lmc = ib_port_info_get_lmc(&port->p_physp->port_info);
-		if (!lmc) {
-			port->priv = NULL;
-			continue;
-		}
 		r = malloc(sizeof(*r) + sizeof(r->guids[0]) * (1 << lmc));
 		if (!r) {
 			OSM_LOG(mgr->p_log, OSM_LOG_ERROR, "ERR 3A09: "
-- 
1.5.4.5


--=-0/oz4moBjoexAarNOAbg--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
