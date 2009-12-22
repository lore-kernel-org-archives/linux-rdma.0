From: "Guay Wei Lin" <weilin-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Subject: Questions on RTS->SQD
Date: Tue, 22 Dec 2009 10:56:57 +0100
Message-ID: <000001ca82ed$1c67b8a0$553729e0$@no>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi, 

As for an experiment for my research to try out the SQD state, I've reused
the perftest code (send_bw.c) to modify the QP state from RTS->SQD, and
query_qp to make sure the QP is in the SQD state. The codes were added
before ibv_post_send function. (to make sure no outstanding WR in the SQ).
When the ibv_modify_qp is executed to modify QP from RTS->SQD, it returns a
0 without any error code, but when the ibv_query_qp to query on the
QP_state, the QP is still in RTS state. I'm using the mlx4 HCAs. Any
ideas/suggestions why this will happen or I miss out something?

Thanks,
Wei Lin
PhD student
Simula School of Research and Innovation AS 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
