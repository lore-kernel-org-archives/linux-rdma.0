From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5 5/9] IB/isert: Replace semaphore sem with completion
Date: Mon, 21 Nov 2016 11:22:12 +0100
Message-ID: <2625189.HB0S3sfnY7@wuerfel>
References: <1479708496-9828-1-git-send-email-binoy.jayan@linaro.org> <1479708496-9828-6-git-send-email-binoy.jayan@linaro.org> <e1e4788d-9250-d4c3-937f-262bd9264a76@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e1e4788d-9250-d4c3-937f-262bd9264a76@grimberg.me>
Sender: linux-kernel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Binoy Jayan <binoy.jayan@linaro.org>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Jenny Derzhavetz <jennyf@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Steve Wise <swise@opengridcomputing.com>, Mark Bloch <markb@mellanox.com>, Tatyana E Nikolova <tatyana.e.nikolova@intel.com>, Matan Barak <matanb@mellanox.com>, Lijun Ou <oulijun@huawei.com>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Faisal Latif <faisal.latif@intel.com>, Mustafa Ismail <mustafa.ismail@intel.com>, Mark Brown <broonie@kernel.org>, linux-rdma@vg
List-Id: linux-rdma@vger.kernel.org

On Monday, November 21, 2016 9:36:22 AM CET Sagi Grimberg wrote:
> > diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> > index 6dd43f6..de80f56 100644
> > --- a/drivers/infiniband/ulp/isert/ib_isert.c
> > +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> > @@ -619,7 +619,7 @@
> >       mutex_unlock(&isert_np->mutex);
> >
> >       isert_info("np %p: Allow accept_np to continue\n", isert_np);
> > -     up(&isert_np->sem);
> > +     complete(&isert_np->comp);
> >  }
> >
> >  static void
> > @@ -2311,7 +2311,7 @@ struct rdma_cm_id *
> >               isert_err("Unable to allocate struct isert_np\n");
> >               return -ENOMEM;
> >       }
> > -     sema_init(&isert_np->sem, 0);
> > +     init_completion(&isert_np->comp);
> 
> This is still racy, a connect event can complete just before we
> init the completion and *will* get lost...
> 
> This code started off with a waitqueue which exposes the same
> problem, see:
> 531b7bf4bd79 Target/iser: Fix iscsit_accept_np and rdma_cm racy flow
> 
> So, still NAK from me...

I don't see what you mean here. The code using a waitqueue had no
counter but the completion does. I had suggested that Binoy add
a comment into the code about this, as it is a rarely used
property of completions, but it does seem entirely valid to me.

	Arnd
