From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH 2/2] iwpmd: Support Debian/Ubuntu in sysvinit service
Date: Wed, 12 Jul 2017 17:42:55 +0200
Message-ID: <20170712154255.21296-2-benjamin.drung@profitbricks.com>
References: <20170712154255.21296-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170712154255.21296-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The sysvinit script for iwpmd supports only RedHat and SUSE by checking
the running distribution. Add support for Debian/Ubuntu by using
/lib/lsb/init-functions as default (on all non RedHat systems).

The binary pidofproc does not exits on Debian/Ubuntu, but
/lib/lsb/init-functions defines a pidofproc function instead (which
calls /sbin/pidofproc on openSUSE).

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 iwpmd/iwpmd_init | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/iwpmd/iwpmd_init b/iwpmd/iwpmd_init
index 88e63c10..0d2559e9 100755
--- a/iwpmd/iwpmd_init
+++ b/iwpmd/iwpmd_init
@@ -29,12 +29,13 @@ if [ -f "/etc/redhat-release" ]; then
 	STATUSD=status
 	GETPID=/sbin/pidof
 
-elif [ -f "/etc/SuSE-release" ]; then
+else
+	# Debian / openSUSE / Ubuntu
 	. /lib/lsb/init-functions
 	STARTD=start_daemon
 	STOPD=killproc
 	STATUSD=/sbin/checkproc
-	GETPID=/sbin/pidofproc
+	GETPID=pidofproc
 fi
 
 check() {
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
