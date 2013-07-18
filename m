From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V7 libibverbs 0/7] Add extension and XRC QP support
Date: Thu, 18 Jul 2013 23:06:20 +0300
Message-ID: <CAJZOPZ+Dre0atS6Oho_N-XPvXMi=SvbROhm73qWwh0i4mj-qwQ@mail.gmail.com>
References: <1373555063-31790-1-git-send-email-yishaih@mellanox.com>
	<20130711170710.GB27357@obsidianresearch.com>
	<51E3EDCF.2050007@dev.mellanox.co.il>
	<20130716001046.GA9237@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130716001046.GA9237-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Jul 15, 2013 at 03:40:47PM +0300, Yishai Hadas wrote:

>> Let me clarify the place holder reservation mentioned in the cover
>> letter.  The entries I was referring to are not proprietary vendor
>> verbs but rather user space verbs who are on their way to be
>> submitted upstream for inclusion in libibverbs/libmlx4.

> I get that.

> But it doesn't make one difference. Until they reach Roland's tree *nobody*
> gets to use indexes in the extension structure with the 'libibverbs.so.1' SONAME.

Hi Jason, after a thorough internal discussion we concluded that your
point is indeed valid one. So in that respect, will resubmit the
patches and do the index allocation the way it was intended. This will
cost us with some field/upgrade issues but we agree that this is for
the greater && good.

[...]

> Frankly, this nonsense makes me question if the extension mechanism is
> even a sane idea if this is the sort of abuse it is going to be subject too.

So if not abusing... can you now review && acknowledge this series
which is a respin + fixes in the series Sean posted earlier this year,
Sean ditto for you, any feedback or ack on the series sans the pointer
reservation which we will remove.

As Yishai wrote, he's OOO for a week so work might be resumed only
when he's back, and once this is done will re-submit ASAP

Or
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
