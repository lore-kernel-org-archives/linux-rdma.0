From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] redhat/spec: further cleanups to
 depdendencies, descriptions, formatting
Date: Thu, 22 Dec 2016 11:13:23 -0700
Message-ID: <20161222181323.GA5053@obsidianresearch.com>
References: <20161222180220.49558-1-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161222180220.49558-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 22, 2016 at 01:02:20PM -0500, Jarod Wilson wrote:
> These are numerous additional little fixups for the Fedora/Red Hat spec
> file, stemming from Fedora package review.
> 
> - Per https://fedoraproject.org/wiki/Packaging:Systemd it seems we need to
>   have systemd as a BuildRequires for %{_unitdir} to evaluate properly.
> 
> - Add explicit dependencies on kmod, initscripts and systemd, as there
>   are container and vm cases where there might not be a kernel
>   installed

Do we need initscripts?

> - Make sure srp_daemon.sh is executable

Oops, lets fix that commonly please, can you roll this in and drop the chmod:

diff --git a/srp_daemon/CMakeLists.txt b/srp_daemon/CMakeLists.txt
index f2752a8e6e1580..acb851bcb8a438 100644
--- a/srp_daemon/CMakeLists.txt
+++ b/srp_daemon/CMakeLists.txt
@@ -22,7 +22,8 @@ rdma_install_symlink(srp_daemon "${CMAKE_INSTALL_SBINDIR}/ibsrpdm")
 rdma_install_symlink(srp_daemon "${CMAKE_INSTALL_SBINDIR}/run_srp_daemon")
 rdma_subst_install(FILES "srp_daemon.sh.in"
   DESTINATION "${CMAKE_INSTALL_SBINDIR}"
-  RENAME "srp_daemon.sh")
+  RENAME "srp_daemon.sh"
+  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
 
 install(FILES logrotate-srp_daemon DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/logrotate.d" RENAME "srp_daemon")
 install(FILES rsyslog-srp_daemon.conf DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/rsyslog.d" RENAME "srp_daemon.conf")

>  Requires: %{name}%{?_isa} = %{version}-%{release}
> +Requires: logrotate

I don't think we use logrotate for anything unless the srp rsyslog
examples are being used? Maybe it would be better to move the logrotate
and rsyslog stuff to doc/examples or something?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
