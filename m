From: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/3] iw_cxgb3/4 bug fixes
Date: Tue, 12 Apr 2016 06:55:09 -0700
Message-ID: <20160412143035.3B08CE08CA@smtp.ogc.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Here are three important bug fixes that I recommend get pulled into
4.6-rc.

Steve Wise (3):
  iw_cxgb4: initialize ibdev.iwcm->ifname for port mapping
  iw_cxgb3: initialize ibdev.iwcm->ifname for port mapping
  iw_cxgb4: handing draining an idle qp

 drivers/infiniband/hw/cxgb3/iwch_provider.c |  2 ++
 drivers/infiniband/hw/cxgb4/provider.c      |  2 ++
 drivers/infiniband/hw/cxgb4/qp.c            | 18 ++++++++++++++++--
 3 files changed, 20 insertions(+), 2 deletions(-)

-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
