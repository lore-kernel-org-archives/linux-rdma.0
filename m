From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] Make the provider facing libibverbs interface
 private
Date: Mon, 30 Jan 2017 13:53:06 -0700
Message-ID: <20170130205306.GA27111@obsidianresearch.com>
References: <20170126230813.GA7149@obsidianresearch.com>
 <20170130135959.GL6005@mtr-leonro.local>
 <20170130170341.GB29502@obsidianresearch.com>
 <20170130203011.GN6005@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170130203011.GN6005-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 30, 2017 at 10:30:11PM +0200, Leon Romanovsky wrote:

> > The map file will have two sections now, one for public symbols that
> > will continue to use the 1.3/1.4/etc system
> 
> But you removed IBVERBS_1.4. Do we introduce IBVERBS_1.4 again?

I also removed 1.3. I suggest new public verbs start at 1.4 - only
because we never made a release with the 1.4 symver. 1.5 would also be
OK, I'm indifferent. I updated the patch with a note on this.

> > The file name will continue to be 1.3.${PACKAGE_VERSION} but it is
> > largely irrelevant..
> 
> It is better to keep in sync these numbers in CmakeLists and map file.

Yes, this PR does that:

https://github.com/linux-rdma/rdma-core/pull/70

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
