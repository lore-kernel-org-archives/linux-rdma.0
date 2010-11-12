From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 04/13] opensm: Fill in default QoS values at last
 possible moment.
Date: Fri, 12 Nov 2010 15:11:13 -0700
Message-ID: <1289599882-15165-5-git-send-email-jaschut@sandia.gov>
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

The comments for struct osm_qos_options in osm_subnet.h describe values that
flag default QoS values for struct members.  osm_qos_options structs are
initialized with these flag values in subn_init_qos_options(), but they are
overwritten via osm_subn_verify_config() with the actual default values.

It turns out to be easy to wait until qos_build_config() to detect the flag
values and use the actual default values as needed.   osm_qos_setup() +
qos_build_config() already had code that set unconfigured CA, switch port,
and router specific QoS parameters from configured default QoS parameters,
so that duplicate code can be removed from osm_subn_verify_config().

In addition to code simplification, such delay in replacing default flag
values with the actual default values makes it possible for a routing
engine to detect that configured rather than default values were used.

For example, torus-2QoS can never use any configured qos_sl2vl values,
but should only warn if such are configured.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_qos.c    |   55 +++++++++++++++++++++++++++-------
 opensm/opensm/osm_subnet.c |   70 ++++++++++++++------------------------------
 2 files changed, 66 insertions(+), 59 deletions(-)

diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
index ba198a0..afea7bb 100644
--- a/opensm/opensm/osm_qos.c
+++ b/opensm/opensm/osm_qos.c
@@ -376,7 +376,7 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 /*
  *  QoS config stuff
  */
-static int parse_one_unsigned(char *str, char delim, unsigned *val)
+static int parse_one_unsigned(const char *str, char delim, unsigned *val)
 {
 	char *end;
 	*val = strtoul(str, &end, 0);
@@ -385,10 +385,10 @@ static int parse_one_unsigned(char *str, char delim, unsigned *val)
 	return (int)(end - str);
 }
 
-static int parse_vlarb_entry(char *str, ib_vl_arb_element_t * e)
+static int parse_vlarb_entry(const char *str, ib_vl_arb_element_t * e)
 {
 	unsigned val;
-	char *p = str;
+	const char *p = str;
 	p += parse_one_unsigned(p, ':', &val);
 	e->vl = val % 15;
 	p += parse_one_unsigned(p, ',', &val);
@@ -396,10 +396,10 @@ static int parse_vlarb_entry(char *str, ib_vl_arb_element_t * e)
 	return (int)(p - str);
 }
 
-static int parse_sl2vl_entry(char *str, uint8_t * raw)
+static int parse_sl2vl_entry(const char *str, uint8_t * raw)
 {
 	unsigned val1, val2;
-	char *p = str;
+	const char *p = str;
 	p += parse_one_unsigned(p, ',', &val1);
 	p += parse_one_unsigned(p, ',', &val2);
 	*raw = (val1 << 4) | (val2 & 0xf);
@@ -410,18 +410,36 @@ static void qos_build_config(struct qos_config *cfg, osm_qos_options_t * opt,
 			     osm_qos_options_t * dflt)
 {
 	int i;
-	char *p;
+	const char *p;
 
 	memset(cfg, 0, sizeof(*cfg));
 
-	cfg->max_vls = opt->max_vls > 0 ? opt->max_vls : dflt->max_vls;
+	if (opt->max_vls > 0)
+		cfg->max_vls = opt->max_vls;
+	else {
+		if (dflt->max_vls > 0)
+			cfg->max_vls = dflt->max_vls;
+		else
+			cfg->max_vls = OSM_DEFAULT_QOS_MAX_VLS;
+	}
 
 	if (opt->high_limit >= 0)
 		cfg->vl_high_limit = (uint8_t) opt->high_limit;
-	else
-		cfg->vl_high_limit = (uint8_t) dflt->high_limit;
+	else {
+		if (dflt->high_limit >= 0)
+			cfg->vl_high_limit = (uint8_t) dflt->high_limit;
+		else
+			cfg->vl_high_limit = (uint8_t) OSM_DEFAULT_QOS_HIGH_LIMIT;
+	}
 
-	p = opt->vlarb_high ? opt->vlarb_high : dflt->vlarb_high;
+	if (opt->vlarb_high)
+		p = opt->vlarb_high;
+	else {
+		if (dflt->vlarb_high)
+			p = dflt->vlarb_high;
+		else
+			p = OSM_DEFAULT_QOS_VLARB_HIGH;
+	}
 	for (i = 0; i < 2 * IB_NUM_VL_ARB_ELEMENTS_IN_BLOCK; i++) {
 		p += parse_vlarb_entry(p,
 				       &cfg->vlarb_high[i /
@@ -430,7 +448,14 @@ static void qos_build_config(struct qos_config *cfg, osm_qos_options_t * opt,
 						IB_NUM_VL_ARB_ELEMENTS_IN_BLOCK]);
 	}
 
-	p = opt->vlarb_low ? opt->vlarb_low : dflt->vlarb_low;
+	if (opt->vlarb_low)
+		p = opt->vlarb_low;
+	else {
+		if (dflt->vlarb_low)
+			p = dflt->vlarb_low;
+		else
+			p = OSM_DEFAULT_QOS_VLARB_LOW;
+	}
 	for (i = 0; i < 2 * IB_NUM_VL_ARB_ELEMENTS_IN_BLOCK; i++) {
 		p += parse_vlarb_entry(p,
 				       &cfg->vlarb_low[i /
@@ -440,6 +465,14 @@ static void qos_build_config(struct qos_config *cfg, osm_qos_options_t * opt,
 	}
 
 	p = opt->sl2vl ? opt->sl2vl : dflt->sl2vl;
+	if (opt->sl2vl)
+		p = opt->sl2vl;
+	else {
+		if (dflt->sl2vl)
+			p = dflt->sl2vl;
+		else
+			p = OSM_DEFAULT_QOS_SL2VL;
+	}
 	for (i = 0; i < IB_MAX_NUM_VLS / 2; i++)
 		p += parse_sl2vl_entry(p, &cfg->sl2vl.raw_vl_by_sl[i]);
 }
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index bc34a0f..be406ac 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -636,15 +636,6 @@ osm_mgrp_t *osm_get_mgrp_by_mgid(IN osm_subn_t * subn, IN ib_gid_t * mgid)
 	return NULL;
 }
 
-static void subn_set_default_qos_options(IN osm_qos_options_t * opt)
-{
-	opt->max_vls = OSM_DEFAULT_QOS_MAX_VLS;
-	opt->high_limit = OSM_DEFAULT_QOS_HIGH_LIMIT;
-	opt->vlarb_high = OSM_DEFAULT_QOS_VLARB_HIGH;
-	opt->vlarb_low = OSM_DEFAULT_QOS_VLARB_LOW;
-	opt->sl2vl = OSM_DEFAULT_QOS_SL2VL;
-}
-
 static void subn_init_qos_options(osm_qos_options_t *opt, osm_qos_options_t *f)
 {
 	opt->max_vls = 0;
@@ -911,38 +902,37 @@ static ib_api_status_t parse_prefix_routes_file(IN osm_subn_t * p_subn)
 	return (errors == 0) ? IB_SUCCESS : IB_ERROR;
 }
 
-static void subn_verify_max_vls(unsigned *max_vls, const char *prefix, unsigned dflt)
+static void subn_verify_max_vls(unsigned *max_vls, const char *prefix)
 {
 	if (!*max_vls || *max_vls > 15) {
 		if (*max_vls)
 			log_report(" Invalid Cached Option: %s_max_vls=%u: "
 				   "Using Default = %u\n",
-				   prefix, *max_vls, dflt);
-		*max_vls = dflt;
+				   prefix, *max_vls, OSM_DEFAULT_QOS_MAX_VLS);
+		*max_vls = 0;
 	}
 }
 
-static void subn_verify_high_limit(int *high_limit, const char *prefix, int dflt)
+static void subn_verify_high_limit(int *high_limit, const char *prefix)
 {
 	if (*high_limit < 0 || *high_limit > 255) {
 		if (*high_limit > 255)
 			log_report(" Invalid Cached Option: %s_high_limit=%d: "
 				   "Using Default: %d\n",
-				   prefix, *high_limit, dflt);
-		*high_limit = dflt;
+				   prefix, *high_limit,
+				   OSM_DEFAULT_QOS_HIGH_LIMIT);
+		*high_limit = -1;
 	}
 }
 
 static void subn_verify_vlarb(char **vlarb, const char *prefix,
-			      const char *suffix, char *dflt)
+			      const char *suffix)
 {
 	char *str, *tok, *end, *ptr;
 	int count = 0;
 
-	if (*vlarb == NULL) {
-		*vlarb = strdup(dflt);
+	if (*vlarb == NULL)
 		return;
-	}
 
 	str = strdup(*vlarb);
 
@@ -1001,15 +991,13 @@ static void subn_verify_vlarb(char **vlarb, const char *prefix,
 	free(str);
 }
 
-static void subn_verify_sl2vl(char **sl2vl, const char *prefix, char *dflt)
+static void subn_verify_sl2vl(char **sl2vl, const char *prefix)
 {
 	char *str, *tok, *end, *ptr;
 	int count = 0;
 
-	if (*sl2vl == NULL) {
-		*sl2vl = strdup(dflt);
+	if (*sl2vl == NULL)
 		return;
-	}
 
 	str = strdup(*sl2vl);
 
@@ -1039,14 +1027,13 @@ static void subn_verify_sl2vl(char **sl2vl, const char *prefix, char *dflt)
 	free(str);
 }
 
-static void subn_verify_qos_set(osm_qos_options_t *set, const char *prefix,
-				osm_qos_options_t *dflt)
+static void subn_verify_qos_set(osm_qos_options_t *set, const char *prefix)
 {
-	subn_verify_max_vls(&set->max_vls, prefix, dflt->max_vls);
-	subn_verify_high_limit(&set->high_limit, prefix, dflt->high_limit);
-	subn_verify_vlarb(&set->vlarb_low, prefix, "low", dflt->vlarb_low);
-	subn_verify_vlarb(&set->vlarb_high, prefix, "high", dflt->vlarb_high);
-	subn_verify_sl2vl(&set->sl2vl, prefix, dflt->sl2vl);
+	subn_verify_max_vls(&set->max_vls, prefix);
+	subn_verify_high_limit(&set->high_limit, prefix);
+	subn_verify_vlarb(&set->vlarb_low, prefix, "low");
+	subn_verify_vlarb(&set->vlarb_high, prefix, "high");
+	subn_verify_sl2vl(&set->sl2vl, prefix);
 }
 
 int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
@@ -1102,24 +1089,11 @@ int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
 	}
 
 	if (p_opts->qos) {
-		osm_qos_options_t dflt;
-
-		/* the default options in qos_options must be correct.
-		 * every other one need not be, b/c those will default
-		 * back to whatever is in qos_options.
-		 */
-
-		subn_set_default_qos_options(&dflt);
-
-		subn_verify_qos_set(&p_opts->qos_options, "qos", &dflt);
-		subn_verify_qos_set(&p_opts->qos_ca_options, "qos_ca",
-				    &p_opts->qos_options);
-		subn_verify_qos_set(&p_opts->qos_sw0_options, "qos_sw0",
-				    &p_opts->qos_options);
-		subn_verify_qos_set(&p_opts->qos_swe_options, "qos_swe",
-				    &p_opts->qos_options);
-		subn_verify_qos_set(&p_opts->qos_rtr_options, "qos_rtr",
-				    &p_opts->qos_options);
+		subn_verify_qos_set(&p_opts->qos_options, "qos");
+		subn_verify_qos_set(&p_opts->qos_ca_options, "qos_ca");
+		subn_verify_qos_set(&p_opts->qos_sw0_options, "qos_sw0");
+		subn_verify_qos_set(&p_opts->qos_swe_options, "qos_swe");
+		subn_verify_qos_set(&p_opts->qos_rtr_options, "qos_rtr");
 	}
 
 #ifdef ENABLE_OSM_PERF_MGR
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
