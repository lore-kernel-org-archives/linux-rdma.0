From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/2] infiniband-diags/ibqueryerrors: Change realloc of
 suppressed fields to a static array
Date: Tue, 3 Nov 2009 20:22:38 -0800
Message-ID: <20091103202238.4662c14d.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sasha,

2 clean up patches which apply in order.

Ira

From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 3 Nov 2009 13:19:33 -0800
Subject: [PATCH] infiniband-diags/ibqueryerrors: Change realloc of suppressed fields to a static array

	Realloc size was wrong causing a core when enough errors were
	suppressed.  Reproduced by running:

	ibqueryerrors -c -s RcvSwRelayErrors,LinkDowned,VL15Dropped,XmtWait,SymbolErrors,LinkRecovers,RcvErrors

	Change this to a static array which also removes the need to free
	memory.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/src/ibqueryerrors.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index f83f29e..43698d2 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -61,8 +61,9 @@ int data_counters = 0;
 int port_config = 0;
 uint64_t node_guid = 0;
 char *node_guid_str = NULL;
+#define SUP_MAX 64
 int sup_total = 0;
-enum MAD_FIELDS *suppressed_fields = NULL;
+enum MAD_FIELDS suppressed_fields[SUP_MAX];
 char *dr_path = NULL;
 uint8_t node_type_to_print = 0;
 unsigned clear_errors = 0, clear_counts = 0;
@@ -180,22 +181,19 @@ static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
 static int suppress(enum MAD_FIELDS field)
 {
 	int i = 0;
-	if (suppressed_fields)
-		for (i = 0; i < sup_total; i++)
-			if (field == suppressed_fields[i])
-				return 1;
+	for (i = 0; i < sup_total; i++)
+		if (field == suppressed_fields[i])
+			return 1;
 	return 0;
 }
 
 static void report_suppressed(void)
 {
 	int i = 0;
-	if (suppressed_fields) {
-		printf("Suppressing:");
-		for (i = 0; i < sup_total; i++)
-			printf(" %s", mad_field_name(suppressed_fields[i]));
-		printf("\n");
-	}
+	printf("Suppressing:");
+	for (i = 0; i < sup_total; i++)
+		printf(" %s", mad_field_name(suppressed_fields[i]));
+	printf("\n");
 }
 
 static void print_results(char *node_name, ibnd_node_t * node, uint8_t * pc,
@@ -381,9 +379,12 @@ void print_node(ibnd_node_t * node, void *user_data)
 
 static void add_suppressed(enum MAD_FIELDS field)
 {
-	suppressed_fields = realloc(suppressed_fields, sizeof(enum MAD_FIELDS));
-	suppressed_fields[sup_total] = field;
-	sup_total++;
+	if (sup_total >= SUP_MAX) {
+		IBWARN("Maximum (%d) fields have been suppressed; skipping %s",
+			sup_total, mad_field_name(field));
+		return;
+	}
+	suppressed_fields[sup_total++] = field;
 }
 
 static void calculate_suppressed_fields(char *str)
@@ -492,6 +493,7 @@ int main(int argc, char **argv)
 	};
 	char usage_args[] = "";
 
+	memset(suppressed_fields, 0, sizeof suppressed_fields);
 	ibdiag_process_opts(argc, argv, NULL, "scnSrRDGL", opts, process_opt,
 			    usage_args, NULL);
 
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
