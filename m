From: Line.Holen-UdXhSnd/wVw@public.gmane.org
Subject: [PATCHv2] osm_ucast_ftree.c missing reset of ca_ports
Date: Fri, 16 Oct 2009 15:40:36 +0200
Message-ID: <4AD877D4.1070706@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ca_ports is not reset before startup of ftree routing

Signed-off-by: Line Holen <Line.Holen-UdXhSnd/wVw@public.gmane.org>

---

diff --git a/opensm/opensm/osm_ucast_ftree.c b/opensm/opensm/osm_ucast_ftree.c
index 885c834..5b403f7 100644
--- a/opensm/opensm/osm_ucast_ftree.c
+++ b/opensm/opensm/osm_ucast_ftree.c
@@ -1002,6 +1002,7 @@ static void fabric_clear(ftree_fabric_t * p_ftree)

        p_ftree->leaf_switches_num = 0;
        p_ftree->cn_num = 0;
+       p_ftree->ca_ports = 0;
        p_ftree->leaf_switch_rank = 0;
        p_ftree->max_switch_rank = 0;
        p_ftree->max_cn_per_leaf = 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
