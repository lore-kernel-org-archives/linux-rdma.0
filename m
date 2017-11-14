From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH rdma-core 5/5] Documentation: update stable doc about ABI
 reference generation
Date: Tue, 14 Nov 2017 19:58:12 +0100
Message-ID: <4bbfedda-eab7-0320-2a37-e3ecbf1093dc@suse.de>
References: <8306e0d4-3f4f-1d06-74e1-c971fc63f7b8@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8306e0d4-3f4f-1d06-74e1-c971fc63f7b8-l3A5Bk7waGM@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
---
 Documentation/stable.md | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/stable.md b/Documentation/stable.md
index d7ea9822..b7d26c98 100644
--- a/Documentation/stable.md
+++ b/Documentation/stable.md
@@ -63,3 +63,20 @@ Note that for Option 3, if the patch deviates from the original upstream patch (
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
+Note that the ABI must NOT be commited at any point in the master branch.
-- 
2.15.0.168.g9a51f1b30.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
