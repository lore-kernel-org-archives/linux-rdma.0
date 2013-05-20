From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] make read_config() more robust
Date: Mon, 20 May 2013 23:43:02 +0200
Message-ID: <cover.1369085762.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Please find three patches to protect libibverbs from using invalid,
unsecure configuration files.

Thoses configurations files are usually located in
/etc/libibverbs.d/ and contains the name of a shared library
to dlopen().

Only legitimate shared libraries should be loaded by libibverbs,
so it must be careful on the configuration files used.

Regards.

Yann Droneaud (3):
  read_config: ignore files beginning with '.'
  read_config: ignore directory entry with backup suffix (~)
  read_config: skip file/directory with unsecure permissions

 src/init.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
