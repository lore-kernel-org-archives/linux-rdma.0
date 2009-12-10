From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: Sun V880 + Infiniband?
Date: Wed, 09 Dec 2009 17:20:53 -0800 (PST)
Message-ID: <20091209.172053.211572407.davem@davemloft.net>
References: <200912030144.18971.pat@computer-refuge.org>
	<20091209.013955.262196704.davem@davemloft.net>
	<200912091429.56117.pat@computer-refuge.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <200912091429.56117.pat-bdq14YP6qtQCo4FBHZViTkB+6BGkLq7r@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: pat-bdq14YP6qtQCo4FBHZViTkB+6BGkLq7r@public.gmane.org
Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Patrick Finnegan <pat-bdq14YP6qtQCo4FBHZViTkB+6BGkLq7r@public.gmane.org>
Date: Wed, 9 Dec 2009 14:29:56 -0500

> On Wednesday 09 December 2009, David Miller wrote:
>> Please give this patch a try:
>> 
>> sparc64: Fix overly strict range type matching for PCI devices.
> 
> This appears to work for me.
> 
> Thanks!

Thanks for your report and testing the fix.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
