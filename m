From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [ANNOUNCE] librdmacm 1.0.12
Date: Tue, 25 May 2010 10:26:41 +0300
Message-ID: <4BFB7BB1.8070004@Voltaire.com>
References: <CE35DBA4CC524BD3BDA61C7DE2BD39CD@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CE35DBA4CC524BD3BDA61C7DE2BD39CD-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
> I've pushed out release 1.0.12 of librdmacm.  

Hi Sean, below is a tiny patch which will help direct users to the correct mailing list


set the mailing list info to be linux-rdma instead of the ofa general list

signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

diff --git a/configure.in b/configure.in
index d6c4a62..d0f2623 100644
--- a/configure.in
+++ b/configure.in
@@ -1,7 +1,7 @@
 dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.57)
-AC_INIT(librdmacm, 1.0.12, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org)
+AC_INIT(librdmacm, 1.0.12, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
 AC_CONFIG_SRCDIR([src/cma.c])
 AC_CONFIG_AUX_DIR(config)
 AM_CONFIG_HEADER(config.h)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
