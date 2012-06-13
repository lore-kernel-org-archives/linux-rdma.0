From: "Yann Droneaud" <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: ibv_poll_cq() and wc->byte_len
Date: Wed, 13 Jun 2012 15:33:14 +0200
Message-ID: <ede34732991cf26d52569692a20d7ae0.squirrel@webmail.ocsa-data.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I was trying to use byte_len field from struct ibv_wc to report
the total number of bytes actually sent after a ibv_post_send() with
opcode IBV_WR_SEND.

After polling the completion queue (CQ) and ensuring status field of
struct ibv_wc has value IBV_WC_SUCCESS, the field byte_len of the
structure seems to be invalid.

Indeed, according to libmlx4 sources and mlx_poll_one() function, byte_len
is not always set for a send operation. It's set only for
IBV_WC_RDMA_READ, IBV_WC_COMP_SWAP and IBV_WC_FETCH_ADD, and not set for
IBV_WC_RDMA_WRITE and IBV_WC_SEND (and also not for IBV_WC_BIND_MW). This
is the same thing for libmthca.

I haven't checked for QLogic/Intel libipathverbs since it does a direct
memcpy() to the destination struct ibv_wc, looking at the library code
doesn't help me a lot.

Note: Hopefully, for receive operation, byte_len is always valid.

ibv_poll_cq(3) man page is not really helpful to know which field will be
valid depending on the opcode field of struct ibv_wc, exception when
status is not IBV_WC_SUCCESS.

Is libmlx4, libmthca behavior correct ?

In a parallel universe, struct ibv_wc would have a bitmap field indicating
which others fields are valid. In this part of the multiverse, a more
complete documentation would be welcome. If libmlx4/libmthca behavior is
the compliant one, I can provide an updated man page.

Regards.

-- 
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
