From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 06/21] Tidy travis sparse check
Date: Mon, 24 Jul 2017 14:00:14 -0600
Message-ID: <1500926429-31822-7-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

- Use "x$FOO" notation to avoid failures if TRAVIS_COMMIT_RANGE is not
  defined
- Use wget -q to be quieter
- Disable CONST_STRUCT since it does not work

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 buildlib/travis-checkpatch | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/buildlib/travis-checkpatch b/buildlib/travis-checkpatch
index 8f80d025a96828..ef7df4e62df6d6 100755
--- a/buildlib/travis-checkpatch
+++ b/buildlib/travis-checkpatch
@@ -6,13 +6,13 @@
 # And the rdma-core code is not mature enough to be warning safe
 # set -e
 
-if [ $TRAVIS_COMMIT_RANGE != "" ]; then
+if [ "x$TRAVIS_COMMIT_RANGE" != "x" ]; then
 	cd buildlib/
-	wget https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/scripts/checkpatch.pl
-	wget https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/scripts/spelling.txt
+	wget -q https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/scripts/checkpatch.pl \
+	        https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/scripts/spelling.txt
 	DIR_FOR_PATCHES_TO_CHECK=$(mktemp -d)
 	git format-patch --no-cover-letter $TRAVIS_COMMIT_RANGE -o $DIR_FOR_PATCHES_TO_CHECK/
-	CHECKPATCH_OPT="--no-tree --ignore PREFER_KERNEL_TYPES,FILE_PATH_CHANGES,EXECUTE_PERMISSIONS,USE_NEGATIVE_ERRNO $DIR_FOR_PATCHES_TO_CHECK/*"
+	CHECKPATCH_OPT="--no-tree --ignore PREFER_KERNEL_TYPES,FILE_PATH_CHANGES,EXECUTE_PERMISSIONS,USE_NEGATIVE_ERRNO,CONST_STRUCT $DIR_FOR_PATCHES_TO_CHECK/*"
 	perl checkpatch.pl $CHECKPATCH_OPT
 	if [ $? -ne 0 ]; then
 		# We rerun checkpatch to simplify parsing and to understand if we failed for errors
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
