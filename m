From: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] ibnetdiscover: add '-f' flag to show full information
 (ports' speed and width).
Date: Thu, 26 Aug 2010 16:14:16 +0300
Message-ID: <4C7668A8.9080806@voltaire.com>
References: <4C6B9A42.9020505@voltaire.com> <20100824040354.GH5837@me>	<4C73B34A.4080508@voltaire.com>	<AANLkTi=V9Xb92KPgqKnFFWzp-izSsHi7c+-HXYBmggYN@mail.gmail.com>	<4C73C8BC.6010702@voltaire.com>	<AANLkTime9OX4EPS_c+pKwnchuVfyLqeLcuX0rXDjOCgR@mail.gmail.com>	<20100825170656.GM5837@me> <4C761B1B.5030804@voltaire.com> <AANLkTimpAQNGo+wzCY8VmnvGf7zfwqm3cak49eZRQs1V@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimpAQNGo+wzCY8VmnvGf7zfwqm3cak49eZRQs1V-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

add '-f' flag to show full information (ports' speed and witdh).
mainly to work with ibsim (using links real speed and width).

Signed-off-by: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/src/ibnetdiscover.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/infiniband-diags/src/ibnetdiscover.c b/infiniband-diags/src/ibnetdiscover.c
index f20058c..92f248b 100644
--- a/infiniband-diags/src/ibnetdiscover.c
+++ b/infiniband-diags/src/ibnetdiscover.c
@@ -77,6 +77,7 @@ static char *diff_cache_file = NULL;
 static unsigned diffcheck_flags = DIFF_FLAG_DEFAULT;
 
 static int report_max_hops = 0;
+static int full_info;
 
 /**
  * Define our own conversion functions to maintain compatibility with the old
@@ -364,6 +365,9 @@ void out_switch_port(ibnd_port_t * port, int group, char *out_prefix)
 		port->remoteport->base_lid,
 		dump_linkwidth_compat(iwidth), dump_linkspeed_compat(ispeed));
 
+	if (full_info)
+		fprintf(f, " s=%d w=%d", ispeed, iwidth);
+
 	if (ibnd_is_xsigo_tca(port->remoteport->guid))
 		fprintf(f, " slot %d", port->portnum);
 	else if (ibnd_is_xsigo_hca(port->remoteport->guid))
@@ -397,13 +401,17 @@ void out_ca_port(ibnd_port_t * port, int group, char *out_prefix)
 				       port->remoteport->node->guid,
 				       port->remoteport->node->nodedesc);
 
-	fprintf(f, "\t\t# lid %d lmc %d \"%s\" lid %d %s%s\n",
+	fprintf(f, "\t\t# lid %d lmc %d \"%s\" lid %d %s%s",
 		port->base_lid, port->lmc, rem_nodename,
 		port->remoteport->node->type == IB_NODE_SWITCH ?
 		port->remoteport->node->smalid :
 		port->remoteport->base_lid,
 		dump_linkwidth_compat(iwidth), dump_linkspeed_compat(ispeed));
 
+	if (full_info)
+		fprintf(f, " s=%d w=%d", ispeed, iwidth);
+	fprintf(f, "\n");
+
 	free(rem_nodename);
 }
 
@@ -926,6 +934,9 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 's':
 		cfg->show_progress = 1;
 		break;
+	case 'f':
+		full_info = 1;
+		break;
 	case 'l':
 		list = LIST_CA_NODE | LIST_SWITCH_NODE | LIST_ROUTER_NODE;
 		break;
@@ -964,6 +975,7 @@ int main(int argc, char **argv)
 	ibnd_fabric_t *diff_fabric = NULL;
 
 	const struct ibdiag_opt opts[] = {
+		{"full", 'f', 0, NULL, "show full information (ports' speed and witdh)"},
 		{"show", 's', 0, NULL, "show more information"},
 		{"list", 'l', 0, NULL, "list of connected nodes"},
 		{"grouping", 'g', 0, NULL, "show grouping"},
-- 
1.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
