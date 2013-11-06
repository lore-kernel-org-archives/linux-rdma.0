From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next v2 0/7] uverbs extensions fixes
Date: Wed,  6 Nov 2013 23:21:43 +0100
Message-ID: <cover.1383773832.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series is a continuous improvement for the uverbs
extension mechanism and flow steering uverbs that were
introduced as an experimental features for v3.12.

I suggested and implemented the following improvements:
- improved extensible/extended command infrastructure
  with clear split between core/ (eg. uverbs) and hw/ (eg. provider)
  portion of command and response;
- structure renaming to match others uverbs public structs;
- changes usage of the flow_attr.size to not count the
  "extended command header" but to describe only the size
  of the flow specs following flow_attr;
- removed unneeded flow_spec structure that don't need to be
  exposed to userspace.
- ensure 64bits alignment

Changes from v1 (patchset [1]):

- re-enable patch by Matan Barack as the last step
- patch moving comp_mask in command header dropped following
  discussion about having comp_mask for provider data and response.
- moved variable written_count in an inner block

Changes from v0 (patchset [2]):

- Re-enable flow steering verbs and the extension verbs mechanism.
- Squashed patches 1 and 2 from the original series
- ib_uverbs_write should return the number of bytes including the
   header's size (Patch 7).

Changes from v(-1) (patchset [3] and patchset [4]):

- merge infrastructure and uverbs flow fixes
- rebased against Matan Barack fixes
- removed changes on function name

Changes from initial (patchset [5]):

- move "comp_mask" in the command header
- add a response header
- add strict command length check

[1] [PATCH for-next V1 0/8] uverbs extensions fixes
    http://marc.info/?i=1383126771-7658-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org

[2] [PATCH 0/9] IB/core: batch of fix against create/destroy_flow uverbs for v3.12
    http://marc.info/?i=cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

[3] [PATCH 00/10] IB/core: more fixes for create_flow uverbs (for v3.12)
    http://marc.info/?i=cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

[4] [PATCH v2 0/4] IB/core: an improved infrastructure for uverbs commands
    http://marc.info/?i=cover.1381177342.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

[5] [PATCH] An improved infrastructure for uverbs commands (My take at designing extensible scheme)
    http://marc.info/?i=1380039392-15480-1-git-send-email-ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

Matan Barak (2):
  IB/core: clarify overflow/underflow checks on ib_create/destroy_flow
  IB/core: re-enable create_flow/destroy_flow uverbs

Yann Droneaud (5):
  IB/core: Rename 'flow' structs to match other uverbs structs
  IB/core: Makes uverbs flow structure using names more similar to verbs
    ones
  IB/core: Uses a common header for uverbs flow_specs
  IB/core: Remove ib_uverbs_flow_spec structure from userspace
  IB/core: extended command: an improved infrastructure for uverbs
    commands

 drivers/infiniband/Kconfig            |  11 ---
 drivers/infiniband/core/uverbs.h      |  36 ++++++++--
 drivers/infiniband/core/uverbs_cmd.c  |  96 ++++++++++++-------------
 drivers/infiniband/core/uverbs_main.c | 128 +++++++++++++++++++++++++---------
 drivers/infiniband/hw/mlx4/main.c     |   8 +--
 include/rdma/ib_verbs.h               |   1 +
 include/uapi/rdma/ib_user_verbs.h     |  95 ++++++++++++++-----------
 7 files changed, 228 insertions(+), 147 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
