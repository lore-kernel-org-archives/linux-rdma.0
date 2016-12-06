From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 01/10] IB/core: Add raw packet protocol
Date: Tue, 6 Dec 2016 23:26:51 +0200
Message-ID: <CAJ3xEMhYs0jtXYDqAXEw17Fk4padG903J3enL+uNPg_fNk-9Uw@mail.gmail.com>
References: <HE1PR0501MB28124286F8D902C49596EF85B18C0@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <20161130163949.GC24639@obsidianresearch.com> <HE1PR0501MB28128CDB112558C5980CB638B18C0@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <20161130170830.GA17512@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373AB0BA190@ORSMSX109.amr.corp.intel.com>
 <01e501d24b2e$ff2a3260$fd7e9720$@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A82373AB0BA1B7@ORSMSX109.amr.corp.intel.com>
 <d4bab4a9-aa32-282f-b501-ecfc00b0be0f@talpey.com> <1828884A29C6694DAF28B7E6B8A82373AB0BA68E@ORSMSX109.amr.corp.intel.com>
 <HE1PR0501MB2812393A0A690DEC1E03DE3FB1800@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <20161205171013.GA27784@obsidianresearch.com> <HE1PR0501MB2812A66403A8C19AF83742EDB1830@HE1PR0501MB2812.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR0501MB2812A66403A8C19AF83742EDB1830-692Kmc8YnlIVrnpjwTCbp8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 5, 2016 at 10:14 PM, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]

>>> Anyway, returning to the initial matter at hand: I would like to start
>>> with each port reporting a bit mask of the supported protocols on that
>>> link (RoCE v1/v2, Raw Ethernet, iWARP, etc.)  It will be used for
>>> reporting device capabilities in general for tools, as well as by
>>> applications that don't use rdmacm.

>> Why don't we start by defining how it is supposed to even work and how to fix
>> the RDMA CM before adding even more random capability bits?

> Extensions to RDMA CM is an important topic, which we can continue to discuss as devices that require it are introduced.

> Protocol capabilities are needed for information purposes as well as for applications that do not use RDMA CM.
> They are not "random", but depict what a device can do.

Doug,

Can we get a maintainer say here? I didn't see complaints on the mlx5
IB driver patch that opens IB device also in the lack of RoCE support.
We have a valid real life use-case which needs this driver patch.

Per your request, I made also some core patch to expose QPTs to
user-space and we went into this long discussion.

Do you want the change along what was proposed by Liran (allow
user-space to query the supported protocols per port) or you are okay
with  taking only the mlx5 patches for now and discuss the rest later
or something else?

Please let us know

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
