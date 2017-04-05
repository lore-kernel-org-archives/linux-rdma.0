From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/5] IB/qib: Use kcalloc() in qib_init_iba7322_funcs()
Date: Wed, 5 Apr 2017 17:06:58 +0200
Message-ID: <20170405150658.GU3941@linux-x5ow.site>
References: <c16b18ac-287f-5faf-b79a-c86e2adfa22c@users.sourceforge.net>
 <5e5e00d3-b6a4-7371-65be-c5fe387d26b3@users.sourceforge.net>
 <20170405143438.GC5006@yuval-lap>
 <fa90e815-daff-57b1-7930-447c6f5fa3ab@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fa90e815-daff-57b1-7930-447c6f5fa3ab@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mike Marciniszyn <infinipath@intel.com>, Sean Hefty <sean.hefty@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 05, 2017 at 04:54:40PM +0200, SF Markus Elfring wrote:
> >> @@ -7324,8 +7324,9 @@ struct qib_devdata *qib_init_iba7322_funcs(struct pci_dev *pdev,
> >>  		actual_cnt -= dd->num_pports;
> >>  
> >>  	tabsize = actual_cnt;
> >> -	dd->cspec->msix_entries = kzalloc(tabsize *
> >> -			sizeof(struct qib_msix_entry), GFP_KERNEL);
> >> +	dd->cspec->msix_entries = kcalloc(tabsize,
> >> +					  sizeof(*dd->cspec->msix_entries),
> >> +					  GFP_KERNEL);
> > 
> > Are we fine with loosing the zeroing of the entries?
> 
> How did you get this concern?
> 
> Do you really miss such functionality from the other interface?

Ahm... Don't kzalloc() and kcalloc() both pass in __GFP_ZERO?

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
