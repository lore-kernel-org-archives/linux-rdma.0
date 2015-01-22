From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/4] IB/core: extended query device caps cleanup for v3.19
Date: Thu, 22 Jan 2015 14:28:01 +0100
Message-ID: <cover.1421931555.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Following discussions in thread "[PATCH v3 06/17] IB/core: Add support
for extended query device caps" [1], I'm proposing the following patchset
to implement a different behavior to handle the request parameters
in ib_uverbs_ex_query_device() in order to restore the current behavior
of ib_copy_to_udata().

The behavior is different from the initial one but I feel more confident
it would allow a better maintainability. Additionally, I believe it's
looking more like the behavior already implemented by other InfiniBand/RDMA
kernel <-> userspace interfaces.

[1] http://mid.gmane.org/1418733236.2779.26.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

Yann Droneaud (4):
  IB/uverbs: ex_query_device: fail if output buffer size does not match
  IB/core: ib_copy_to_udata(): don't silently truncate response
  IB/uverbs: ex_query_device: check request's comp_mask
  IB/uverbs: ex_query_device: no need to clear the whole structure

 drivers/infiniband/core/uverbs_cmd.c | 24 ++++++++++++++++++++++--
 include/rdma/ib_verbs.h              |  5 +----
 2 files changed, 23 insertions(+), 6 deletions(-)

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
