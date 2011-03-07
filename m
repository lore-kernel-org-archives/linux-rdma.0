From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] pensm/osm_qos_parser: QOS parser doesn't work after syntax
 error
Date: Mon, 7 Mar 2011 17:25:32 +0200
Message-ID: <4D74F8EC.3090504@mellanox.co.il>
Reply-To: <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, elid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If there was a syntax error in the QoS policy file,
any subsequent parsing fails, even if the error is fixed.
The reason is that the parser doesn't clean its buffer -
need to clean it explicitly when exiting parsing.

Signed-off-by: Aviad Yehezkel <aviadye-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_qos_parser_l.l |    4 ++++
 opensm/opensm/osm_qos_parser_y.y |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_qos_parser_l.l b/opensm/opensm/osm_qos_parser_l.l
index 4633e0e..559974b 100644
--- a/opensm/opensm/osm_qos_parser_l.l
+++ b/opensm/opensm/osm_qos_parser_l.l
@@ -355,6 +355,10 @@ QUOTED_TEXT             \"[^\"]*\"

 .                   { SAVE_POS; yylval = strdup(yytext); return TK_TEXT;}

+<<EOF>>             {
+                        YY_NEW_FILE;
+                        yyterminate();
+                    }
 %%


diff --git a/opensm/opensm/osm_qos_parser_y.y b/opensm/opensm/osm_qos_parser_y.y
index 7118b79..51f72e3 100644
--- a/opensm/opensm/osm_qos_parser_y.y
+++ b/opensm/opensm/osm_qos_parser_y.y
@@ -149,6 +149,7 @@ extern char * yytext;
 extern int yylex (void);
 extern FILE * yyin;
 extern int errno;
+extern void yyrestart(FILE *input_file);
 int yyparse();

 #define RESET_BUFFER  __parser_tmp_struct_reset()
@@ -2354,7 +2355,10 @@ int osm_qos_parse_policy_file(IN osm_subn_t * p_subn)

   Exit:
     if (yyin)
+    {
+        yyrestart(yyin);
         fclose(yyin);
+    }
     OSM_LOG_EXIT(p_qos_parser_osm_log);
     return res;
 }
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
