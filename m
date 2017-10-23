From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] IB/hfi1: Fix a wrapping test (make it less strict)
Date: Mon, 23 Oct 2017 13:04:00 -0600
Message-ID: <20171023190400.GA24412@obsidianresearch.com>
References: <20171013105559.tqzh6jhcnvmqhdwy@mwanda>
 <1508771116.3325.0.camel@redhat.com>
 <36cdf5bf-a28c-e853-523d-8cf0fa748a56@intel.com>
 <1508783626.3325.16.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1508783626.3325.16.camel@redhat.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>, Dan Carpenter <dan.carpenter@oracle.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 23, 2017 at 02:33:46PM -0400, Doug Ledford wrote:
> > > > @@ -3781,7 +3781,7 @@ static int
> > > > __subn_get_opa_hfi1_cong_log(struct
> > > > opa_smp *smp, u32 am,
> > > >   		 * required to wrap the counter are supposed to
> > > >   		 * be zeroed (CA10-49 IBTA, release 1.2.1, V1).
> > > >   		 */
> > > > -		if ((u64)(ts - cce->timestamp) > (2 * UINT_MAX))
> > > > +		if ((u64)(ts - cce->timestamp) > (2ULL *
> > > > UINT_MAX))

This is really weird looking. Both ts and cce->timestamp are s64, why
do the convoluted conversion to unsigned? And surely UINT_MAX is not
the right thing..

if ((ts - cce->timestamp)/2 > 0xFFFFFFFF)

?

ktime_get is defined to be monotonic, so ts - cce->timestamp should
never go negative.

Jason
