From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/4] libibmad: Distinguish timed out from other errors
Date: Sun, 10 Apr 2011 10:44:59 -0600
Message-ID: <20110410164459.GC4372@obsidianresearch.com>
References: <4DA07983.8060308@dev.mellanox.co.il>
 <20110409171239.GA4372@obsidianresearch.com>
 <4DA1875F.2050601@dev.mellanox.co.il>
 <20110410140956.GB4372@obsidianresearch.com>
 <4DA1D405.4040305@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4DA1D405.4040305-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Apr 10, 2011 at 12:00:05PM -0400, Hal Rosenstock wrote:
> > If you are going to change the ABI like this then you have to bump the
> > SONAME.
> 
> Typically it's been the libibmad maintainer who's bumped the versions
> when appropriate as a release is readied.

The version should be bumped in the same commit that makes the
incompatible change so that people testing the library don't get
messed up by it.
 
> > Setting a flag would work.
> 
> Not sure what you're referring to. Setting a flag where ?

Your idea to place a `new ABI` flag in mgmClass.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
