From: Gi-Oh Kim <gi-oh.kim@profitbricks.com>
Subject: Re: [PATCH] infiniband: fix a possible use-after-free bug
Date: Mon, 4 Jun 2018 18:23:20 +0200
Message-ID: <CAJX1YtZNdwiwPmj5gGTqURjvLqa5g7Ly_h+TEZfNJSW=mrqRiQ@mail.gmail.com>
References: <20180601183144.17374-1-xiyou.wangcong@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180601183144.17374-1-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, noamr@beyondsecurity.com, Sean Hefty <sean.hefty@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 1, 2018 at 8:31 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> ucma_process_join() will free the new allocated "mc" struct,
> if there is any error after that, especially the copy_to_user().
>
> But in parallel, ucma_leave_multicast() could find this "mc"
> through idr_find() before ucma_process_join() frees it, since it
> is already published.
>
> So "mc" could be used in ucma_leave_multicast() after it is been
> allocated and freed in ucma_process_join(), since we don't refcnt
> it.
>
> Fix this by separating "publish" from ID allocation, so that we
> can get an ID first and publish it later after copy_to_user().
>
> Fixes c8f6a362bf3e ("RDMA/cma: Add multicast communication support")
> Reported-by: Noam Rathaus <noamr@beyondsecurity.com>
> Cc: Sean Hefty <sean.hefty@intel.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: linux-rdma@vger.kernel.org
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  drivers/infiniband/core/ucma.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucm=
a.c
> index eab43b17e9cf..ec8fb289621f 100644
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
> @@ -235,7 +235,7 @@ static struct ucma_multicast* ucma_alloc_multicast(st=
ruct ucma_context *ctx)
>                 return NULL;
>
>         mutex_lock(&mut);
> -       mc->id =3D idr_alloc(&multicast_idr, mc, 0, 0, GFP_KERNEL);
> +       mc->id =3D idr_alloc(&multicast_idr, NULL, 0, 0, GFP_KERNEL);
>         mutex_unlock(&mut);
>         if (mc->id < 0)
>                 goto error;
> @@ -1421,6 +1421,10 @@ static ssize_t ucma_process_join(struct ucma_file =
*file,
>                 goto err3;
>         }
>
> +       mutex_lock(&mut);
> +       idr_replace(&multicast_idr, mc, mc->id);
> +       mutex_unlock(&mut);
> +
>         mutex_unlock(&file->mut);
>         ucma_put_ctx(ctx);
>         return 0;
> --
> 2.13.0
>


Hi,

Your patch is reasonable to me.
Can I ask a question for that?
Could it be solved by asymmetric locking as following?


diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.=
c
index eab43b17e9cf..d8b256baec31 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1493,6 +1493,7 @@ static ssize_t ucma_leave_multicast(struct
ucma_file *file,
        if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
                return -EFAULT;

+       mutex_lock(&mc->ctx->file->mut);
        mutex_lock(&mut);
        mc =3D idr_find(&multicast_idr, cmd.id);
        if (!mc)
@@ -1507,11 +1508,11 @@ static ssize_t ucma_leave_multicast(struct
ucma_file *file,

        if (IS_ERR(mc)) {
                ret =3D PTR_ERR(mc);
+               mutex_unlock(&mc->ctx->file->mut);
                goto out;
        }

        rdma_leave_multicast(mc->ctx->cm_id, (struct sockaddr *) &mc->addr)=
;
-       mutex_lock(&mc->ctx->file->mut);
        ucma_cleanup_mc_events(mc);
        list_del(&mc->list);
        mutex_unlock(&mc->ctx->file->mut);



--=20
GIOH KIM
Linux Kernel Entwickler

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 176 2697 8962
Fax:      +49 30 577 008 299
Email:    gi-oh.kim@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss, Matthias Steinberg, Christoph Steff=
ens
