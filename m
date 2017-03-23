From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] rpm: BR: python for libmlx5
Date: Wed, 22 Mar 2017 22:12:46 -0400
Message-ID: <20170323021246.35786-1-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The relpath python script added in commit 07764bc805ba requires python to
run, thus we must BuildRequires: python in the rpm spec files, or the
build will fail in minimal environments (such as mock).

Fixes: 07764bc805ba ("mlx5: Export mlx5 direct verbs interface")
CC: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 rdma-core.spec        | 1 +
 redhat/rdma-core.spec | 1 +
 2 files changed, 2 insertions(+)

diff --git a/rdma-core.spec b/rdma-core.spec
index 3f6e73a0..6a280fe1 100644
--- a/rdma-core.spec
+++ b/rdma-core.spec
@@ -19,6 +19,7 @@ BuildRequires: pkgconfig
 BuildRequires: pkgconfig(libnl-3.0)
 BuildRequires: pkgconfig(libnl-route-3.0)
 BuildRequires: valgrind-devel
+BuildRequires: python
 
 # Since we recommend developers use Ninja, so should packagers, for consistency.
 %define CMAKE_FLAGS %{nil}
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 5f6ead42..6b56eae4 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -20,6 +20,7 @@ BuildRequires: pkgconfig(libnl-3.0)
 BuildRequires: pkgconfig(libnl-route-3.0)
 BuildRequires: valgrind-devel
 BuildRequires: systemd
+BuildRequires: python
 
 Requires: dracut, kmod, systemd
 # Red Hat/Fedora previously shipped redhat/ as a stand-alone
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
