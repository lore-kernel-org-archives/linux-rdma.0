From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 2/3] debian: Override intentional WantedBy lintian warning
Date: Thu, 15 Feb 2018 12:08:41 +0100
Message-ID: <20180215110842.6375-2-benjamin.drung@profitbricks.com>
References: <20180215110842.6375-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180215110842.6375-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Lintian complains about unusual WantedBy= relationship in systemd
service files. These WantedBy= relationships are intentional. Therefore
override the lintian warnings.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/ibacm.lintian-overrides    | 2 ++
 debian/srptools.lintian-overrides | 2 ++
 2 files changed, 4 insertions(+)
 create mode 100644 debian/ibacm.lintian-overrides
 create mode 100644 debian/srptools.lintian-overrides

diff --git a/debian/ibacm.lintian-overrides b/debian/ibacm.lintian-overrides
new file mode 100644
index 00000000..66fffd93
--- /dev/null
+++ b/debian/ibacm.lintian-overrides
@@ -0,0 +1,2 @@
+# The wantedby target rdma-hw.target is intentional (see rdma-core)
+ibacm: systemd-service-file-refers-to-unusual-wantedby-target lib/systemd/system/ibacm.service rdma-hw.target
diff --git a/debian/srptools.lintian-overrides b/debian/srptools.lintian-overrides
new file mode 100644
index 00000000..86788994
--- /dev/null
+++ b/debian/srptools.lintian-overrides
@@ -0,0 +1,2 @@
+# The wantedby target remote-fs-pre.target is intentional
+srptools: systemd-service-file-refers-to-unusual-wantedby-target lib/systemd/system/*.service remote-fs-pre.target
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
