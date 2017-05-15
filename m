From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH rdma-core 4/5] srp_daemon: Move srp_daemon.service from the redhat directory to the srp_daemon directory
Date: Mon, 15 May 2017 15:47:26 -0700
Message-ID: <20170515224733.29586-5-bart.vanassche@sandisk.com>
References: <20170515224733.29586-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170515224733.29586-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since this systemd unit file works fine on at least one other distro
(openSuSE), move it from the redhat/ directory into the srp_daemon/
directory. Move the code for installing this service from the Red Hat
RPM spec file into srp_daemon/CMakeLists.txt.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 redhat/rdma-core.spec                     | 3 ---
 srp_daemon/CMakeLists.txt                 | 2 ++
 {redhat => srp_daemon}/srp_daemon.service | 0
 3 files changed, 2 insertions(+), 3 deletions(-)
 rename {redhat => srp_daemon}/srp_daemon.service (100%)

diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 1095b2fc..993a6c80 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -273,9 +273,6 @@ bin/ib_acme -D . -O
 install -D -m0644 ibacm_opts.cfg %{buildroot}%{_sysconfdir}/rdma/
 install -D -m0644 redhat/ibacm.service %{buildroot}%{_unitdir}/
 
-# srp_daemon
-install -D -m0644 redhat/srp_daemon.service %{buildroot}%{_unitdir}/
-
 # Delete the package's init.d scripts
 rm -rf %{buildroot}/%{_initrddir}/
 
diff --git a/srp_daemon/CMakeLists.txt b/srp_daemon/CMakeLists.txt
index 726696ed..24e4c30d 100644
--- a/srp_daemon/CMakeLists.txt
+++ b/srp_daemon/CMakeLists.txt
@@ -27,6 +27,8 @@ rdma_subst_install(FILES "srp_daemon.sh.in"
 
 install(FILES srp_daemon.conf DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}")
 
+install(FILES srp_daemon.service DESTINATION "${CMAKE_INSTALL_SYSTEMD_SERVICEDIR}")
+
 # FIXME: The ib init.d file should really be included in rdma-core as well.
 set(RDMA_SERVICE "openibd" CACHE STRING "init.d file service name to order srpd after")
 # NOTE: These defaults are for CentOS, packagers should override.
diff --git a/redhat/srp_daemon.service b/srp_daemon/srp_daemon.service
similarity index 100%
rename from redhat/srp_daemon.service
rename to srp_daemon/srp_daemon.service
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
