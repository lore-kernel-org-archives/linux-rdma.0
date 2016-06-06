From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH] IB/core: remove dead code
Date: Mon, 6 Jun 2016 09:50:54 +0100
Message-ID: <20160606085054.GC2324@sudip-tp>
References: <1465159552-11833-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20160606072243.GR7477@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160606072243.GR7477@leon.nu>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 06, 2016 at 10:22:43AM +0300, Leon Romanovsky wrote:
> On Sun, Jun 05, 2016 at 09:45:52PM +0100, Sudip Mukherjee wrote:
> > prot_sg_cnt has been assigned with the value of ret which we have
> > already checked to be non-zero so prot_sg_cnt can never be zero at this
> > point of the code and hence the else part can never execute.
> > 
> > Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> > ---
> >  drivers/infiniband/core/rw.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
> > index 1eb9b12..644589b 100644
> > --- a/drivers/infiniband/core/rw.c
> > +++ b/drivers/infiniband/core/rw.c
> > @@ -398,8 +398,6 @@ int rdma_rw_ctx_signature_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
> >  		else
> >  			prev_wr->next = &ctx->sig->prot.reg_wr.wr;
> >  		prev_wr = &ctx->sig->prot.reg_wr.wr;
> > -	} else {
> > -		ctx->sig->prot.mr = NULL;
> >  	}
> 
> You need to remove the "if (prot_sg_cnt) {" line too. There is no need
> in it after you removed "else" case.

ohhh, ofcourse. How silly of me.. :(
will send v2 tonight.

regards
sudip
