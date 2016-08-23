From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 1/1] iw_cxgb4: Fix cxgb4 arm CQ logic to handle IB_CQ_REPORT_MISSED_EVENTS
Date: Tue, 23 Aug 2016 10:55:50 -0500
Message-ID: <00f801d1fd56$d1e44d70$75ace850$@opengridcomputing.com>
References: <20160823145733.21093-1-bharat@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160823145733.21093-1-bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Potnuri Bharat Teja' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Current cxgb4 arm CQ logic ignores IB_CQ_REPORT_MISSED_EVENTS for
> request completion notification on a CQ. Due to this ib_poll_handler()
> assumes all events polled and avoids further iopoll scheduling.
> 
> This patch adds logic to cxgb4 ib_req_notify_cq() handler to check if
> CQ is not empty and return accordingly. Based on the return value of
> ib_req_notify_cq() handler, ib_poll_handler() will schedule a run of
> iopoll handler.
> 
> Signed-off-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

Looks good.   Doug, perhaps this can make 4.8-rc?

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
