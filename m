From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] update to autotools
Date: Tue, 21 May 2013 00:39:52 +0200
Message-ID: <cover.1369089206.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

As part of update to configure.ac, please find two quite simple patches.

It should be applied to bring the build system a bit up to date
regarding autotools.

It works on Debian 6.0 (Squeeze) and Fedora 17 (Beefy Miracle),
but you might want to test on older systems ... I'm looking at you
Red Hat Enterprise Linux ... But ultimately it depends on the
release manager's host environment which is probably up to date :)

Yann Droneaud (2):
  configure: apply updates proposed by autoupdate
  configure: use automake's option "subdir-objects"

 configure.ac | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
