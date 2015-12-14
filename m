From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/3] staging/rdma/hfi1: consolidate kmalloc_array+memset
 into kcalloc
Date: Mon, 14 Dec 2015 15:28:46 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC259CD82D@fmsmsx120.amr.corp.intel.com>
References: <y> <1450104189-2653-1-git-send-email-hofrat@osadl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450104189-2653-1-git-send-email-hofrat-Q945KHDl0DbYtjvyW6yDsg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicholas Mc Guire <hofrat-Q945KHDl0DbYtjvyW6yDsg@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> --- a/drivers/staging/rdma/hfi1/chip.c
> +++ b/drivers/staging/rdma/hfi1/chip.c
> @@ -10128,8 +10128,7 @@ static void init_qos(struct hfi1_devdata *dd,
> u32 first_ctxt)
>  		goto bail;
>  	if (num_vls * qpns_per_vl > dd->chip_rcv_contexts)
>  		goto bail;
> -	rsmmap = kmalloc_array(NUM_MAP_REGS, sizeof(u64),
> GFP_KERNEL);
> -	memset(rsmmap, rxcontext, NUM_MAP_REGS * sizeof(u64));
> +	rsmmap = kcalloc(NUM_MAP_REGS, sizeof(u64), GFP_KERNEL);
>  	/* init the local copy of the table */
>  	for (i = 0, ctxt = first_ctxt; i < num_vls; i++) {
>  		unsigned tctxt;
> --

I'm NAKing this.

There is a chip specific difference that accounts for the current code.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
