From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/3] staging/rdma/hfi1: check return value of kcalloc
Date: Mon, 14 Dec 2015 15:21:24 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC259CD79F@fmsmsx120.amr.corp.intel.com>
References: <y> <1450104189-2653-1-git-send-email-hofrat@osadl.org>
 <1450104189-2653-2-git-send-email-hofrat@osadl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450104189-2653-2-git-send-email-hofrat-Q945KHDl0DbYtjvyW6yDsg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicholas Mc Guire <hofrat-Q945KHDl0DbYtjvyW6yDsg@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> @@ -10129,6 +10129,9 @@ static void init_qos(struct hfi1_devdata *dd,
> u32 first_ctxt)
>  	if (num_vls * qpns_per_vl > dd->chip_rcv_contexts)
>  		goto bail;
>  	rsmmap = kcalloc(NUM_MAP_REGS, sizeof(u64), GFP_KERNEL);
> +	if (!rsmmap)
> +		goto bail;
> +

I checked out a linux-next remote at the next-20151214 tag.

The allocation method is clearly kmalloc_array() not kcalloc().

Where are you seeing the kcalloc()?

While it is tempting to allocate and zero, there is a chip rev specific difference.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
