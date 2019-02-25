From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC v1 12/19] RDMA/irdma: Implement device supported verb APIs
Date: Mon, 25 Feb 2019 11:50:15 -0700
Message-ID: <20190225185015.GD21863@ziepe.ca>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-13-shiraz.saleem@intel.com>
 <01b0d571-81d8-ed6c-77b7-e83ee0ab9caa@amazon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <01b0d571-81d8-ed6c-77b7-e83ee0ab9caa@amazon.com>
Sender: netdev-owner@vger.kernel.org
To: Gal Pressman <galpress@amazon.com>
Cc: Shiraz Saleem <shiraz.saleem@intel.com>, dledford@redhat.com, davem@davemloft.net, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com, Yossi Leybovich <sleybo@amazon.com>
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 24, 2019 at 04:35:02PM +0200, Gal Pressman wrote:
> > +/**> + * irdma_disassociate_ucontext - Disassociate user context> + * @context: ib user context> + */> +static void irdma_disassociate_ucontext(struct ib_ucontext *context)
> > +{
> > +}
> 
> What's the motivation for a nop callback (over not implementing the
> function)?

This is my fault, I didn't finish yet and conver disassociate_ucontext
into a flags once they were all made empty.

> > +	ret = irdma_alloc_rsrc(iwdev->rf,
> > +			       iwdev->rf->allocated_mrs, iwdev->rf->max_mr,
> > +			       &stag_index, &next_stag_index);
> > +	if (!ret) {
> > +		stag = stag_index << IRDMA_CQPSQ_STAG_IDX_S;
> > +		stag |= driver_key;
> > +		stag += (u32)consumer_key;
> > +		irdma_add_devusecount(iwdev);
> > +	}
> 
> This is confusing IMHO, better to test for 'if (ret)' and keep the main flow
> unindented.

Yes please follow the standard 'success oriented flow'

Jason
