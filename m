From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 for v3.13 0/8] create_flow/destroy_flow fixes for v3.13
Date: Mon,  2 Dec 2013 12:12:42 +0100
Message-ID: <cover.1385981934.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Please find the second revision of a patchset against create_flow/destroy_flow
and associated extended command scheme.

These are fixes that must be applied before making the new uverbs
widely available.

The first two patches address a warning reported by sparse.

The next patch handle an uncommon type of extended command.

Three patches ensure that commands will be extensible:
- One patch add a missing check of comp_mask;
- Two patches add checks on reserved fields.

The next patch fix an error path which was not setting the error code.

The last patch ensure the response buffer of an extended command
is a valid memory region for userspace. Doing the check earlier,
on the *full* response buffer, might be safer.

Please review and apply for v3.13.

Changes from patchset v1 [1]:

- add patch to verify early response buffer using access_ok(),
  just like vfs_read().

Regards.

[1] [PATCH for v3.13 0/7] create_flow/destroy_flow fixes for v3.13
    http://marc.info/?i=cover.1385501822.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

Yann Droneaud (8):
  IB/core: const'ify inbuf in struct ib_udata
  IB/uverbs: remove implicit cast in INIT_UDATA()
  IB/uverbs: set outbuf to NULL when no core response space is provided
  IB/uverbs: check reserved field in extended command header
  IB/uverbs: check comp_mask in destroy_flow
  IB/uverbs: check reserved fields in create_flow
  IB/uverbs: set error code when fail to consume all flow_spec items
  IB/uverbs: check access to userspace response buffer in extended
    command

 drivers/infiniband/core/uverbs.h      | 12 ++++++------
 drivers/infiniband/core/uverbs_cmd.c  | 31 +++++++++++++++++++++----------
 drivers/infiniband/core/uverbs_main.c | 21 ++++++++++++++++-----
 include/rdma/ib_verbs.h               |  2 +-
 4 files changed, 44 insertions(+), 22 deletions(-)

-- 
1.8.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
