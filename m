From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] ibtracert.c: Enable m_key option
Date: Mon, 28 Nov 2016 13:47:53 -0500
Message-ID: <88bd7b9b-c7db-a27a-16a3-68fd5ce37af7@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


m_key option was mistakenly excluded in commit
ced1cd4758638468329392099ee82c6f2650ea0c:

Author: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Date:   Thu May 31 12:11:33 2012 -0700

    infiniband-diags: Allow specification of an mkey to use on the command line
    
    Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
    Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

Signed-off-by: Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/ibtracert.c b/src/ibtracert.c
index d99d0e1..1da3d62 100644
--- a/src/ibtracert.c
+++ b/src/ibtracert.c
@@ -804,7 +804,7 @@ int main(int argc, char **argv)
 		NULL,
 	};
 
-	ibdiag_process_opts(argc, argv, NULL, "DKy", opts, process_opt,
+	ibdiag_process_opts(argc, argv, NULL, "DK", opts, process_opt,
 			    usage_args, usage_examples);
 
 	f = stdout;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
