From: Greg I Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Subject: Call to ibv_post_recv fails
Date: Fri, 6 May 2011 15:39:58 -0400
Message-ID: <BANLkTik2t9dFrtpMqGd29xQWHk=EB8_g6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I was hoping some of you might be able to tell me why the call to
ibv_post_recv fails in the following code snippet, based off of
rc_pingpong.

I registered both buffers with ibv_reg_mr and am simply trying to post
a work request that points to an sge list of 2 buffers. Is it not
allowed to point to separately registered memory regions with this
list?

Thanks,

Greg Kerr

static int pp_post_recv(struct pingpong_context *ctx, int n)
{
      struct ibv_sge list[] = {
        {
            .addr = (uintptr_t) ctx->buf,
            .length = ctx->size,
            .lkey = ctx->mr->lkey
        },
        {
          .addr = (uintptr_t) ctx->buf2,
          .length = ctx->size,
          .lkey = ctx->mr2->lkey
        }};

      struct ibv_recv_wr wr = {
            .wr_id          = PINGPONG_RECV_WRID,
            .sg_list    = list,
            .num_sge    = 2,
      };
      struct ibv_recv_wr *bad_wr;
      int i;

      for (i = 0; i < n; ++i)
            if (ibv_post_recv(ctx->qp, &wr, &bad_wr))
                  break;

      return i;
}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
