From: Hari Subramoni <subramon-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
Subject: Setting ACK timeout for QP's created using RDMA_CM.
Date: Fri, 29 Jan 2010 09:35:19 -0500 (EST)
Message-ID: <Pine.GSO.4.40.1001290933060.4760-100000@kappa.cse.ohio-state.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I am looking for the IB equivalent of the 're-transmission timeout' we
have in ethernet. I was going through the QP attributes and came across
this field in 'struct ibv_qp_attr'

uint8_t timeout; /* Local ack timeout for primary path (valid only for RC QPs)*/

I believe that this is the period of time (in seconds) that the IB HCA
will wait for the ACK for a packet it sent out before re-transmitting? I
was looking as to whether this field can be modified when creating a QP
using RDMA_CM.

Thanks in advance,

Hari.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
