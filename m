From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCHv1 0/1] fix sg_tablesize calculation in iser
Date: Mon, 16 Jan 2017 19:44:40 +0200
Message-ID: <1484588681-12987-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Guys,
I've noticed that we set the sg_tablesize wrongly in iser
because of the unsigned short casting (still haven't checked other ULPs).
This can cause performance degredation since each IO is divided into
4k chunks or less (sg_nents=1).
I think we need to cc stable kernel since v4.3, right ?

Max Gurtovoy (1):
  IB/iser: Fix sg_tablesize calculation

 drivers/infiniband/ulp/iser/iscsi_iser.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
