From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] infiniband-diags/saquery: Report SA MAD Class specific
 status.
Date: Mon, 02 Nov 2009 11:40:19 +0200
Message-ID: <4AEEA903.4030406@gmail.com>
References: <4AED4241.4000808@gmail.com> <20091101165223.GJ29434@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091101165223.GJ29434@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Report SA MAD Class specific status.

In addition to SM status.

Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/src/saquery.c |   45 ++++++++++++++++++++++++++++++++++++---
 1 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/infiniband-diags/src/saquery.c b/infiniband-diags/src/saquery.c
index 6c44b63..9495cd9 100644
--- a/infiniband-diags/src/saquery.c
+++ b/infiniband-diags/src/saquery.c
@@ -124,6 +124,45 @@ int requested_lid_flag = 0;
 uint64_t requested_guid = 0;
 int requested_guid_flag = 0;
 
+#define SA_ERR_UNKNOWN IB_SA_MAD_STATUS_PRIO_SUGGESTED
+
+const char *ib_sa_error_str[] = {
+	"SA_NO_ERROR",
+	"SA_ERR_NO_RESOURCES",
+	"SA_ERR_REQ_INVALID",
+	"SA_ERR_NO_RECORDS",
+	"SA_ERR_TOO_MANY_RECORDS",
+	"SA_ERR_REQ_INVALID_GID",
+	"SA_ERR_REQ_INSUFFICIENT_COMPONENTS",
+	"SA_ERR_REQ_DENIED",
+	"SA_ERR_STATUS_PRIO_SUGGESTED",
+	"SA_ERR_UNKNOWN"
+};
+
+static inline const char *ib_sa_err_str(IN uint8_t status)
+{
+	if (status > SA_ERR_UNKNOWN)
+		status = SA_ERR_UNKNOWN;
+	return (ib_sa_error_str[status]);
+}
+
+static inline void report_err(int status)
+{
+	int st = status & 0xff;
+	char sm_err_str[64] = { 0 };
+	char sa_err_str[64] = { 0 };
+
+	if (st)
+		sprintf(sm_err_str, " SM(%s)", ib_get_err_str(st));
+
+	st = status >> 8;
+	if (st)
+		sprintf(sa_err_str, " SA(%s)", ib_sa_err_str(st));
+
+	fprintf(stderr, "ERROR: Query result returned 0x%04x, %s%s\n", 
+		status, sm_err_str, sa_err_str);
+}
+
 static int sa_query(struct bind_handle *h, uint8_t method,
 		    uint16_t attr, uint32_t mod, uint64_t comp_mask,
 		    uint64_t sm_key, void *data)
@@ -794,8 +833,7 @@ static int get_any_records(bind_handle_t h,
 	}
 
 	if (result.status != IB_SUCCESS) {
-		fprintf(stderr, "Query result returned: %s\n",
-			ib_get_err_str(result.status));
+		report_err(result.status);
 		return result.status;
 	}
 
@@ -1009,8 +1047,7 @@ static int get_print_class_port_info(bind_handle_t h)
 		return ret;
 	}
 	if (result.status != IB_SUCCESS) {
-		fprintf(stderr, "ERROR: Query result returned: %s\n",
-			ib_get_err_str(result.status));
+		report_err(result.status);
 		return (result.status);
 	}
 	dump_results(&result, dump_class_port_info);
-- 
1.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
