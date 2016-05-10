From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: IB/hfi1: Fix buffer cache races which may cause corruption
Date: Tue, 10 May 2016 10:03:51 -0700
Message-ID: <20160510100351.243658aa@hematite.sc.intel.com>
References: <20160510104149.GA1326@mwanda>
	<20160510080432.6e651311@hematite.sc.intel.com>
	<20160510165709.GB19274@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160510165709.GB19274@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 10 May 2016 19:57:09 +0300
Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> I don't understand what a "correctness problem" is...  It's obviously
> wrong to use BIT(1) instead of BIT(0) but if it's done incorrectly every
> time and nothing else is using BIT(1) then it might not affect run time.
> Perhaps that's what you are saying?

Yes, that is what I was saying. I apologize for not being more clear.
Furthermore, even if it does not affect run time, we will still fix the
incorrect usage of BIT().

-- 
Thank you
Mitko
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
