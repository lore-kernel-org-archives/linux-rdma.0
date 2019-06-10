From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH for-rc 3/3] IB/hfi1: Correct tid qp rcd to match verbs
 context
Date: Mon, 10 Jun 2019 13:03:54 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC70DA2848@fmsmsx120.amr.corp.intel.com>
References: <20190607113807.157915.48581.stgit@awfm-01.aw.intel.com>
 <20190607122538.158478.62945.stgit@awfm-01.aw.intel.com>
 <20190608081533.GO5261@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190608081533.GO5261@mtr-leonro.mtl.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>
Cc: "jgg@ziepe.ca" <jgg@ziepe.ca>, "dledford@redhat.com" <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "Wan, Kaike" <kaike.wan@intel.com>
List-Id: linux-rdma@vger.kernel.org

> > diff --git a/drivers/infiniband/hw/hfi1/tid_rdma.c
> b/drivers/infiniband/hw/hfi1/tid_rdma.c
> > index 6fb9303..d77276d 100644
> > --- a/drivers/infiniband/hw/hfi1/tid_rdma.c
> > +++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
> > @@ -312,9 +312,8 @@ static struct hfi1_ctxtdata *qp_to_rcd(struct
> rvt_dev_info *rdi,
> >  	if (qp->ibqp.qp_num == 0)
> >  		ctxt = 0;
> >  	else
> > -		ctxt = ((qp->ibqp.qp_num >> dd->qos_shift) %
> > -			(dd->n_krcv_queues - 1)) + 1;
> > -
> > +		ctxt = hfi1_get_qp_map(dd,
> > +				       (u8)(qp->ibqp.qp_num >> dd-
> >qos_shift));
> 
> It is one time use functions, why don't you handle this (u8) casting
> inside of hfi1_get_qp_map()?
> 

I assume the suggestion is to remove the u8 cast at the call site?

The function return value already is a u8 and there is a cast of the 64 bit CSR read result.

Mike
