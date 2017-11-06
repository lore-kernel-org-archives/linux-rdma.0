From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/5] travis: Test Debian packaging under Artful
 container
Date: Sun, 5 Nov 2017 19:14:04 -0700
Message-ID: <20171106021404.GB26011@ziepe.ca>
References: <20171102165556.22105-1-leon@kernel.org>
 <20171102165556.22105-6-leon@kernel.org>
 <20171102170554.GO18874@ziepe.ca>
 <20171102173255.GC16127@mtr-leonro.local>
 <20171102175522.GR18874@ziepe.ca>
 <2e2d65c2-845e-13ad-1022-a859b2fef6a7@dev.mellanox.co.il>
 <f6a250cd-dd4f-5dbe-4b1d-53f2b1f87b32@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f6a250cd-dd4f-5dbe-4b1d-53f2b1f87b32-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alaa Hleihel <alaa-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 05, 2017 at 03:30:01PM +0200, Alaa Hleihel wrote:

> There are issues using the trusty 32 bit packages (I'm getting
> #error "SSE instruction set not enabled").  So, for now I will only
> cleanup the unnecessary deb helpers from travis.yml .

Huh, that is a build bug in rdma-core.

Looks like this stuff in mmio.c should be protected by a #ifdef
__SSE__

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
