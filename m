From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH RFC] iser-target: avoid reinitializing rdma contexts for
 isert commands
Date: Thu, 30 Nov 2017 00:50:31 +0200
Message-ID: <349dba5f-dbed-164e-5c7a-d22ae929dbfc@grimberg.me>
References: <1511893687-29298-1-git-send-email-bharat@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1511893687-29298-1-git-send-email-bharat@chelsio.com>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: Potnuri Bharat Teja <bharat@chelsio.com>, nab@linux-iscsi.org
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Bharat,

Thanks for the patch, comment below.

> isert commands that failed during isert_rdma_rw_ctx_post() are queued to
> Queue-Full(QF) queue and are scheduled to be reposted during queue-full
> queue processing. During this reposting, the rdma contexts are initialised
> again in isert_rdma_rw_ctx_post(), which is leaking significant memory.
> 
> unreferenced object 0xffff8830201d9640 (size 64):
>    comm "kworker/0:2", pid 195, jiffies 4295374851 (age 4528.436s)
>    hex dump (first 32 bytes):
>      00 60 8b cb 2e 00 00 00 00 10 00 00 00 00 00 00  .`..............
>      00 90 e3 cb 2e 00 00 00 00 10 00 00 00 00 00 00  ................
>    backtrace:
>      [<ffffffff8170711e>] kmemleak_alloc+0x4e/0xb0
>      [<ffffffff811f8ba5>] __kmalloc+0x125/0x2b0
>      [<ffffffffa046b24f>] rdma_rw_ctx_init+0x15f/0x6f0 [ib_core]
>      [<ffffffffa07ab644>] isert_rdma_rw_ctx_post+0xc4/0x3c0 [ib_isert]
>      [<ffffffffa07ad972>] isert_put_datain+0x112/0x1c0 [ib_isert]
>      [<ffffffffa07dddce>] lio_queue_data_in+0x2e/0x30 [iscsi_target_mod]
>      [<ffffffffa076c322>] target_qf_do_work+0x2b2/0x4b0 [target_core_mod]
>      [<ffffffff81080c3b>] process_one_work+0x1db/0x5d0
>      [<ffffffff8108107d>] worker_thread+0x4d/0x3e0
>      [<ffffffff81088667>] kthread+0x117/0x150
>      [<ffffffff81713fa7>] ret_from_fork+0x27/0x40
>      [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Here is patch to use the older rdma contexts while reposting
> the isert commands intead of reinitialising them.
> 
> Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
> ---
>   drivers/infiniband/ulp/isert/ib_isert.c | 7 +++++++
>   drivers/infiniband/ulp/isert/ib_isert.h | 1 +
>   2 files changed, 8 insertions(+)
> 
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> index 720dfb3a1ac2..fd55163801a3 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -2123,6 +2123,9 @@ isert_rdma_rw_ctx_post(struct isert_cmd *cmd, struct isert_conn *conn,
>   	u32 rkey, offset;
>   	int ret;
>   
> +	if (cmd->ctx_init_done)
> +		goto rdma_ctx_post;
> +
>   	if (dir == DMA_FROM_DEVICE) {
>   		addr = cmd->write_va;
>   		rkey = cmd->write_stag;
> @@ -2150,11 +2153,15 @@ isert_rdma_rw_ctx_post(struct isert_cmd *cmd, struct isert_conn *conn,
>   				se_cmd->t_data_sg, se_cmd->t_data_nents,
>   				offset, addr, rkey, dir);
>   	}
> +
>   	if (ret < 0) {
>   		isert_err("Cmd: %p failed to prepare RDMA res\n", cmd);
>   		return ret;
>   	}
>   
> +	cmd->ctx_init_done = true;
> +
> +rdma_ctx_post:
>   	ret = rdma_rw_ctx_post(&cmd->rw, conn->qp, port_num, cqe, chain_wr);
>   	if (ret < 0)
>   		isert_err("Cmd: %p failed to post RDMA res\n", cmd);

I'm not convinced this is sufficient, for reads (isert_put_datain) we
need to skip duplicating the post_recv as well.
