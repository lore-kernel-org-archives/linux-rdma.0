From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/4] debian/copyright: Add copyright information
Date: Thu, 29 Dec 2016 08:25:37 -0700
Message-ID: <20161229152537.GB30742@obsidianresearch.com>
References: <20161229134908.13185-1-leon@kernel.org>
 <20161229134908.13185-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161229134908.13185-4-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 29, 2016 at 03:49:07PM +0200, Leon Romanovsky wrote:
> From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> This patch adds debian/copyright file and list all
> different licences and copyrights, according to
> debian policy.

> +Files: *
> +License: GPL-2+ or BSD

We don't have anything that includes the 'any later version' clause in
the copyright header required to be GPLv2+ - so everything should be simply
'GPL-2'

> +Files: debian/*
> +Copyright: 2016 Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> +License: GPL-2+

You can add me here too

> +Files: buildlib/cbuild
> +Copyright: 2015, 2016, Obsidian Research Corp. See COPYING.
> +License: GPL-2+ or BSD
> +
> +Files: buildlib/fixup-include/*
> +Copyright: 2016, Mellanox Technologies Ltd.
> +License: GPL-2+ or BSD

Many of these copyright attributions are a bit wonky :\ I personally
think this format of Debian's is too difficult.

> +Files: ccan/*
> +Copyright: unspecified
> +License: CC0 and BSD-MIT
> +
> +Files: ibacm/*
> +Copyright: 2013-2015, Mellanox Technologies LTD.
> +  2009-2014, Intel Corporation.
> +License:  GPL-2 or OpenIB.org BSD (FreeBSD variant)

There is no text stanza for 'OpenIB.org BSD'

> +Files: providers/ipathverbs/*
> +Copyright: 2006-2009, QLogic Corp.
> +  2005
> +License: GPL-2+ or BSD

ipath has a special license. Please review COPYING.md and make sure
all the special cases called out are covered properly.

> +License: GPL-2+ or BSD

I think this should just be 'BSD', same with all the 'or' stanzas.

I didn't see the intel bsd license in here (see
providers/hfi1verbs/hfiverbs.c, it is slightly different again)

It would be good to update COPYING.md to refer people to this new file
as it is better than the short summary.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
