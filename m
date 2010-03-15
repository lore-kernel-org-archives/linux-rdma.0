From: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch] infiniband:  remove dead code
Date: Mon, 15 Mar 2010 18:07:35 +0300
Message-ID: <20100315150735.GM18181@bicker>
References: <20100315082332.GF18181@bicker> <20100315141846.GA1477@holoscopio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100315141846.GA1477-DmMZpsCg3uxeGPcbtGPokg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thadeu Lima de Souza Cascardo <cascardo-DmMZpsCg3uxeGPcbtGPokg@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 15, 2010 at 11:18:47AM -0300, Thadeu Lima de Souza Cascardo wrote:
> On Mon, Mar 15, 2010 at 11:23:32AM +0300, Dan Carpenter wrote:
> > "ret" is initialized to -ENOMEM so we don't need to set it here.
> > 
> > Signed-off-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > 
> > diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
> > index 308d17b..8fa6997 100644
> > --- a/drivers/infiniband/ulp/iser/iser_verbs.c
> > +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
> > @@ -148,10 +148,8 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
> >  	device = ib_conn->device;
> >  
> >  	ib_conn->login_buf = kmalloc(ISER_RX_LOGIN_SIZE, GFP_KERNEL);
> > -	if (!ib_conn->login_buf) {
> > +	if (!ib_conn->login_buf)
> >  		goto alloc_err;
> > -		ret = -ENOMEM;
> > -	}
> >  
> >  	ib_conn->login_dma = ib_dma_map_single(ib_conn->device->ib_device,
> >  				(void *)ib_conn->login_buf, ISER_RX_LOGIN_SIZE,
> > @@ -160,10 +158,9 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
> >  	ib_conn->page_vec = kmalloc(sizeof(struct iser_page_vec) +
> >  				    (sizeof(u64) * (ISCSI_ISER_SG_TABLESIZE +1)),
> >  				    GFP_KERNEL);
> > -	if (!ib_conn->page_vec) {
> > -		ret = -ENOMEM;
> > +	if (!ib_conn->page_vec)
> >  		goto alloc_err;
> > -	}
> > +
> >  	ib_conn->page_vec->pages = (u64 *) (ib_conn->page_vec + 1);
> >  
> >  	params.page_shift        = SHIFT_4K;
> 
> If there's a failure while allocating page_vec, login_buf will not be
> released. A single extra label should solve this.
> 
> Regards,
> Cascardo.

Hm...  Actually it looks like we should just remove both those
calls to kfree() and the ib_destroy_fmr_pool().  Otherwise we'll do
a double free when we get to iser_conn_release().

The call tree looks like this:
iser_connect() => iser_cma_handler() => iser_route_handler() 
	=> iser_create_ib_conn_res()

		We fail here and return failures back down the tree.

iser_connect() => iser_conn_release()

		Double free.

I will send a patch for this tomorrow.

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
