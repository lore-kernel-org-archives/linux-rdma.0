From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core build environment enabling out-of-core providers
Date: Thu, 3 Aug 2017 11:07:13 -0600
Message-ID: <20170803170713.GD13127@obsidianresearch.com>
References: <007601d30b96$f2408170$d6c18450$@opengridcomputing.com>
 <20170802160900.GB21208@obsidianresearch.com>
 <019001d30bc3$cc6648e0$6532daa0$@opengridcomputing.com>
 <44b511c6-45fa-d5aa-4d4c-e47d2edcf604@suse.de>
 <008401d30c5f$3c9e2560$b5da7020$@opengridcomputing.com>
 <20170803144733.GA13127@obsidianresearch.com>
 <890f961c-7aa8-1a73-e98d-f7ce9da333d7@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <890f961c-7aa8-1a73-e98d-f7ce9da333d7-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 03, 2017 at 05:01:16PM +0200, Nicolas Morey-Chaisemartin wrote:

> I haven't looked into the build system but isn't this something the
> devel rpm could provide ?

Conceptually, perhaps, but someone has to figure out how to split out
the necessary cmake bits into something reusable, it is no longer
entirely trivial :)

Also don't forget that the internal API inside the header files
changes, a provider that has been modified for rdma core 15 will not
compile on rdma core 13, just like the kernel..

I just wonder if it is worth the all the proposed work, I expect out
of tree providers to be very rare and temporary things.

> If this is done upstream once and for all, and not by every
> out-of-tree provider, it is not fragile anymore.

Someone would also have to contribute some kind of test infrastructure
to keep it working for upstream.. If it doesn't run in cbuild I don't
test it :P

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
