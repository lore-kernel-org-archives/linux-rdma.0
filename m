From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH for-rc v2 1/6] IB/hfi1: Fix handling of FECN marked
 multicast packet
Date: Tue, 1 May 2018 21:58:49 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC6281B784@fmsmsx120.amr.corp.intel.com>
References: <20180501123317.24520.8848.stgit@scvm10.sc.intel.com>
 <20180501123532.24520.80857.stgit@scvm10.sc.intel.com>
 <20180501180531.GB17027@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180501180531.GB17027@ziepe.ca>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Hiatt, Don" <don.hiatt@intel.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "Ruhl, Michael J" <michael.j.ruhl@intel.com>
List-Id: linux-rdma@vger.kernel.org

> Subject: Re: [PATCH for-rc v2 1/6] IB/hfi1: Fix handling of FECN marked
> multicast packet
> 
> On Tue, May 01, 2018 at 05:35:36AM -0700, Dennis Dalessandro wrote:
> > @@ -719,7 +719,7 @@ void return_cnp(struct hfi1_ibport *ibp, struct
> rvt_qp *qp, u32 remote_qpn,
> >
> >  	lrh0 |= (sc5 & 0xf) << 12 | sl << 4;
> >
> > -	bth0 = pkey | (IB_OPCODE_CNP << 24);
> > +	bth0 = (u32)pkey | (IB_OPCODE_CNP << 24);
> 

I'm verifying the fix w/o the cast...

But I see Doug pulled the fix?

Mike
