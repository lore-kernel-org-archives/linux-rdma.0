From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 0/2] Fix "drivers/infiniband/core/uverbs_main.c:683:17: sparse: Using plain integer as NULL pointer" warning
Date: Tue, 19 Nov 2013 15:22:10 +0100
Message-ID: <cover.1384869925.git.ydroneaud@opteya.com>
References: <1384866781.20207.7.camel@localhost.localdomain> <528b3984.SVGs20ZWpcuR/Jls%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1384866781.20207.7.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Please find two patches to fix the issue reported by kbuild test
robot[1].

The first patch was already sent[2] as part of my on going
work to improve checks on commands[3].

The second patch address the sparse warning while allowing
warnings to be reported by the compiler (and that's why first
patch is needed, so it seems to me it's quite useful to have such
warnings and code should not hide them from the developer).

[1] https://lists.01.org/pipermail/kbuild-all/2013-November/002120.html
    http://marc.info/?i=1384866781.20207.7.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org

[2] https://patchwork.kernel.org/patch/2846202/
    http://marc.info/?i=3050a98379b4342ea59d59aeaf1ce162171df928.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

[3] http://mid.gmane.org/cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
    http://marc.info/?i=cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

Yann Droneaud (2):
  IB/core: const'ify inbuf in struct ib_udata
  IB/uverbs: remove implicit cast in INIT_UDATA()

 drivers/infiniband/core/uverbs.h      | 12 ++++++------
 drivers/infiniband/core/uverbs_cmd.c  | 20 ++++++++++----------
 drivers/infiniband/core/uverbs_main.c | 13 ++++++++-----
 include/rdma/ib_verbs.h               |  2 +-
 4 files changed, 25 insertions(+), 22 deletions(-)

-- 
1.8.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
