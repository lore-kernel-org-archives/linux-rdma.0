From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v2 0/3] iw_cxgb4 fixes for 4.14-rc
Date: Fri, 15 Sep 2017 13:26:09 -0700
Message-ID: <20170915202852.53885E0C1D@smtp.ogc.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Doug, please consider these bug fixes for 4.14-rc.  I'm resending 
a "v2" series which overrides the first submission, and the "RESEND"
submission.

Changes since "RESEND"
- fixed up the commit comment for patch 3

Chances since original submission
- Move the stable tag to the correct location in the commit log

Thanks,

Steve.

---

Steve Wise (3):
  iw_cxgb4: put ep reference in pass_accept_req()
  iw_cxgb4: drop listen destroy replies if no ep found
  iw_cxgb4: remove the stid on listen create failure

 drivers/infiniband/hw/cxgb4/cm.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
