From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCHv2 rdma-core] Documentation: add documentation about stable
 branches
Date: Tue, 14 Nov 2017 11:40:09 +0100
Message-ID: <bd0fcd8a-bbe2-c737-8818-40193d67a5f3@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add doc file to detail the stable- process: release, submission.

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
Cc: stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org # v15
---
Changes in v2:
* Add missing new line at EOF
* Remove UTF8 quotes
* Add a line on ABI (will be extented once automated ABI checks are submitted)
* Add Cc for stable-v15 to set a good example

 Documentation/stable.md | 65 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)
 create mode 100644 Documentation/stable.md

diff --git a/Documentation/stable.md b/Documentation/stable.md
new file mode 100644
index 00000000..39330038
--- /dev/null
+++ b/Documentation/stable.md
@@ -0,0 +1,65 @@
+# Stable Branch Release
+
+
+## General
+
+Current Maintainer: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
+
+Upstream rdma-core is considered stable after each mainline release.
+Branched stable releases, off a mainline release, are on as-needed basis and limited to bug fixes only.
+
+All bug fixes are to be backported from mainline and applied by stable branch maintainer.
+
+Branched stable releases will append an additional release number (e.g. 15.1) and will ensure that Travis CI reports a successful build.
+
+Regular stable releases will be generated at the same time as mainline releases.
+Additional stable releases can be generated if the need arise (Needed by distributions or OFED).
+
+## Patch Rules
+
+ * It must be obviously correct and tested.
+ * It cannot be bigger than 100 lines, with context.
+ * It must fix only one thing.
+ * It must fix a real bug that bothers people (not a, "This could be a problem..." type thing).
+ * ABI must NOT be changed by the fix.
+
+## Submitting to the stable branch
+
+Submissions to the stable branch follow the same process as [kernel-stable](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/stable-kernel-rules.rst).
+
+### Option 1
+
+Patches sent to master should add the tag:
+
+   `Cc: stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org`
+
+in the sign-off area. Once the patch is merged, it will be applied to the stable tree
+without anything else needing to be done by the author or subsystem maintainer.
+
+If the patch should be applied to more than one release, add the info version as such:
+
+   `Cc: stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org # v15.1 v14`
+
+
+### Option 2
+
+After the patch has been merged to master, send an email to
+stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org containing the subject of the patch, the commit ID,
+why you think it should be applied, and what rdma-core version you wish it to
+be applied to.
+
+### Option 3
+
+Send the patch, after verifying that it follows the above rules, to stable-Xl5UnYtxxKxKjwt+cz+3dw@public.gmane.org
+You must note the upstream commit ID in the changelog of your submission,
+ as well as the rdma-core version you wish it to be applied to.
+
+Option 1 is strongly preferred, is the easiest and most common.
+Option 2 and Option 3 are more useful if the patch isn’t deemed worthy at the time it is applied to a public git tree (for instance, because it deserves more regression testing first).
+Option 3 is especially useful if the patch needs some special handling to apply to an older version.
+
+Note that for Option 3, if the patch deviates from the original upstream patch (for example because it had to be backported) this must be very clearly documented and justified in the patch description.
+
+## Versioning
+
+See versioning.md for setting package version on a stable branch.
-- 
2.15.0.169.g3d3eebb67.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
