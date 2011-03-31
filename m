From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/5] Hardenize libibverbs initialisation
Date: Thu, 31 Mar 2011 11:29:20 +0200
Message-ID: <cover.1301562707.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to hardenize my test application, I tried "fuzzing" its input
with zzuf[1]. But my application mostly failed to initialize due to
unhandled failure cases.

So here're are patches to clean the situation and let's application
exit properly.

The patches here are against kernel.org's libibverbs repository[2]

[1] http://caca.zoy.org/wiki/zzuf
[2] http://git.kernel.org/?p=libs/infiniband/libibverbs.git

Yann Droneaud (5):
  load_drivers: reset the list head after releasing items
  ibverbs_init: reset the list head after releasing items
  read_config: don't try to open file beginning with '.'
  read_config: ignore directory entry with backup suffix (~)
  read_config_file: ignore driver line without driver name

 src/init.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

-- 
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
