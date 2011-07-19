From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/7] libibverbs: Add link layer field port attribute
Date: Tue, 19 Jul 2011 23:22:51 +0300
Message-ID: <CAJZOPZ+2S=agGurUC6393e7mqQy4Ob1jaseeoWxeZe2Yu-kCLg@mail.gmail.com>
References: <alpine.LRH.2.00.1107191223460.5580@ogerlitz.voltaire.com>
	<alpine.LRH.2.00.1107191226210.5580@ogerlitz.voltaire.com>
	<20110719170454.GD18090@obsidianresearch.com>
	<CAJZOPZ+=3jr18x8Uxt73jAfT0bdPhntOez9dyZfmiHOF5REOSw@mail.gmail.com>
	<20110719195020.GE18090@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110719195020.GE18090-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> Or Gerlitz wrote:

>>> What zeros the field in the current library?

+       port_attr->link_layer = IBV_LINK_LAYER_UNSPECIFIED;
+       port_attr->pad = 0;

Or
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
