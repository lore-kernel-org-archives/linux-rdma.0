From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RDMA_CM_EVENT_REJECTED
Date: Tue, 25 Oct 2016 09:38:39 -0500
Message-ID: <00c901d22ecd$79a9f300$6cfdd900$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

While working on the reject helper functions, I notice that some of the rdma_cm
kernel users have handlers for RDMA_CM_EVENT_REJECTED even for cm_ids that are
spawned from listening cm_ids as the result of a RDMA_CM_EVENT_CONNECT_REQUEST,
and that issue an rdma_accept() or rdma_reject() in response. 

Q: is it possible for a REJECTED event to get posted to these cm_ids?  It is not
for iWARP, but I'm not sure about IB.  I'm guessing this is just due to
cut/paste process of adding event handlers, but I wanted to make sure.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
