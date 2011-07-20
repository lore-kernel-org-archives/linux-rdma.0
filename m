From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/7] libibverbs: Add link layer field port attribute
Date: Wed, 20 Jul 2011 21:47:12 +0300
Message-ID: <CAJZOPZKCaAiBiqp_gNH7FGU8uVkLcDTjXufA=0DQemhCjFAmRA@mail.gmail.com>
References: <20110719170454.GD18090@obsidianresearch.com>
	<CAJZOPZ+=3jr18x8Uxt73jAfT0bdPhntOez9dyZfmiHOF5REOSw@mail.gmail.com>
	<20110719195020.GE18090@obsidianresearch.com>
	<CAJZOPZ+2S=agGurUC6393e7mqQy4Ob1jaseeoWxeZe2Yu-kCLg@mail.gmail.com>
	<20110719203140.GG18090@obsidianresearch.com>
	<1828884A29C6694DAF28B7E6B8A82373136EFE8F@ORSMSX102.amr.corp.intel.com>
	<20110719213902.GH18090@obsidianresearch.com>
	<CAJZOPZ+HjKiSr=Q6ti9zPfx0YnGXK796xK+Y8fDtLLuM3SnKbA@mail.gmail.com>
	<20110720181052.GI18090@obsidianresearch.com>
	<CAJZOPZL9T2XK25BxtOBJj4vW3uSZz4yDWR4wfBxvUaeOgrWU3A@mail.gmail.com>
	<20110720183327.GJ18090@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110720183327.GJ18090-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> Yes, that was the only important thing I saw.
> I assume Roland was happy with the #define trick for compatibility
> last time it came up?

yes, that's correct.

> Looking at the diff, maybe re-shuffle the order of the #define trick
> so it is easier to follow, and call ibv_query_port rather than short
> cut through the context for better future compatibility.

will do, thanks

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
