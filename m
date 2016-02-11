From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: missing commit for 4.4 stable
Date: Thu, 11 Feb 2016 14:30:58 -0600
Message-ID: <020601d1650b$1d7ecd30$587c6790$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: 'Matan Barak' <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Greg,

I don't see the following patch in linux-4.4.y yet.  Is there something else that needs to be done to get it queued up?  Or is it in
the pipeline?

Thanks,

Steve.

commit 649367735ee5dedb128d9fac0b86ba7e0fe7ae3b
Author: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Thu Jan 7 11:19:29 2016 +0200

    IB/cma: Fix RDMA port validation for iWarp

    cma_validate_port wrongly assumed that Ethernet devices are RoCE
    devices and thus their ndev should be matched in the GID table.
    This broke the iWarp support. Fixing that matching the ndev only if
    we work on a RoCE port.

    Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 4.4.x-
    Fixes: abae1b71dd37 ('IB/cma: cma_validate_port should verify the port
                     and netdevice')
    Reported-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
    Tested-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
    Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
    Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
