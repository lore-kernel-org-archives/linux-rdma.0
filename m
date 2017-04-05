From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: Re: [PATCH 5/5] IB/qib: Adjust two size determinations in
 qib_init_pportdata()
Date: Wed, 5 Apr 2017 18:15:26 +0300
Message-ID: <20170405151525.GA5519@yuval-lap>
References: <c16b18ac-287f-5faf-b79a-c86e2adfa22c@users.sourceforge.net>
 <b5bc4160-aace-b919-7fe2-a4742d03c4ba@users.sourceforge.net>
 <20170405143242.GB5006@yuval-lap>
 <523b0864-e655-ed1f-8fe5-5995e0b0bde1@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <523b0864-e655-ed1f-8fe5-5995e0b0bde1@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mike Marciniszyn <infinipath@intel.com>, Sean Hefty <sean.hefty@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 05, 2017 at 05:04:35PM +0200, SF Markus Elfring wrote:
> >> @@ -270,13 +268,14 @@ int qib_init_pportdata(struct qib_pportdata *ppd, struct qib_devdata *dd,
> >>  	if (!ppd->congestion_entries)
> >>  		goto bail_1;
> >>  
> >> -	size = sizeof(struct cc_table_shadow);
> >> -	ppd->ccti_entries_shadow = kzalloc(size, GFP_KERNEL);
> >> +	ppd->ccti_entries_shadow = kzalloc(sizeof(*ppd->ccti_entries_shadow),
> >> +					   GFP_KERNEL);
> >>  	if (!ppd->ccti_entries_shadow)
> >>  		goto bail_2;
> >>  
> >> -	size = sizeof(struct ib_cc_congestion_setting_attr);
> >> -	ppd->congestion_entries_shadow = kzalloc(size, GFP_KERNEL);
> >> +	ppd->congestion_entries_shadow = kzalloc(sizeof(*ppd
> >> +							->congestion_entries_shadow),
> >> +						 GFP_KERNEL);
> > 
> > Not related to this patch but is related to your patch-set - can you check
> > the array allocations in lines 264 and 268?
> 
> Do you refer to source code places here which are affected by the update step
> "[PATCH 4/5] IB/qib: Use kcalloc() in qib_init_pportdata()"?

Oops, please ignore.

> 
> 
> > Besides that:
> > Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
> 
> Do you find the proposed change for the shown data types really acceptable
> in these function calls?

I found that the fix brings no harm to the existing code.

> 
> Regards,
> Markus
