From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: IB/hfi1: Fix buffer cache races which may cause corruption
Date: Tue, 10 May 2016 19:57:09 +0300
Message-ID: <20160510165709.GB19274@mwanda>
References: <20160510104149.GA1326@mwanda>
 <20160510080432.6e651311@hematite.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160510080432.6e651311-xX4rS/KCtk00dzWUSSna/BL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 10, 2016 at 08:04:32AM -0700, Mitko Haralanov wrote:
> On Tue, 10 May 2016 13:41:49 +0300
> Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > The patch e88c9271d9f8: "IB/hfi1: Fix buffer cache races which may
> > cause corruption" from Apr 12, 2016, leads to the following static
> > checker warning:
> > 
> > 	drivers/staging/rdma/hfi1/user_sdma.c:1053 sdma_cache_evict()
> > 	warn: test_bit() takes a bit number
> 
> Hi Dan,
> 
> Thank you for reporting this issue. I've double checked and while
> there is no correctness problem at this time, we will fix the
> set_bit()/test_bit() argument.

I don't understand what a "correctness problem" is...  It's obviously
wrong to use BIT(1) instead of BIT(0) but if it's done incorrectly every
time and nothing else is using BIT(1) then it might not affect run time.
Perhaps that's what you are saying?

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
