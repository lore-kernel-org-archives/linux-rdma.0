From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 1/4] libibmad: Distinguish timed out from other errors
Date: Mon, 11 Apr 2011 09:43:07 -0700
Message-ID: <20110411094307.9c478f38.weiny2@llnl.gov>
References: <4DA07983.8060308@dev.mellanox.co.il>
	<20110409171239.GA4372@obsidianresearch.com>
	<4DA1875F.2050601@dev.mellanox.co.il>
	<20110410140956.GB4372@obsidianresearch.com>
	<4DA1D405.4040305@dev.mellanox.co.il>
	<20110410164459.GC4372@obsidianresearch.com>
	<4DA2E511.2030204@dev.mellanox.co.il>
	<20110411155853.GA30452@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110411155853.GA30452-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Kladnitsky <orenk-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 11 Apr 2011 08:58:53 -0700
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Mon, Apr 11, 2011 at 07:25:05AM -0400, Hal Rosenstock wrote:
> 
> > I'll add this to an updated/reworked patch but I hope we'll avoid an
> > extra last minute/release version bump.

In the end when an official version comes out it is on me to make sure we don't
rev twice.

> 
> IMHO you only bump it once during devel, even if two ABI bumping
> changes are done. The point is to not mix it up with the already
> installed library.

This makes sense to me, and is how I have done things in the past.  Bump the
version and run with that until the official branch/tag.

Ira

> 
> Jason


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
