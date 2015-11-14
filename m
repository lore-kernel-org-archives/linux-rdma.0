From: Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/13] staging/rdma/hfi1: Use BIT macro
Date: Sat, 14 Nov 2015 12:41:02 +0530
Message-ID: <20151114071102.GE3685@sudip-pc>
References: <1447227213-15122-1-git-send-email-jubin.john@intel.com>
 <20151113131558.GC18741@sudip-pc>
 <20151113160921.GA31028@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151113160921.GA31028-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 13, 2015 at 11:09:22AM -0500, Jubin John wrote:
> On Fri, Nov 13, 2015 at 06:45:58PM +0530, Sudip Mukherjee wrote:
> > On Wed, Nov 11, 2015 at 02:33:21AM -0500, Jubin John wrote:
> > > This patch fixes the checkpatch issue:
> > > CHECK: Prefer using the BIT macro
> > >=20
> > > Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > ---
> > <snip>
> > > =20
> > > diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/r=
dma/hfi1/init.c
> > > index 8666f3a..680f877 100644
> > > --- a/drivers/staging/rdma/hfi1/init.c
> > > +++ b/drivers/staging/rdma/hfi1/init.c
> > > @@ -252,7 +252,7 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(st=
ruct hfi1_pportdata *ppd, u32 ctxt)
> > >  		/* Validate and initialize Rcv Hdr Q variables */
> > >  		if (rcvhdrcnt % HDRQ_INCREMENT) {
> > >  			dd_dev_err(dd,
> > > -				   "ctxt%u: header queue count %d must be divisible by %d\n"=
,
> > > +				   "ctxt%u: header queue count %d must be divisible by %lud\=
n",
> >=20
> > This is an unrelated change. If you are sending the series based on
> > Dan's comment on 12/13 then please remove this also.
> >=20
> This is not an unrelated change. This was needed due to the use of th=
e
> BIT macro for HDRQ_INCREMENT in chip.h.
> Otherwise, the following warning is shown during the build:
> drivers/staging/rdma/hfi1/init.c: In function =E2=80=98hfi1_create_ct=
xtdata=E2=80=99:
> drivers/staging/rdma/hfi1/init.c:254:4: warning: format =E2=80=98%u=E2=
=80=99 expects
> argument of type =E2=80=98unsigned int=E2=80=99, but argument 6 has t=
ype
> =E2=80=98long unsigned int=E2=80=99 [-Wformat=3D]
>     dd_dev_err(dd,

Then it should have better been mentioned in the commit message.

regards
sudip
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
