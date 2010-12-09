From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 5/5] RDMA CM: Netlink Client
Date: Thu, 9 Dec 2010 10:26:12 -0700
Message-ID: <20101209172612.GA11353@obsidianresearch.com>
References: <20101130181944.GI16788@obsidianresearch.com> <1291219134.3155.471.camel@nirm-desktop> <20101201183538.GQ16788@obsidianresearch.com> <1291736427.32170.36.camel@nirm-desktop> <20101207185453.GD16788@obsidianresearch.com> <7E95F01E94AB484F83061FCFA35B39F8794E3B@exil.voltaire.com> <20101207212924.GG16788@obsidianresearch.com> <1291820122.4715.96.camel@nirm-desktop> <20101208182356.GK16788@obsidianresearch.com> <1291884438.4715.152.camel@nirm-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1291884438.4715.152.camel@nirm-desktop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 09, 2010 at 10:47:18AM +0200, Nir Muchtar wrote:

> But I'm using MSG_DONTWAIT when calling netlink_unicast, so attachskb
> shouldn't block. I also tested that.

But then you are guarenteed to have an incomplete dump once you have
enough entries!

The best trade off is what the other dump_start user's do, you might
have an inconsistent dump sometimes, but at least it is complete and
correct most of the time.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
