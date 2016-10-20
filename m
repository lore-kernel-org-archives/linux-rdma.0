From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: systemd unit file location...
Date: Thu, 20 Oct 2016 10:26:38 -0600
Message-ID: <20161020162638.GA28181@obsidianresearch.com>
References: <2807E5FD2F6FDA4886F6618EAC48510E24F0E61D@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E24F0E61D-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 20, 2016 at 05:04:35AM +0000, Weiny, Ira wrote:
> Not defined as:
> 
> ./build/CMakeCache.txt:CMAKE_INSTALL_SYSTEMD_SERVICEDIR:PATH=/usr/local/lib/systemd/system

It is a mistake.

> And you add the "system" in the Debian rules?
> 
> ./debian/iwpmd.install:lib/systemd/system/iwpmd.service
> ./debian/rules:                 -DCMAKE_INSTALL_SYSTEMD_SERVICEDIR:PATH=/lib/systemd/system \

because systemd requires /lib/systemd when installed and
/usr/local/lib/systemd when in 'local' mode.

It could be wrappered in some kind of "if CMAKE_INSTALL_PREFIX ==
/usr/", but at least RH wants this set from a RPM macro, so I decided
to do the same with Debian.

>From 33c80ab9f08814b7614c111aadaaa612cceb6234 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Thu, 20 Oct 2016 10:10:43 -0600
Subject: [PATCH] Fix default path for systemd unit files

Missed /system

Reported-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index a23aa860e6d3..c4fe705b2234 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -55,7 +55,7 @@ set(BUILD_LIB ${CMAKE_BINARY_DIR}/lib)
 set(CONFIG_DIR "${CMAKE_INSTALL_FULL_SYSCONFDIR}/libibverbs.d")
 set(CMAKE_INSTALL_INITDDIR "${CMAKE_INSTALL_SYSCONFDIR}/init.d"
   CACHE PATH "Location for init.d files")
-set(CMAKE_INSTALL_SYSTEMD_SERVICEDIR "${CMAKE_INSTALL_PREFIX}/lib/systemd"
+set(CMAKE_INSTALL_SYSTEMD_SERVICEDIR "${CMAKE_INSTALL_PREFIX}/lib/systemd/system"
   CACHE PATH "Location for systemd service files")
 
 set(ACM_PROVIDER_DIR "${CMAKE_INSTALL_FULL_LIBDIR}/ibacm"
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
