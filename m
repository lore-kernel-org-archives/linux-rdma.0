From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma 0/1] IB/core: Fix input len in multiple user verbs
Date: Mon, 26 Jun 2017 18:53:48 +0300
Message-ID: <1498492429-28051-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch follows [1] that fixed three verbs and extends that fix to
the other verbs as well.

This fix is required for qedr to support existing and future libraries.

I was able to test the fix only partially due to its scope hence careful
review is required, and testing, of course.

The scope of the fix is IB/core only i.e. I haven't touched vendor code
that might be affected as [1] did.


[1] https://www.spinics.net/lists/linux-rdma/msg33405.html

Ram Amrani (1):
  IB/core: Fix input len in multiple user verbs

 drivers/infiniband/core/uverbs_cmd.c | 70 ++++++++++++++++++++----------------
 1 file changed, 40 insertions(+), 30 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
