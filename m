From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/4] debian/copyright: Add copyright information
Date: Mon, 2 Jan 2017 15:11:23 -0700
Message-ID: <20170102221123.GA10226@obsidianresearch.com>
References: <20161229134908.13185-1-leon@kernel.org>
 <20161229134908.13185-4-leon@kernel.org>
 <20161229152537.GB30742@obsidianresearch.com>
 <20170101075433.GR26885@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170101075433.GR26885-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 01, 2017 at 09:54:33AM +0200, Leon Romanovsky wrote:

> > > +License: GPL-2+ or BSD
> >
> > I think this should just be 'BSD', same with all the 'or' stanzas.
> 
> I'm not a lawyer and in the rdma-core.spec it is "or".

The or is fine in other places, but this exact place is before the
license text itself. The license text stanzas should not have 'or'

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
