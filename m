From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] saquery.c: Fix handling of cpi and ClassPortInfo
 options
Date: Wed, 05 Nov 2014 15:21:55 -0500
Message-ID: <545A86E3.4050000@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Need to check if query_type is CLASS_PORT_INFO
in order to handle saquery [cpi | ClassPortInfo].
Otherwise, it just dumps ClassPortInfo attribute
as all 0s.

Note that saquery -c works fine because it
set command to SAQUERY_CMD_CLASS_PORT_INFO.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/saquery.c b/src/saquery.c
index 0f39064..1af3401 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -1869,6 +1869,7 @@ int main(int argc, char **argv)
 		params.dlid = get_lid(h, dst_lid);
 
 	if (command == SAQUERY_CMD_CLASS_PORT_INFO ||
+	    query_type == CLASS_PORT_INFO ||
 	    query_type == IB_SA_ATTR_SWITCHINFORECORD)
 		sa_cpi_required = 1;
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
