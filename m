From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: rdma_reg_read()
Date: Thu, 07 Nov 2013 18:17:29 -0600
Message-ID: <527C2D99.9050407@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Troy Leedberg <troy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Felix Marti <felix-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Sean:

static inline struct ibv_mr *
rdma_reg_read(struct rdma_cm_id *id, void *addr, size_t length)
{
         return ibv_reg_mr(id->pd, addr, length, IBV_ACCESS_LOCAL_WRITE |
IBV_ACCESS_REMOTE_READ);
}

Should this be used for the registering sink memory of an rdma read?  If 
so, it won't work for iWARP, which requires REMOTE_WRITE for the sink.   
Should this code look at the transport type and set REMOTE_WRITE for 
iwarp transports?


Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
