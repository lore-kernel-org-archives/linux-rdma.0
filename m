From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm/libibvendor: osm_vendor_get_all_port_attr include
 sm_sl value in port attribute struct
Date: Thu, 21 Feb 2013 13:44:13 -0800
Message-ID: <20130221134413.03e68d1eff76bd642e6b7b33@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 libvendor/osm_vendor_ibumad.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
index c33ad2e..bcaf238 100644
--- a/libvendor/osm_vendor_ibumad.c
+++ b/libvendor/osm_vendor_ibumad.c
@@ -646,6 +646,7 @@ osm_vendor_get_all_port_attr(IN osm_vendor_t * const p_vend,
 				attr->lid = ca.ports[j]->base_lid;
 				attr->port_num = ca.ports[j]->portnum;
 				attr->sm_lid = ca.ports[j]->sm_lid;
+				attr->sm_sl = ca.ports[j]->sm_sl;
 				attr->link_state = ca.ports[j]->state;
 				if (attr->num_pkeys && attr->p_pkey_table) {
 					if (attr->num_pkeys > ca.ports[j]->pkeys_size)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
