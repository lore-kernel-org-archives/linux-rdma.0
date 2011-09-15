From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: identify the race condition in this code and win the respect of
 linux-rdma developers!
Date: Thu, 15 Sep 2011 23:58:34 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E5B2B1@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I have a ping-pong test application that loops doing: send, wait for send completion, wait for receive completion.  The test occasionally hangs in the following code at ibv_get_cq_event() (error handling removed):

Case 1:
	ret = ibv_poll_cq(id->recv_cq, 1, wc);
	ret = ibv_req_notify_cq(id->recv_cq, 0);

	while (!(ret = ibv_poll_cq(id->recv_cq, 1, wc))) {
		ret = ibv_get_cq_event(id->recv_cq_channel, &cq, &context);
		ibv_ack_cq_events(id->recv_cq, 1);
	}

The test does NOT hang if the code is restructured as either of the below: 

Case 2:
	ret = ibv_poll_cq(id->recv_cq, 1, wc);
	ret = ibv_req_notify_cq(id->recv_cq, 0);

	do {
		ret = ibv_get_cq_event(id->recv_cq_channel, &cq, &context);
		ibv_ack_cq_events(id->recv_cq, 1);
	} while (!(ret = ibv_poll_cq(id->recv_cq, 1, wc)));

or
Case 3:
	ret = ibv_poll_cq(id->recv_cq, 1, wc);
	while (1)
		ret = ibv_req_notify_cq(id->recv_cq, 0);

		ret = ibv_poll_cq(id->recv_cq, 1, wc);
		if (ret)
			break;
		ret = ibv_get_cq_event(id->recv_cq_channel, &cq, &context);
		ibv_ack_cq_events(id->recv_cq, 1);
	}

Personally, I would have expected case 2 to hang and cases 1 and 3 to work.  Does anyone see why case 1 should hang?  This is with mlx4.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
