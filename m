From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCHv2] opensm: Add infrastructure  support for PortInfo
	IsMulticastPkeyTrapSuppressionSupported
Date: Tue, 13 Oct 2009 13:34:54 -0400
Message-ID: <20091013173454.GA30487@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Per published MgtWG errata RefID 4576

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
Changes since v1:
Don't reset reserved bits packed with subnet timeout

diff --git a/opensm/include/iba/ib_types.h b/opensm/include/iba/ib_types.h
index aa566f7..7a54d9e 100644
--- a/opensm/include/iba/ib_types.h
+++ b/opensm/include/iba/ib_types.h
@@ -4431,7 +4431,7 @@ typedef struct _ib_port_info {
 	ib_net16_t p_key_violations;
 	ib_net16_t q_key_violations;
 	uint8_t guid_cap;
-	uint8_t subnet_timeout;	/* cli_rereg(1b), resrv(2b), timeout(5b) */
+	uint8_t subnet_timeout;	/* cli_rereg(1b), mcast_pkey_trap_suppr(1b), resrv(1b), timeout(5b) */
 	uint8_t resp_time_value;
 	uint8_t error_threshold; /* local phy errors(4b), overrun errors(4b) */
 	ib_net16_t max_credit_hint;
@@ -5281,7 +5281,7 @@ ib_port_info_set_timeout(IN ib_port_info_t * const p_pi,
 {
 	CL_ASSERT(timeout <= 0x1F);
 	p_pi->subnet_timeout =
-	    (uint8_t) ((p_pi->subnet_timeout & 0x80) | (timeout & 0x1F));
+	    (uint8_t) ((p_pi->subnet_timeout & 0xE0) | (timeout & 0x1F));
 }
 
 /*
@@ -5316,7 +5316,7 @@ ib_port_info_set_client_rereg(IN ib_port_info_t * const p_pi,
 	CL_ASSERT(client_rereg <= 0x1);
 	p_pi->subnet_timeout =
 	    (uint8_t) ((p_pi->
-			subnet_timeout & 0x1F) | ((client_rereg << 7) & 0x80));
+			subnet_timeout & 0x5F) | ((client_rereg << 7) & 0x80));
 }
 
 /*
@@ -5335,6 +5335,42 @@ ib_port_info_set_client_rereg(IN ib_port_info_t * const p_pi,
 * SEE ALSO
 *********/
 
+/****f* IBA Base: Types/ib_port_info_set_mcast_pkey_trap_suppress
+* NAME
+*	ib_port_info_set_mcast_pkey_trap_suppress
+*
+* DESCRIPTION
+*	Sets the encoded multicast pkey trap suppresion enabled bit value
+*	in the PortInfo attribute.
+*
+* SYNOPSIS
+*/
+static inline void OSM_API
+ib_port_info_set_mcast_pkey_trap_suppress(IN ib_port_info_t * const p_pi,
+					  IN const uint8_t trap_suppress)
+{
+	CL_ASSERT(trap_suppress <= 0x1);
+	p_pi->subnet_timeout =
+	    (uint8_t) ((p_pi->subnet_timeout & 0xBF) | (trap_suppress << 6));
+}
+
+/*
+* PARAMETERS
+*	p_pi
+*		[in] Pointer to a PortInfo attribute.
+*
+*	trap_suppress
+*		[in] Multicast pkey trap suppresion enabled value to set
+*		     (either 1 or 0).
+*
+* RETURN VALUES
+*	None.
+*
+* NOTES
+*
+* SEE ALSO
+*********/
+
 /****f* IBA Base: Types/ib_port_info_get_timeout
 * NAME
 *	ib_port_info_get_timeout
@@ -5391,6 +5427,35 @@ ib_port_info_get_client_rereg(IN ib_port_info_t const *p_pi)
 * SEE ALSO
 *********/
 
+/****f* IBA Base: Types/ib_port_info_get_mcast_pkey_trap_suppress
+* NAME
+*	ib_port_info_get_mcast_pkey_trap_suppress
+*
+* DESCRIPTION
+*	Gets the encoded multicast pkey trap suppresion enabled bit value
+*	in the PortInfo attribute.
+*
+* SYNOPSIS
+*/
+static inline uint8_t OSM_API
+ib_port_info_get_mcast_pkey_trap_suppress(IN ib_port_info_t const *p_pi)
+{
+	return ((p_pi->subnet_timeout & 0x40) >> 6);
+}
+
+/*
+* PARAMETERS
+*	p_pi
+*		[in] Pointer to a PortInfo attribute.
+*
+* RETURN VALUES
+*	Multicast PKey trap suppression enabled value (either 1 or 0).
+*
+* NOTES
+*
+* SEE ALSO
+*********/
+
 /****f* IBA Base: Types/ib_port_info_set_hoq_lifetime
 * NAME
 *	ib_port_info_set_hoq_lifetime
diff --git a/opensm/opensm/osm_helper.c b/opensm/opensm/osm_helper.c
index 2b1e5ef..40dea10 100644
--- a/opensm/opensm/osm_helper.c
+++ b/opensm/opensm/osm_helper.c
@@ -823,6 +823,7 @@ void osm_dump_port_info(IN osm_log_t * p_log, IN ib_net64_t node_guid,
 			"\t\t\t\tq_key_violations........0x%X\n"
 			"\t\t\t\tguid_cap................0x%X\n"
 			"\t\t\t\tclient_reregister.......0x%X\n"
+			"\t\t\t\tmcast_pkey_trap_suppr...0x%X\n"
 			"\t\t\t\tsubnet_timeout..........0x%X\n"
 			"\t\t\t\tresp_time_value.........0x%X\n"
 			"\t\t\t\terror_threshold.........0x%X\n"
@@ -849,6 +850,7 @@ void osm_dump_port_info(IN osm_log_t * p_log, IN ib_net64_t node_guid,
 			cl_ntoh16(p_pi->p_key_violations),
 			cl_ntoh16(p_pi->q_key_violations), p_pi->guid_cap,
 			ib_port_info_get_client_rereg(p_pi),
+			ib_port_info_get_mcast_pkey_trap_suppress(p_pi),
 			ib_port_info_get_timeout(p_pi), p_pi->resp_time_value,
 			p_pi->error_threshold, cl_ntoh16(p_pi->max_credit_hint),
 			cl_ntoh32(p_pi->link_rt_latency));
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
