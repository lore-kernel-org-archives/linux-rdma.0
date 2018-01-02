From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core] Remove the obsolete libibcm library
Date: Tue, 2 Jan 2018 08:04:05 -0700
Message-ID: <20180102150405.GD29208@ziepe.ca>
References: <20171225123132.6063-1-leon@kernel.org>
 <20171227201945.GG25436@ziepe.ca>
 <20171228053029.GO3494@mtr-leonro.local>
 <ea55cca5-1bf9-dd54-9be1-6450ca9002ef@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ea55cca5-1bf9-dd54-9be1-6450ca9002ef-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 02, 2018 at 09:18:59AM -0500, Hal Rosenstock wrote:

> > The disabled build doesn't give much benefit at all. It will be dead code exactly
> > as now, but without any alert that it is broken. Most possible, it will be broken
> > till some distro will notice it.
> 
> Since when has it been brken and how is it broken ? Last I knew it
> worked but was not used by anything in tree.

Last time I used it I remember thinking it had an unfixable race of
some sort.. Long time ago

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
