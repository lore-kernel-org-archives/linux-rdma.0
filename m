From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Upcoming libibverbs release
Date: Tue, 28 Jun 2016 17:52:13 +0200
Message-ID: <1467129133.8638.75.camel@oracle.com>
References: <3b89c411-72be-ddc5-5ebf-009eeee29692@redhat.com>
	 <4ec1d8e6-a908-bb49-a137-415856ec6faa@dev.mellanox.co.il>
	 <20160627181758.GD23540@obsidianresearch.com>
	 <20160628050246.GB3584@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160628050246.GB3584-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2016-06-28 at 08:02 +0300, Leon Romanovsky wrote:
> On Mon, Jun 27, 2016 at 12:17:58PM -0600, Jason Gunthorpe wrote:
> > Doug and I have both stated we don't want to see so many
> > single-provider APIs and churn in libibverbs. This was designed to
> > be
> > a generic API that all providers can implement.
> > 
> > The responsibility falls on you to make sure that it works
> > universally. Compat is one option.
> > 
> > This is also why it is necessary to get the other provider authors
> > to
> > say this works on their hardware, because they *all* ultimately
> > have
> > to implement it.
> > 
> > I don't think many people realize this yet.
> > 
> 
> Jason,
> You are over-estimating the number of other providers who are
> interesting in libibverbs in 2014-2016.
> 
> According to git log [1] in these years, I see only one major
> contributor to this library.

I appreciate Jason's concern for other providers, I can assure we both
use libibverbs for the new Oracle HCAs and also have changes/fixes to
it. I want to get them out here, just a matter of getting enough time
set aside to catch up (with the recent churn on both sides of the
kernel/user boundary)

> [1] https://git.kernel.org/cgit/libs/infiniband/libibverbs.git/log/

Thanks,

Knut

-- 
Knut Omang, Ph.D
Principal Software Engineer
Oracle NSN Europe Design Center



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
