From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Infiniband: Fix potential NULL d_inode dereference
Date: Tue, 27 Jan 2015 15:01:18 +0000
Message-ID: <20150127150118.24110.99894.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Bryan O'Sullivan <bos-Hl0AACgZOF5l57MIdRCFDg@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Code that does this:

	if (!(d_unhashed(tmp) && tmp->d_inode)) {
		...
		simple_unlink(parent->d_inode, tmp);
	}

is broken because:

	!(d_unhashed(tmp) && tmp->d_inode)

is equivalent to:

	!d_unhashed(tmp) || !tmp->d_inode

so it is possible to get into simple_unlink() with tmp->d_inode == NULL.

simple_unlink(), however, assumes tmp->d_inode cannot be NULL.

I think that what was meant is this:

	!d_unhashed(tmp) && tmp->d_inode

and that the logical-not operator or the final close-bracket was misplaced.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
cc: Bryan O'Sullivan <bos-Hl0AACgZOF5l57MIdRCFDg@public.gmane.org>
cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/hw/ipath/ipath_fs.c |    2 +-
 drivers/infiniband/hw/qib/qib_fs.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_fs.c b/drivers/infiniband/hw/ipath/ipath_fs.c
index 4977082e081f..33c45dfcbd88 100644
--- a/drivers/infiniband/hw/ipath/ipath_fs.c
+++ b/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -277,7 +277,7 @@ static int remove_file(struct dentry *parent, char *name)
 	}
 
 	spin_lock(&tmp->d_lock);
-	if (!(d_unhashed(tmp) && tmp->d_inode)) {
+	if (!d_unhashed(tmp) && tmp->d_inode) {
 		dget_dlock(tmp);
 		__d_drop(tmp);
 		spin_unlock(&tmp->d_lock);
diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
index 81854586c081..d2427640d7e9 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -455,7 +455,7 @@ static int remove_file(struct dentry *parent, char *name)
 	}
 
 	spin_lock(&tmp->d_lock);
-	if (!(d_unhashed(tmp) && tmp->d_inode)) {
+	if (!d_unhashed(tmp) && tmp->d_inode) {
 		__d_drop(tmp);
 		spin_unlock(&tmp->d_lock);
 		simple_unlink(parent->d_inode, tmp);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
