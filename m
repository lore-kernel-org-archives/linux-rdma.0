From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [PATCH 2/2] fix potential segfault in
	ibnd_node_t destroy path
Date: Fri, 06 Nov 2009 10:14:24 -0800
Message-ID: <1257531264.18550.70.camel@auk31.llnl.gov>
Reply-To: chu11-i2BcT+NCU+M@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-nDFW4bH7vfKjM1mCUWNl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-nDFW4bH7vfKjM1mCUWNl
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hey Sasha,

There is a potential for the ports array in ibnd_node_t to be NULL if
you hit an error during scan and eventually destroy the fabric struct
before returning to the user.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-nDFW4bH7vfKjM1mCUWNl
Content-Disposition: attachment; filename=0002-fix-potential-segfault-in-ibnd_node_t-destroy-path.patch
Content-Type: text/plain; name=0002-fix-potential-segfault-in-ibnd_node_t-destroy-path.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Thu, 5 Nov 2009 15:18:27 -0800
Subject: [PATCH] fix potential segfault in ibnd_node_t destroy path


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/ibnetdisc.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index 62dff93..7ce9a54 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -605,10 +605,12 @@ static void destroy_node(ibnd_node_t * node)
 {
 	int p = 0;
 
-	for (p = 0; p <= node->numports; p++) {
-		free(node->ports[p]);
+	if (node->ports) {
+		for (p = 0; p <= node->numports; p++) {
+			free(node->ports[p]);
+		}
+		free(node->ports);
 	}
-	free(node->ports);
 	free(node);
 }
 
-- 
1.5.4.5


--=-nDFW4bH7vfKjM1mCUWNl--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
