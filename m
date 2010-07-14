From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/umad: Remove unused-but-set variable 'already_dead'
Date: Wed, 14 Jul 2010 13:26:27 -0700
Message-ID: <adaaaptx11o.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/user_mad.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 6babb72..5fa8569 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -1085,7 +1085,6 @@ err_cdev:
 static void ib_umad_kill_port(struct ib_umad_port *port)
 {
 	struct ib_umad_file *file;
-	int already_dead;
 	int id;
 
 	dev_set_drvdata(port->dev,    NULL);
@@ -1103,7 +1102,6 @@ static void ib_umad_kill_port(struct ib_umad_port *port)
 
 	list_for_each_entry(file, &port->file_list, port_list) {
 		mutex_lock(&file->mutex);
-		already_dead = file->agents_dead;
 		file->agents_dead = 1;
 		mutex_unlock(&file->mutex);
 
-- 
1.7.1.1


-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
