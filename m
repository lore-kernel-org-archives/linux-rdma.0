From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Post userspace patches here, or pull requests to github?
Date: Sun, 30 Oct 2016 12:03:56 -0600
Message-ID: <20161030180356.GA25939@obsidianresearch.com>
References: <2DD5ED3D-7F86-4AAF-863B-F2ED30B9A798@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2DD5ED3D-7F86-4AAF-863B-F2ED30B9A798-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 30, 2016 at 12:57:37PM +0000, Jeff Squyres (jsquyres) wrote:
> I posted a bug fix pull request for libibverbs yesterday (fixing a userspace/kernel space buffer size mismatch):
> 
>    https://github.com/linux-rdma/rdma-core/pull/31
> 
> Is that sufficient, or does it also need to be posted here?

We have been asking for posting here as well..

Are you still using usnic with verbs? I thought you moved everything
to libfabric? Should the usnic verbs provider be added to rdma-core?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
