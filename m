From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: building rdma-core from travis
Date: Tue, 18 Oct 2016 16:31:23 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB096CC3@ORSMSX109.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB096A7B@ORSMSX109.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB096A91@ORSMSX109.amr.corp.intel.com>
 <20161018050834.GF25013@leon.nu>
 <20161018160716.GB24189@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161018160716.GB24189-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Right. rdma-core does not support precise, at all. Aside from cmake,
> the original source packages had some non-functional 'compat' for such
> an old glibc (from 2012!) that I stripped out as well.

To people who use vi to write C code with text-based email for their code review process, 2012 is spaceship futuristic.

> I can't recommend that anybody working on a c-language project should
> be using the precise images on travis for anything <shrug>

We use containers, which are supposed to be faster for processing.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
