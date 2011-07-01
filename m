From: Greg Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Subject: Remote Invalid Request Error
Date: Fri, 1 Jul 2011 17:22:36 -0400
Message-ID: <201107011722.36779.kerr.g@husky.neu.edu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I wrote a modified version of the pingpong program that performs an RDMA 
write, however I am getting a Remote Invalid Request Error. 

I looked in GDB, and the rkey and addr of the RDMA request seem to be correct. 
What else could cause such an error? The memory region was registerd with 
REMOTE_WRITE and REMOTE_READ.

This is the code for the RDMA write, in case its of help:

void rdma_write(struct pingpong_context *ctx, struct pingpong_dest *rem_dest)
{
  struct ibv_send_wr wr, *bad_wr = NULL;
  struct ibv_sge sge;

  memset(&wr, 0, sizeof(wr));

  wr.wr_id = 5;
  wr.opcode = IBV_WR_RDMA_WRITE;
  wr.sg_list = &sge;
  wr.num_sge = 1;
  wr.send_flags = IBV_SEND_SIGNALED;
  wr.wr.rdma.remote_addr = rem_dest->remote_addr;
  wr.wr.rdma.rkey = rem_dest->rkey;

  printf("wr.wr.rdma.remote_addr: %llx\n", rem_dest->remote_addr);
  printf("wr.wr.rdma.rkey: %x\n", rem_dest->rkey);

  sge.addr = (uintptr_t)ctx->buf2;
  sge.length = ctx->size;
  sge.lkey = ctx->mr2->lkey;

  if (ibv_post_send(ctx->qp, &wr, &bad_wr))
  {
    fprintf(stderr, "RMDA Write Failed.\n");
    exit(1);
  }
}

and the registering of the mrs:

      ctx->mr = ibv_reg_mr(ctx->pd, ctx->buf, size, IBV_ACCESS_LOCAL_WRITE | 
IBV_ACCESS_REMOTE_WRITE | IBV_ACCESS_REMOTE_READ);
      if (!ctx->mr) {
            fprintf(stderr, "Couldn't register MR\n");
            return NULL;
      }

      ctx->mr2 = ibv_reg_mr(ctx->pd, ctx->buf2, size, IBV_ACCESS_LOCAL_WRITE);
      if (!ctx->mr2) {
            fprintf(stderr, "Couldn't register MR2\n");
            return NULL;
      }

mr2 is only registered for local access.

Regards
-- 
Greg Kerr
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
