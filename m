From: Nicolas Morey-Chaisemartin <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>
Subject: [PATCHv2 rdma-core 5/5] Documentation: update stable doc about ABI
 reference generation
Date: Thu, 16 Nov 2017 18:37:47 +0100
Message-ID: <a3f2fbda-714c-dae4-ede0-605e88d504e0@suse.com>
References: <551ccda1-bb8d-45bf-1c7c-22a82fc64efc@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <551ccda1-bb8d-45bf-1c7c-22a82fc64efc-IBi9RG/b67k@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
---
 Documentation/stable.md | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/Documentation/stable.md b/Documentation/stable.md
index d7ea9822..d3eb90f5 100644
--- a/Documentation/stable.md
+++ b/Documentation/stable.md
@@ -56,10 +56,27 @@ You must note the upstream commit ID in the changelog of your submission,
 
 Option 1 is strongly preferred, is the easiest and most common.
 Option 2 and Option 3 are more useful if the patch isnâ€™t deemed worthy at the time it is applied to a public git tree (for instance, because it deserves more regression testing first).
-Option 3 is especially useful if the patch needs some special handling to apply to an older version.
+Option 3 is especially usefu if the patch needs some special handling to apply to an older version.
 
 Note that for Option 3, if the patch deviates from the original upstream patch (for example because it had to be backported) this must be very clearly documented and justified in the patch description.
 
 ## Versioning
 
 See versioning.md for setting package version on a stable branch.
+
+
+## Creating a stable branch
+
+Stable branch should be created from a release tag of the master branch.
+The first thing to do on a master branch is to commit the mainstream release ABI infos
+so that latters patches/fixes can be checked against this reference.
+
+To do that, the creator of the branch should run
+```
+./buildlib/gen-abi
+mv build-abi/ABI buildlib/ABI
+git add buildlib/ABI
+git commit
+```
+
+Note that the ABI must NOT be committed at any point in the master branch.
-- 
2.15.0.168.g9a51f1b30.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
