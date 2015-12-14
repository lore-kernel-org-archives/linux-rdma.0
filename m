From: Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH 2/3] staging/rdma/hfi1: check return value of kcalloc
Date: Mon, 14 Dec 2015 17:36:31 +0000
Message-ID: <20151214173631.GA22987@osadl.at>
References: <y>
 <1450104189-2653-1-git-send-email-hofrat@osadl.org>
 <1450104189-2653-2-git-send-email-hofrat@osadl.org>
 <32E1700B9017364D9B60AED9960492BC259CD79F@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC259CD79F@fmsmsx120.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc: Nicholas Mc Guire <hofrat@osadl.org>, Doug Ledford <dledford@redhat.com>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 14, 2015 at 03:21:24PM +0000, Marciniszyn, Mike wrote:
> > @@ -10129,6 +10129,9 @@ static void init_qos(struct hfi1_devdata *dd,
> > u32 first_ctxt)
> >  	if (num_vls * qpns_per_vl > dd->chip_rcv_contexts)
> >  		goto bail;
> >  	rsmmap = kcalloc(NUM_MAP_REGS, sizeof(u64), GFP_KERNEL);
> > +	if (!rsmmap)
> > +		goto bail;
> > +
> 
> I checked out a linux-next remote at the next-20151214 tag.
> 
> The allocation method is clearly kmalloc_array() not kcalloc().
> 
> Where are you seeing the kcalloc()?
> 
> While it is tempting to allocate and zero, there is a chip rev specific difference.
>
x = kmalloc_array(...)
if(!x)
   ...
memset(x...)

should be equivalent to

kcalloc - include/linux/slab.h

static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
{
        return kmalloc_array(n, size, flags | __GFP_ZERO);
}

if the assumption that this is equvalent is wrong I appologize
the intent was simply API consolidation as the patch description
stated.

thx!
hofrta
