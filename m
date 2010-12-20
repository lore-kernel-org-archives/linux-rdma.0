From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 0/6] IB Netlink Interface and RDMA CM exports
Date: Mon, 20 Dec 2010 14:55:35 -0700
Message-ID: <20101220215535.GC12090@obsidianresearch.com>
References: <1292257370-24391-1-git-send-email-nirm@voltaire.com>
 <20101214182746.GB2506@obsidianresearch.com>
 <1292769027.2369.2127.camel@nirm-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1292769027.2369.2127.camel@nirm-desktop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 19, 2010 at 04:30:27PM +0200, Nir Muchtar wrote:

> Don't believe all this IPv6 hype ;)
> seriously though, The demo application is solely meant as an
> illustration for the means of communications with the current design.
> It's going to be rewritten in the future.

Sure, but you need to test that IPv6 works properly to complete the
patches :)

Also, you'll note my version exposes the bug in formatting the netlink
messages with the wrong size of sockaddr.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
