From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/9] IB/core: batch of fix against create/destroy_flow uverbs for v3.12
Date: Fri, 11 Oct 2013 19:18:45 +0200
Message-ID: <cover.1381510045.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

As requested by Or Gerlitz, I've rebased my previous fixes [1]
against Matan Barak patch [2]. I've added two patches to fix issues
left or introduced by this patch.
Regarding the previous patchset [1], I've kept the public data
structure improving and renaming patches, but, in order to minimize
the overall changes, I've removed the changes which were modifying
the functions and variables names in the code.
I've removed "code beautifying" and left "hardening" / cleanup changes
for a latter release.

On top of this, I've added the two acknowledged and important patches
from my extended command infrastructure [3]. I've made cleanups in the
changelog regarding the 'email' citations.

It's in pretty good shape, and, if revert or temporarily disabling
are not an option, this can probably go in v3.12.

Regards.

Links:

[1]: http://marc.info/?i=cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
     http://mid.gmane.org/cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

[2]: https://patchwork.kernel.org/patch/2924341/

[3]: http://marc.info/?i=cover.1381177342.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
     http://mid.gmane.org/cover.1381177342.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

Matan Barak (1):
  IB/core: clarify overflow/underflow checks on ib_create/destroy_flow

Yann Droneaud (8):
  IB/core: Includes flow attribute size in uverbs create_flow
  IB/core: Don't include command header size in uverbs create_flow
  IB/core: Rename 'flow' structs to match other uverbs structs
  IB/core: Makes uverbs flow structure using names more similar to verbs
    ones
  IB/core: Uses a common header for uverbs flow_specs
  IB/core: Remove ib_uverbs_flow_spec structure from userspace
  IB/core: extended command: an improved infrastructure for uverbs
    commands
  IB/core: extended command: move comp_mask to the extended header

 drivers/infiniband/core/uverbs.h      |  35 +++++++++-
 drivers/infiniband/core/uverbs_cmd.c  | 101 ++++++++++++++--------------
 drivers/infiniband/core/uverbs_main.c | 123 +++++++++++++++++++++++++++-------
 drivers/infiniband/hw/mlx4/main.c     |   6 +-
 include/rdma/ib_verbs.h               |   1 +
 include/uapi/rdma/ib_user_verbs.h     |  95 +++++++++++++++-----------
 6 files changed, 240 insertions(+), 121 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
