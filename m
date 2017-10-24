From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH] IB/hfi1: Fix a wrapping test (make it less strict)
Date: Tue, 24 Oct 2017 19:54:40 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC3443EB1C@fmsmsx120.amr.corp.intel.com>
References: <20171013105559.tqzh6jhcnvmqhdwy@mwanda>
 <1508771116.3325.0.camel@redhat.com>
 <36cdf5bf-a28c-e853-523d-8cf0fa748a56@intel.com>
 <1508783626.3325.16.camel@redhat.com>
 <20171023190400.GA24412@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20171023190400.GA24412@obsidianresearch.com>
Content-Language: en-US
Sender: kernel-janitors-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
Cc: "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, Dan Carpenter <dan.carpenter@oracle.com>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: Re: [PATCH] IB/hfi1: Fix a wrapping test (make it less strict)
> 
> On Mon, Oct 23, 2017 at 02:33:46PM -0400, Doug Ledford wrote:
> > > > > @@ -3781,7 +3781,7 @@ static int
> > > > > __subn_get_opa_hfi1_cong_log(struct
> > > > > opa_smp *smp, u32 am,
> > > > >   		 * required to wrap the counter are supposed to
> > > > >   		 * be zeroed (CA10-49 IBTA, release 1.2.1, V1).
> > > > >   		 */
> > > > > -		if ((u64)(ts - cce->timestamp) > (2 * UINT_MAX))
> > > > > +		if ((u64)(ts - cce->timestamp) > (2ULL *
> > > > > UINT_MAX))
> 
> This is really weird looking. Both ts and cce->timestamp are s64, why
> do the convoluted conversion to unsigned? And surely UINT_MAX is not
> the right thing..
> 
> if ((ts - cce->timestamp)/2 > 0xFFFFFFFF)
> 
> ?
> 
> ktime_get is defined to be monotonic, so ts - cce->timestamp should
> never go negative.
> 

I agree that this is an issue.

My proposal:
- Change s64 to u64 for ts and in timestamp in opa_hfi1_cong_log_event_internal
- Change the calls:
        ktime_to_ns(ktime_get()) / 1024
        -- to --
        ktime_get_ns() / 1024
- Change to use Jason's test from above with UINT_MAX

Dan, we can do the patch or you can send a v2?

Mike

