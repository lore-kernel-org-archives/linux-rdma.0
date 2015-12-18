From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: MR cleanups
Date: Fri, 18 Dec 2015 14:54:56 +0100
Message-ID: <1450446906-10336-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

this series (on top of your k.o/for-4.5 branch) has various MR-related
cleanups:  starting to document the device capabilities, removing lots
of dead MR/MW code and removing a useless field in struct ib_mr.  This
should be fairly uncontroversial I hope, so I'd like to get it in before
the real MR changes.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
