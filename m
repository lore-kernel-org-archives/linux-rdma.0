From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv3 for-3.13 0/9] create_flow/destroy_flow fixes for v3.13
Date: Wed, 11 Dec 2013 23:01:43 +0100
Message-ID: <cover.1386798254.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Please find the third revision of a patchset against create_flow/destroy_flow
and associated extended command scheme.

These are fixes that *must* be applied before making the new uverbs
widely available in v3.13:

- patches 1 and 2 address a warning reported by sparse.
- patch 3 handle an uncommon type of extended command.
- patch 4, 5 and 6 ensure that commands will be extensible:
  - one patch add a missing check of comp_mask;
  - the other patches add checks on reserved fields.
- patch 7 fix an error path which was not setting the error code.
- patch 8 ensure the response buffer of an extended command
  is a valid memory region for userspace. Doing the check earlier,
  on the *full* response buffer, might be safer.
- patch 9 prevent out of bound access and underflow.

Please review and apply for v3.13.

Changes from patchset v2 [1]:

- add a patch to check the input length in extended uverbs,
  create_flow and destroy_flow.

Changes from patchset v1 [2]:

- add patch to verify early response buffer using access_ok(),
  just like vfs_read().

Regards.

[1] [PATCH v2 for v3.13 0/8] create_flow/destroy_flow fixes for v3.13
    http://marc.info/?i=cover.1385981934.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

[2] [PATCH for v3.13 0/7] create_flow/destroy_flow fixes for v3.13
    http://marc.info/?i=cover.1385501822.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

Yann Droneaud (9):
  IB/core: const'ify inbuf in struct ib_udata
  IB/uverbs: remove implicit cast in INIT_UDATA()
  IB/uverbs: set outbuf to NULL when no core response space is provided
  IB/uverbs: check reserved field in extended command header
  IB/uverbs: check comp_mask in destroy_flow
  IB/uverbs: check reserved fields in create_flow
  IB/uverbs: set error code when fail to consume all flow_spec items
  IB/uverbs: check access to userspace response buffer in extended
    command
  IB/uverbs: check input length in flow steering uverbs

 drivers/infiniband/core/uverbs.h      | 12 ++++++------
 drivers/infiniband/core/uverbs_cmd.c  | 37 +++++++++++++++++++++++++----------
 drivers/infiniband/core/uverbs_main.c | 21 +++++++++++++++-----
 include/rdma/ib_verbs.h               |  2 +-
 4 files changed, 50 insertions(+), 22 deletions(-)

-- 
1.8.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
