From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH -next] IB/qib: Add missing err handle for
 qib_user_sdma_rb_insert
Date: Fri, 4 Jan 2019 15:38:05 -0700
Message-ID: <20190104223805.GG28190@ziepe.ca>
References: <20181221021938.13784-1-yuehaibing@huawei.com>
 <32E1700B9017364D9B60AED9960492BC70C11891@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC70C11891@fmsmsx120.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc: YueHaibing <yuehaibing@huawei.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 04, 2019 at 06:39:50PM +0000, Marciniszyn, Mike wrote:
> > diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c
> > b/drivers/infiniband/hw/qib/qib_user_sdma.c
> > index 31c523b..e87c0a7 100644
> > +++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
> > @@ -237,6 +237,8 @@ qib_user_sdma_queue_create(struct device *dev,
> > int unit, int ctxt, int sctxt)
> > 
> >  		ret = qib_user_sdma_rb_insert(&qib_user_sdma_rb_root,
> >  					sdma_rb_node);
> > +		if (ret == 0)
> > +			goto err_rb;
> >  	}
> >  	pq->sdma_rb_node = sdma_rb_node;
> > 
> 
> Thanks!
> 
> This patch is ok.

> The NULL returned from this routine will result in an error return up to PSM which will fail.
> 
> The bail branch will do the necessary cleanup, including freeing the
> node that couldn't be added.

How? sdma_rb_node is a stack variable that is not accessed during
cleanup?

Jason
