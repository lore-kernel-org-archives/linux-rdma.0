From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V7 libibverbs 0/7] Add extension and XRC QP support
Date: Mon, 15 Jul 2013 18:10:46 -0600
Message-ID: <20130716001046.GA9237@obsidianresearch.com>
References: <1373555063-31790-1-git-send-email-yishaih@mellanox.com>
 <20130711170710.GB27357@obsidianresearch.com>
 <51E3EDCF.2050007@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51E3EDCF.2050007-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 15, 2013 at 03:40:47PM +0300, Yishai Hadas wrote:
> Hi Jason,
> 
> Let me clarify the place holder reservation mentioned in the cover
> letter.  The entries I was referring to are not proprietary vendor
> verbs but rather user space verbs who are on their way to be
> submitted upstream for inclusion in libibverbs/libmlx4.

I get that.

But it doesn't make one difference. Until they reach Roland's tree
*nobody* gets to use indexes in the extension structure with the
'libibverbs.so.1' SONAME.

PERIOD. NO EXCEPTIONS.

> So in that respect, it would make sense for us as vendor to provide
> customers through mellanox ofed the means to use them.

You can provide whatever you like in your Mellanox software releases.

If you use the libibverbs.so.1 SONAME and mess with the ABI you get to
keep all the broken bits and angry users when upstream does something
different.

OFA has already committed to stop this nonsense and no longer ship
upstream incompatible libraries.

As a vendor, when you make ABI incompatible changes like this you have
to change the SONAME/symbols. There is no other answer, you must do
it.

> What asked now is to reserve the pointers, no more.  As for the

The only reason you are going to care about the actual indexes is
because you are already shipping code that uses them. That means
you've already made the choice of what index has what function
signature.

So you are asking that upstream adpot the ABI you are already shipping
without alteration. Why on earth should that happen? Especially when
some of the index/signature pairs have apparently never even been
posted to the list????

NO. This is a bad precedent. Upstream sets the ABI, not the vendors.

PERIOD.

> To sum up, we think it would be constructive step to continue with
> this series while reserving the six pointers, or if this really
> helps submit for review the libibverbs part of those verbs along
> with the basic verbs extensions patches.

Frankly, this nonsense makes me question if the extension mechanism is
even a sane idea if this is the sort of abuse it is going to be
subject too.

AFAIK, Roland has not commented on any of these series, or the basic
extension mechanism.

I think we all need to hear his opinion.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
