From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 09/21] redhat: Fix duplicated libmlx*.so in redhat packaging
Date: Mon, 24 Jul 2017 14:00:17 -0600
Message-ID: <1500926429-31822-10-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

/usr/lib64/libmlx4.so and 5 were being claimed by both rdma-core-devel.rpm
and libibverbs.rpm

The *.so symlinks belong only in the -devel package.

Fixes: a61f2a6850b54 ("mlx4: Export mlx4 direct verbs interface")
Fixes: 07764bc805ba8 ("mlx5: Export mlx5 direct verbs interface")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 redhat/rdma-core.spec | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index f6cf1027e404e4..673ae0da1e5525 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -366,8 +366,8 @@ rm -rf %{buildroot}/%{_initrddir}/
 %dir %{_libdir}/libibverbs
 %{_libdir}/libibverbs*.so.*
 %{_libdir}/libibverbs/*.so
-%{_libdir}/libmlx5.so*
-%{_libdir}/libmlx4.so*
+%{_libdir}/libmlx5.so.*
+%{_libdir}/libmlx4.so.*
 %config(noreplace) %{_sysconfdir}/libibverbs.d/*.driver
 %doc %{_docdir}/%{name}-%{version}/libibverbs.md
 %doc %{_docdir}/%{name}-%{version}/rxe.md
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
