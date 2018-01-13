From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [RFC] iser-target: avoid reinitializing rdma contexts for isert
 commands
Date: Fri, 12 Jan 2018 22:20:43 -0800
Message-ID: <1515824443.24576.108.camel@haakon3.daterainc.com>
References: <1511893687-29298-1-git-send-email-bharat@chelsio.com>
         <20171218231439.GA31621@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171218231439.GA31621-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Bharat Potnuri <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason & Co,

Thanks for picking this up.

On Mon, 2017-12-18 at 16:14 -0700, Jason Gunthorpe wrote:
> On Tue, Nov 28, 2017 at 11:58:07PM +0530, Bharat Potnuri wrote:
> > isert commands that failed during isert_rdma_rw_ctx_post() are queued to
> > Queue-Full(QF) queue and are scheduled to be reposted during queue-full
> > queue processing. During this reposting, the rdma contexts are initialised
> > again in isert_rdma_rw_ctx_post(), which is leaking significant memory.
> > 
> > unreferenced object 0xffff8830201d9640 (size 64):
> >   comm "kworker/0:2", pid 195, jiffies 4295374851 (age 4528.436s)
> >   hex dump (first 32 bytes):
> >     00 60 8b cb 2e 00 00 00 00 10 00 00 00 00 00 00  .`..............
> >     00 90 e3 cb 2e 00 00 00 00 10 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<ffffffff8170711e>] kmemleak_alloc+0x4e/0xb0
> >     [<ffffffff811f8ba5>] __kmalloc+0x125/0x2b0
> >     [<ffffffffa046b24f>] rdma_rw_ctx_init+0x15f/0x6f0 [ib_core]
> >     [<ffffffffa07ab644>] isert_rdma_rw_ctx_post+0xc4/0x3c0 [ib_isert]
> >     [<ffffffffa07ad972>] isert_put_datain+0x112/0x1c0 [ib_isert]
> >     [<ffffffffa07dddce>] lio_queue_data_in+0x2e/0x30 [iscsi_target_mod]
> >     [<ffffffffa076c322>] target_qf_do_work+0x2b2/0x4b0 [target_core_mod]
> >     [<ffffffff81080c3b>] process_one_work+0x1db/0x5d0
> >     [<ffffffff8108107d>] worker_thread+0x4d/0x3e0
> >     [<ffffffff81088667>] kthread+0x117/0x150
> >     [<ffffffff81713fa7>] ret_from_fork+0x27/0x40
> >     [<ffffffffffffffff>] 0xffffffffffffffff
> > 
> > Here is patch to use the older rdma contexts while reposting
> > the isert commands intead of reinitialising them.
> > 
> > Signed-off-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> > Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> >  drivers/infiniband/ulp/isert/ib_isert.c | 7 +++++++
> >  drivers/infiniband/ulp/isert/ib_isert.h | 1 +
> >  2 files changed, 8 insertions(+)
> 
> Thanks, applied to RDMA for-next
> 
> Jason

Per Potnuri, it should be stable CC' to 4.11.y, and depends on:

7a56dc8 iser-target: avoid posting a recv buffer twice
555a65f iser-target: Fix queue-full response handling
fa7e25c target: Fix unknown fabric callback queue-full errors

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
