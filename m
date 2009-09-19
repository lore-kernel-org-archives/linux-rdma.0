From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_path_record.c: validate multicast membership
Date: Sat, 19 Sep 2009 19:59:24 +0300
Message-ID: <20090919165924.GD13667@me>
References: <20090919165817.GC13667@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090919165817.GC13667@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenIB <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


When PathRecord query has multicast destination and SLID and/or SGID is
specified we need to ensure that this path source port is member of the
destination multicast group.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_sa_path_record.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
index 75d9516..f68be20 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -1488,6 +1488,7 @@ static ib_api_status_t pr_match_mgrp_attributes(IN osm_sa_t * sa,
 	const ib_path_rec_t *p_pr;
 	const ib_sa_mad_t *p_sa_mad;
 	ib_net64_t comp_mask;
+	const osm_port_t *port;
 	ib_api_status_t status = IB_ERROR;
 	uint32_t flow_label;
 	uint8_t sl;
@@ -1501,6 +1502,19 @@ static ib_api_status_t pr_match_mgrp_attributes(IN osm_sa_t * sa,
 	comp_mask = p_sa_mad->comp_mask;
 
 	/* If SGID and/or SLID specified, should validate as member of MC group */
+	if (comp_mask & IB_PR_COMPMASK_SGID) {
+		port = osm_get_port_by_guid(sa->p_subn,
+					    p_pr->sgid.unicast.interface_id);
+		if (!port || !osm_mgrp_get_mcm_port(p_mgrp, port->guid))
+			goto Exit;
+	}
+
+	if (comp_mask & IB_PR_COMPMASK_SLID) {
+		if (osm_get_port_by_base_lid(sa->p_subn, p_pr->slid, &port) ||
+		    !port || !osm_mgrp_get_mcm_port(p_mgrp, port->guid))
+			goto Exit;
+	}
+
 	/* Also, MTU, rate, packet lifetime, and raw traffic requested are not currently checked */
 	if (comp_mask & IB_PR_COMPMASK_PKEY) {
 		if (p_pr->pkey != p_mgrp->mcmember_rec.pkey)
-- 
1.6.5.rc1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
