From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/4] IB/core: an improved infrastructure for uverbs commands
Date: Mon,  7 Oct 2013 22:49:13 +0200
Message-ID: <cover.1381177342.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Please find a follow up to my previous proposal for a revised
extensible command infrastructure [1].

With this new patchset, I'm trying to improve it further.

The main patch, which was sent previously, was cleaned up.

A second patch tightly related to the previous one make
"comp_mask" part of the extended command header, as suggested.

The third patch check extended command size: extend commands
should take care to not accept more data than the "comp_mask"
is describing.

The latest patch is more experimental: it tries to add
a common response header to hold the returned "comp_mask" and
size of uverbs (eg. core/) and provider (eg. hw/) responses.
I'm not really happy of the shape of this one. It's complicated
and makes me uncomfortable. But please have a look at it.

Regards.

Links:

[1]: http://marc.info/?i=1380039392-15480-1-git-send-email-ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
     http://mid.gmane.org/1380039392-15480-1-git-send-email-ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

Yann Droneaud (4):
  IB/core: extended command: an improved infrastructure for uverbs
    commands
  IB/core: extended command: move comp_mask to the extended header
  IB/core: extended command: enforce command size
  IB/core: extended command: add a common extended response header

 drivers/infiniband/core/uverbs.h      |  19 +++-
 drivers/infiniband/core/uverbs_cmd.c  |  76 +++++++++-------
 drivers/infiniband/core/uverbs_main.c | 161 ++++++++++++++++++++++++++++------
 drivers/infiniband/hw/mlx4/main.c     |   6 +-
 include/rdma/ib_verbs.h               |  23 +++++
 include/uapi/rdma/ib_user_verbs.h     |  34 ++++---
 6 files changed, 246 insertions(+), 73 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
