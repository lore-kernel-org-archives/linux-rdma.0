From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC] iser-target: avoid reinitializing rdma contexts for isert
 commands
Date: Wed, 13 Dec 2017 10:51:04 -0700
Message-ID: <20171213175104.GA14143@ziepe.ca>
References: <1511893687-29298-1-git-send-email-bharat@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1511893687-29298-1-git-send-email-bharat@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: Bharat Potnuri <bharat@chelsio.com>
Cc: nab@linux-iscsi.org, sagi@grimberg.me, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 28, 2017 at 11:58:07PM +0530, Bharat Potnuri wrote:
> isert commands that failed during isert_rdma_rw_ctx_post() are queued to
> Queue-Full(QF) queue and are scheduled to be reposted during queue-full
> queue processing. During this reposting, the rdma contexts are initialised
> again in isert_rdma_rw_ctx_post(), which is leaking significant memory.
> 
> unreferenced object 0xffff8830201d9640 (size 64):
>   comm "kworker/0:2", pid 195, jiffies 4295374851 (age 4528.436s)
>   hex dump (first 32 bytes):
>     00 60 8b cb 2e 00 00 00 00 10 00 00 00 00 00 00  .`..............
>     00 90 e3 cb 2e 00 00 00 00 10 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff8170711e>] kmemleak_alloc+0x4e/0xb0
>     [<ffffffff811f8ba5>] __kmalloc+0x125/0x2b0
>     [<ffffffffa046b24f>] rdma_rw_ctx_init+0x15f/0x6f0 [ib_core]
>     [<ffffffffa07ab644>] isert_rdma_rw_ctx_post+0xc4/0x3c0 [ib_isert]
>     [<ffffffffa07ad972>] isert_put_datain+0x112/0x1c0 [ib_isert]
>     [<ffffffffa07dddce>] lio_queue_data_in+0x2e/0x30 [iscsi_target_mod]
>     [<ffffffffa076c322>] target_qf_do_work+0x2b2/0x4b0 [target_core_mod]
>     [<ffffffff81080c3b>] process_one_work+0x1db/0x5d0
>     [<ffffffff8108107d>] worker_thread+0x4d/0x3e0
>     [<ffffffff81088667>] kthread+0x117/0x150
>     [<ffffffff81713fa7>] ret_from_fork+0x27/0x40
>     [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Here is patch to use the older rdma contexts while reposting
> the isert commands intead of reinitialising them.
> 
> Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
>  drivers/infiniband/ulp/isert/ib_isert.c | 7 +++++++
>  drivers/infiniband/ulp/isert/ib_isert.h | 1 +
>  2 files changed, 8 insertions(+)
>

So this RFC got Reviewed-by Sagi, is it to be applied now or something
else??

If yes, what tree does it want to go through? I see Nicholas and Doug
have both been historically taking isert patches.

Thanks,
Jason
