From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core v3] redhat/spec: further cleanups to
 depdendencies, descriptions, formatting
Date: Mon, 9 Jan 2017 15:36:31 -0700
Message-ID: <20170109223631.GB10850@obsidianresearch.com>
References: <20161222181404.57469-1-jarod@redhat.com>
 <20170109213910.31871-1-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170109213910.31871-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 09, 2017 at 04:39:10PM -0500, Jarod Wilson wrote:
> These are numerous additional little fixups for the Fedora/Red Hat spec
> file, stemming from Fedora package review.
> 
> - Per https://fedoraproject.org/wiki/Packaging:Systemd it seems we need to
>   have systemd as a BuildRequires for %{_unitdir} to evaluate properly.
> 
> - Add explicit dependencies on kmod, and systemd, because in the world of
>   containers and some virt guests, these aren't automatically pulled in,
>   due to not having a kernel installed in the container or guest.
> 
> - Add missing Requires to rdma-core-devel on each sub-package it provides
>   devel headers and libs for
> 
> - Update summary of libibverbs to mention RoCE too
> 
> - Add requirement on logrotate to srp_daemon

I thought we agreed to just dump the rsyslog stuff?

>From 304bbeadf79efe01e8db8230e21d812e1fec152f Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Mon, 9 Jan 2017 15:34:44 -0700
Subject: [PATCH] srp: Do no include example log rsyslog configuration

Distros are now using systemd so 'journalctl -u srp_daemon' does
the same thing.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 srp_daemon/CMakeLists.txt          | 2 --
 srp_daemon/logrotate-srp_daemon    | 7 -------
 srp_daemon/rsyslog-srp_daemon.conf | 3 ---
 3 files changed, 12 deletions(-)
 delete mode 100644 srp_daemon/logrotate-srp_daemon
 delete mode 100644 srp_daemon/rsyslog-srp_daemon.conf

diff --git a/srp_daemon/CMakeLists.txt b/srp_daemon/CMakeLists.txt
index acb851bcb8a438..305682d740085b 100644
--- a/srp_daemon/CMakeLists.txt
+++ b/srp_daemon/CMakeLists.txt
@@ -25,8 +25,6 @@ rdma_subst_install(FILES "srp_daemon.sh.in"
   RENAME "srp_daemon.sh"
   PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
 
-install(FILES logrotate-srp_daemon DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/logrotate.d" RENAME "srp_daemon")
-install(FILES rsyslog-srp_daemon.conf DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/rsyslog.d" RENAME "srp_daemon.conf")
 install(FILES srp_daemon.conf DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}")
 
 if ("${DISTRO_FLAVOUR}" STREQUAL "Debian")
diff --git a/srp_daemon/logrotate-srp_daemon b/srp_daemon/logrotate-srp_daemon
deleted file mode 100644
index 066b6325ed27ff..00000000000000
--- a/srp_daemon/logrotate-srp_daemon
+++ /dev/null
@@ -1,7 +0,0 @@
-/var/log/srp_daemon {
-	missingok
-	notifempty
-	copytruncate
-	weekly
-	compress
-}
diff --git a/srp_daemon/rsyslog-srp_daemon.conf b/srp_daemon/rsyslog-srp_daemon.conf
deleted file mode 100644
index 191ca799b1c371..00000000000000
--- a/srp_daemon/rsyslog-srp_daemon.conf
+++ /dev/null
@@ -1,3 +0,0 @@
-if	$programname == 'srp_daemon' or $syslogtag == '[srp_daemon]:' \
-then	-/var/log/srp_daemon.log
-&	~
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
