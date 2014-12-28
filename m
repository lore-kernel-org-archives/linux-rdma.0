From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: RDMA atomic operations fail
Date: Sun, 28 Dec 2014 11:59:32 +0200
Message-ID: <549FD484.1040606@dev.mellanox.co.il>
References: <loom.20141224T040342-951@post.gmane.org>	<549BCDEB.9060402@dev.mellanox.co.il> <CAJRcJr1QKB-7=xx6fD80RjfikR5ZJU+_6WTidXwCB-CocsPqzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJRcJr1QKB-7=xx6fD80RjfikR5ZJU+_6WTidXwCB-CocsPqzA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Just Floaterions <floaterions-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/26/2014 4:29 AM, Just Floaterions wrote:
> I'm using ConnectIB.
>
> This is my send_wr code:
>
> struct ibv_send_wr wr, *bad_wr = NULL;
> struct ibv_sge sge;
> memset(&sge, 0, sizeof(sge));
> sge.addr = (uintptr_t)conn->local_buffer;
> sge.length = 8;
> sge.lkey = conn->local_mr->lkey;
> memset(&wr, 0, sizeof(wr));
> wr.wr_id= 0;
> wr.opcode = IBV_WR_ATOMIC_FETCH_AND_ADD;
> wr.sg_list = &sge;
> wr.num_sge = 1;
> wr.send_flags = IBV_SEND_SIGNALED;
> wr.wr.atomic.remote_addr= (uintptr_t)conn->peer_mr.addr;
> wr.wr.atomic.rkey = conn->peer_mr.rkey;
> wr.wr.atomic.compare_add= 1ULL;
>
> if (ibv_post_send(conn->qp, &wr, &bad_wr)) {
> fprintf(stderr, "Error, ibv_post_send() failed\n");
> die("");
> }

What libmlx5 are you using? Are you using MLNX_OFED?

I see that libmlx5 from openfabrics don't have support for
atomic operations yet (MLNX_OFED libmlx5 does have atomic support).

CC'ing Eli, the mlx5 maintainer.

Cheers,
Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
