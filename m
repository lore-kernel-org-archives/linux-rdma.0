From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH infiniband-diags] Fix the gen_chlog.sh script to support builds in a separate directory
Date: Wed, 14 Jun 2017 12:48:24 +0200
Message-ID: <20170614104824.21599-1-knut.omang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Configuring and building in a separate directory breaks
because gen_chlog.sh assumes it runs from the git tree.
Instead of making this assumption, rather assume the more
generic, that the gen_chlog.sh script itself is located
in the top sourcedir.

With this fix configuring and building in a separate
tree from the source tree works.

Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 gen_chlog.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/gen_chlog.sh b/gen_chlog.sh
index 34dfa24..59a9e1f 100755
--- a/gen_chlog.sh
+++ b/gen_chlog.sh
@@ -10,6 +10,8 @@ if [ "$1" = "--spec" ] ; then
 	spec_format=1
 fi
 
+cd `dirname $0`
+
 GIT_DIR=`git rev-parse --git-dir 2>/dev/null`
 
 test -z "$GIT_DIR" && usage
-- 
2.9.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
