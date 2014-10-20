From: Chris Moore <Chris.Moore-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: Can someone help me understand the reason for this code in
 ib_isert.c?
Date: Mon, 20 Oct 2014 15:29:59 +0000
Message-ID: <462EF229174FDB4D92ACE4656EA5610051E2EEF9@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following code is in isert_conn_setup_qp() in ib_isert.c:

         /*
           * FIXME: Use devattr.max_sge - 2 for max_send_sge as
           * work-around for RDMA_READ..
           */
         attr.cap.max_send_sge = device->dev_attr.max_sge - 2;

It's not clear from the comment what this is a work-around for, and I wasn't able
to figure it out from looking at logs.

In trying to get isert working with ocrdma I ran into a problem where the code
thought there was only 1 send SGE available when in fact the device has 3.
Then I found the above work-around, which explained the problem.

Removing this (setting attr.cap.max_send_sge to device->dev_attr.max_sge)
fixes the problem with isert and ocrdma, but I don't know what other side effects
that might have.

Thanks,

Chris

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
