From: Long Li <longli@linuxonhyperv.com>
Subject: [PATCH 2/2] CIFS: Fix a bug with re-sending rdata when transport returning -EAGAIN
Date: Sat,  2 Mar 2019 02:51:46 +0000
Message-ID: <20190302025146.2935-2-longli@linuxonhyperv.com>
References: <20190302025146.2935-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190302025146.2935-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Long Li <longli@microsoft.com>
List-Id: linux-rdma@vger.kernel.org

From: Long Li <longli@microsoft.com>

When sending a rdata, transport may return -EAGAIN. In this case
we should re-obtain credits because the session may have been
reconnected.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/file.c | 51 +++++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 08e73759d6ec..c83ca96f883b 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3335,44 +3335,45 @@ static int cifs_resend_rdata(struct cifs_readdata *rdata,
 	struct TCP_Server_Info *server =
 		tlink_tcon(rdata->cfile->tlink)->ses->server;
 
-	/*
-	 * Wait for credits to resend this rdata.
-	 * Note: we are attempting to resend the whole rdata not in segments
-	 */
 	do {
-		rc = server->ops->wait_mtu_credits(server, rdata->bytes,
+		/*
+		 * Wait for credits to resend this rdata.
+		 * Note: we are attempting to resend the whole rdata not in
+		 * segments
+		 */
+		do {
+			rc = server->ops->wait_mtu_credits(server, rdata->bytes,
 						&rsize, &credits);
 
-		if (rc)
-			goto out;
+			if (rc)
+				goto fail;
 
-		if (rsize < rdata->bytes) {
-			add_credits_and_wake_if(server, &credits, 0);
-			msleep(1000);
-		}
-	} while (rsize < rdata->bytes);
+			if (rsize < rdata->bytes) {
+				add_credits_and_wake_if(server, &credits, 0);
+				msleep(1000);
+			}
+		} while (rsize < rdata->bytes);
 
-	rdata->credits = credits;
-	rc = -EAGAIN;
-	while (rc == -EAGAIN) {
+		rdata->credits = credits;
 		rc = 0;
 		if (rdata->cfile->invalidHandle)
 			rc = cifs_reopen_file(rdata->cfile, true);
 		if (!rc)
 			rc = server->ops->async_readv(rdata);
-	}
 
-	if (!rc) {
-		/* Add to aio pending list */
-		list_add_tail(&rdata->list, rdata_list);
-		return 0;
-	}
+		/* If the read was successfully sent, we are done */
+		if (!rc) {
+			/* Add to aio pending list */
+			list_add_tail(&rdata->list, rdata_list);
+			return 0;
+		}
 
-	add_credits_and_wake_if(server, &rdata->credits, 0);
-out:
-	kref_put(&rdata->refcount,
-		cifs_uncached_readdata_release);
+		/* Roll back credits and retry if needed */
+		add_credits_and_wake_if(server, &rdata->credits, 0);
+	} while (rc == -EAGAIN);
 
+fail:
+	kref_put(&rdata->refcount, cifs_uncached_readdata_release);
 	return rc;
 }
 
-- 
2.17.1
