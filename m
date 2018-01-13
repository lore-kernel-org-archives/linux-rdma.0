From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/4] RDMA mlx4/mlx5 fixes
Date: Sat, 13 Jan 2018 13:46:09 -0700
Message-ID: <20180113204609.GE32353@ziepe.ca>
References: <20180112055842.23125-1-leon@kernel.org>
 <20180112170228.GD15974@ziepe.ca>
 <20180112183958.GP15760@mtr-leonro.local>
 <20180113191806.GD32353@ziepe.ca>
 <20180113201118.GQ15760@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180113201118.GQ15760-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 13, 2018 at 10:11:18PM +0200, Leon Romanovsky wrote:

> > > The rationale behind it that it so basic change so it worth to have in
> > > stable. Also, it goes as all our countless fixes to those two series:
> > > Fixes: 44c58487d51a ("IB/core: Define 'ib' and 'roce' rdma_ah_attr types")
> > > Fixes: 7db20ecd1d97 ("IB/core: Change wc.slid from 16 to 32 bits")
> >
> > Nevertheless, the commit message does not explain to me or Linus why
> > this is *important* - it does not talk about what user visible
> > consequnce there is to this bug.
> 
> I'm a little bit confused here, when I submitted Fixes to -next, you
> asked from em to send such patches to -rc and now you are asking to send
> Fixes to -next.

I never ment that every patch with a Fixes: should go to -rc, I mean
that 'fixes' (lower case) suitable for -rc should go to -rc and not
-next.

And I've always ment that patches going to -rc need to have clear
commit messages that explain to Linus why they are worthy of -rc.

This is to help the overall broader community to ensure that patches
we deem important are made more visible and not just dumped into
for-next.

It is not just Linus asking for this. The distros *need* quality
commit messages to manage their own backporting activities.

> It will be better if you and Doug have more clear definition for -rc
> than LOC count and gut feelings.

Well, show me a guideline from Linus and we can follow it..  Linus has
some standard that is sort of deliberaly nebulous and we have to try
to follow it. I've already outlined my detailed thinking in a recent
email.

Linus is clearly concerned about the risk of introducing regressions
as the rc cycle moves along, so the commit message needs to explain
the benifit of the fix as worth taking a regression risk.

So again, back to 'RDMA/core: Fix avoid decoding iWarp port as
RoCE'. Looking at the actual patch now.. To a casual reader
it changes iwarp's RDMA_AH_ATTR_TYPE_ROCE to RDMA_AH_ATTR_TYPE_IB.

Why don't we have a RDMA_AH_ATTR_TYPE_IWARP? Apparently because iWarp
doesn't use struct rdma_ah_attr at all!

So the proposed patch apparently *does nothing* - that is clearly not
acceptable to for-rc at any point, and it certainly isn't worthy of
-stable. (so unless I hear a better explanation the -stable tag will
be dropped too)

Maybe I'm wrong, but the commit message *DOES NOT EXPLAIN*.

> For example, Dave took this series for -rc7/8, because it fixes the code
> and don't add new features.
> https://www.spinics.net/lists/netdev/msg477875.html

And Linus gives netdev more latitude than he gives rdma, so you cannot
use what DaveM accepts as a guideline for what we should accept. In
practice that means rdma gets more selective as the rc cycle moves on
and maybe netdev doesn't.

For instance, I think Linus would be angry with RDMA if we sent
something like 'net/mlx5e: Add error print in ETS init' to -rc8.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
