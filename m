From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] infiniband: fix a possible use-after-free bug
Date: Mon, 4 Jun 2018 10:46:31 -0600
Message-ID: <20180604164631.GB12777@ziepe.ca>
References: <20180601183144.17374-1-xiyou.wangcong@gmail.com>
 <CAJX1YtZNdwiwPmj5gGTqURjvLqa5g7Ly_h+TEZfNJSW=mrqRiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJX1YtZNdwiwPmj5gGTqURjvLqa5g7Ly_h+TEZfNJSW=mrqRiQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gi-Oh Kim <gi-oh.kim@profitbricks.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org, noamr@beyondsecurity.com, Sean Hefty <sean.hefty@intel.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 04, 2018 at 06:23:20PM +0200, Gi-Oh Kim wrote:
> On Fri, Jun 1, 2018 at 8:31 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > ucma_process_join() will free the new allocated "mc" struct,
> > if there is any error after that, especially the copy_to_user().
> >
> > But in parallel, ucma_leave_multicast() could find this "mc"
> > through idr_find() before ucma_process_join() frees it, since it
> > is already published.
> >
> > So "mc" could be used in ucma_leave_multicast() after it is been
> > allocated and freed in ucma_process_join(), since we don't refcnt
> > it.
> >
> > Fix this by separating "publish" from ID allocation, so that we
> > can get an ID first and publish it later after copy_to_user().
> >
> > Fixes c8f6a362bf3e ("RDMA/cma: Add multicast communication support")
> > Reported-by: Noam Rathaus <noamr@beyondsecurity.com>
> > Cc: Sean Hefty <sean.hefty@intel.com>
> > Cc: Doug Ledford <dledford@redhat.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > Cc: linux-rdma@vger.kernel.org
> > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> >  drivers/infiniband/core/ucma.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
> > index eab43b17e9cf..ec8fb289621f 100644
> > +++ b/drivers/infiniband/core/ucma.c
> > @@ -235,7 +235,7 @@ static struct ucma_multicast* ucma_alloc_multicast(struct ucma_context *ctx)
> >                 return NULL;
> >
> >         mutex_lock(&mut);
> > -       mc->id = idr_alloc(&multicast_idr, mc, 0, 0, GFP_KERNEL);
> > +       mc->id = idr_alloc(&multicast_idr, NULL, 0, 0, GFP_KERNEL);
> >         mutex_unlock(&mut);
> >         if (mc->id < 0)
> >                 goto error;
> > @@ -1421,6 +1421,10 @@ static ssize_t ucma_process_join(struct ucma_file *file,
> >                 goto err3;
> >         }
> >
> > +       mutex_lock(&mut);
> > +       idr_replace(&multicast_idr, mc, mc->id);
> > +       mutex_unlock(&mut);
> > +
> >         mutex_unlock(&file->mut);
> >         ucma_put_ctx(ctx);
> >         return 0;
> >
> 
> 
> Hi,
> 
> Your patch is reasonable to me.
> Can I ask a question for that?
> Could it be solved by asymmetric locking as following?

No, there are many other paths that touch multicast_idr that don't
hold both locks, we should protect all of them from accessing an
incompletely initialized structure.

Jason
