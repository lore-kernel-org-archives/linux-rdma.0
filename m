From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 0/4] RDMA uverbs fixes for 4.16
Date: Wed, 14 Feb 2018 12:35:36 +0200
Message-ID: <20180214103540.22374-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

The following four patches fix failures found during our
regression testing.

Thanks

Leon Romanovsky (4):
  RDMA/restrack: Increment CQ restrack object before committing
  RDMA/uverbs: Fix bad unlock balance in ib_uverbs_close_xrcd
  RDMA/uverbs: Fix circular locking dependency
  RDMA/uverbs: Sanitize user entered port numbers prior to access it

 drivers/infiniband/core/uverbs_cmd.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
