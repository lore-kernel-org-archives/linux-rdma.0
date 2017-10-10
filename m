From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] checkpatch: Introduce check for format of Fixes line in commit log
Date: Tue, 10 Oct 2017 17:44:27 -0500
Message-ID: <1507675467-24316-1-git-send-email-parav@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Brad Erickson <bradley-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch introduces a format check for 'Fixes' line in commit log
for 12 characters commit id and format for Fixes as ("...").

Its created against linux-rdma Doug's tree [1].

[1] git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Brad Erickson <bradley-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 scripts/checkpatch.pl | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index dd2c262..7d933e4 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2548,6 +2548,14 @@ sub process {
 			      "Remove Gerrit Change-Id's before submitting upstream.\n" . $herecurr);
 		}
 
+# Check for incorrect format for Fixes line in commit log
+		if ($in_commit_log && $line =~ /^\s*Fixes:/i) {
+			if ($line !~ /^\s*Fixes: [a-z0-9]{12} \(\".*?\"\)$/i) {
+				ERROR("FIXES_FORMAT",
+				      "Follow format of Fixes: <12 characters commit id> (\"...\")\n" . $herecurr);
+			}
+		}
+
 # Check if the commit log is in a possible stack dump
 		if ($in_commit_log && !$commit_log_possible_stack_dump &&
 		    ($line =~ /^\s*(?:WARNING:|BUG:)/ ||
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
