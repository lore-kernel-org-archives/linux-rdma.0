From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH v2] opensm/osm_console.c: fix memory and file descriptor
	leaks
Date: Tue, 7 Sep 2010 22:30:09 +0300
Message-ID: <4C8692C1.1030503@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---

V2: removed unneeded 'return'

 opensm/opensm/osm_console.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/opensm/opensm/osm_console.c b/opensm/opensm/osm_console.c
index bc7bea3..5407e9a 100644
--- a/opensm/opensm/osm_console.c
+++ b/opensm/opensm/osm_console.c
@@ -1302,12 +1302,12 @@ static void dump_portguid_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 	/* Check we have at least one expression to match */
 	if (p_head_regexp == NULL) {
 		fprintf(out, "No valid expression provided. Aborting\n");
-		return;
+		goto Exit;
 	}

 	if (p_osm->sm.p_subn->need_update != 0) {
 		fprintf(out, "Subnet is not ready yet. Try again later\n");
-		return;
+		goto Free_and_exit;
 	}

 	/* Subnet doesn't need to be updated so we can carry on */
@@ -1333,14 +1333,16 @@ static void dump_portguid_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 	}

 	CL_PLOCK_RELEASE(p_osm->sm.p_lock);
-	if (output != out)
-		fclose(output);

+Free_and_exit:
 	for (; p_head_regexp; p_head_regexp = p_regexp) {
 		p_regexp = p_head_regexp->next;
 		regfree(&p_head_regexp->exp);
 		free(p_head_regexp);
 	}
+Exit:
+	if (output != out)
+		fclose(output);
 }

 static void help_dump_portguid(FILE * out, int detail)
-- 
1.6.2.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
