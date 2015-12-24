From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 0/3] Add cross-channel support
Date: Thu, 24 Dec 2015 12:41:21 +0200
Message-ID: <567BCBD1.708@mellanox.com>
References: <1450606571-15877-1-git-send-email-leon@leon.nu>
 <567BA695.8050403@mellanox.com> <20151224100001.GA21387@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151224100001.GA21387-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/24/2015 12:00 PM, Christoph Hellwig wrote:
> On Thu, Dec 24, 2015 at 10:02:29AM +0200, Or Gerlitz wrote:
>> We had consensus among the reviewers that the 1st patch ("IB/core: Align
>> coding style of ib_device_cap_flags structure") is wrong cleanup which
>> basically is (1) unneeded (2) creates more damage (git blame and such,
>> non-applicable to uapi, more) than benefit, etc -- finally Leon was
>> convinced too [1].
> It's not really an issue vs uapi.  Using the the wierd BIT() macro
> would have been, but without it I think this cleanup is ok, even if I
> personally wouldn't have done it.  git-blame isn't really a major
> issue either, as you can blame past revisions.

I would personally wouldn't done cleanup either and I managed to 
convinced Leon to drop it, so we had concensus among the developers, the 
maintainer didn't have other opinion and he took the wrong step -- so 
we're asking to fix, that's all.
>
>> Leon will re-spin in the coming 1-2 hours V2, could please pick it instead
>> of V1, when people agree on direction X and you are not against it, lets do
>> X and not Y.
> It would be great if we could stop rebasing whats already in the tree
> for the benefit of everyone building on top of this.  For example just
> finished rebasing my series to move many constants includin this one
> to the uapi headers, and I'd hate to rebase it once again now that
> the dust has settled.

The root issue here is that nothing was picked before 4.4-rc6, so we're 
in a situation where rebases are needed in the own-maintainer tree 
(github) to make things right. No way to avoid that.

We should aim that for 4.6 and onward, code for -next will start getting 
in around rc1-2 and then things will be more robust, etc

Or.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
