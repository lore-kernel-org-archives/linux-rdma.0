From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next] RDMA/cxgb4: Remove unnecessary conversion from __be32 to cpu format
Date: Wed, 25 Oct 2017 09:46:18 -0500
Message-ID: <020c01d34da0$04115ff0$0c341fd0$@opengridcomputing.com>
References: <20171024182848.7945-1-leon@kernel.org> <067301d34cf7$d0872ff0$71958fd0$@opengridcomputing.com> <20171024185956.GL16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171024185956.GL16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > > @@ -234,7 +234,7 @@ struct t4_cqe {
> > >
> > >  /* used for SQ completion processing */
> > >  #define CQE_WRID_SQ_IDX(x)	((x)->u.scqe.cidx)
> > > -#define CQE_WRID_FR_STAG(x)     (be32_to_cpu((x)->u.scqe.stag))
> > > +#define CQE_WRID_FR_STAG(x)     ((x)->u.scqe.stag)
> >
> > This is incorrect.  The stag is filled in by HW which is BE.  The
declaration of
> > scqe.stag needs to be __be32.
> 
> So why do you declare stag as u32?

I'm saying it is a bug that stag is declared as u32.  t4_cqe.u.scqe.stag should
be declared as __be32.

So the fix for the sparse warning should be something like this:

diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index e765c00..bcb80ca6 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -171,7 +171,7 @@ struct t4_cqe {
                        __be32 msn;
                } rcqe;
                struct {
-                       u32 stag;
+                       __be32 stag;
                        u16 nada2;
                        u16 cidx;
                } scqe;

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
