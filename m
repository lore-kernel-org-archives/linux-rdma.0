From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: OFED-4.8, rdma-core, and library paths
Date: Wed, 8 Feb 2017 13:56:22 -0700
Message-ID: <20170208205622.GA32427@obsidianresearch.com>
References: <20170207183538.GT6005@mtr-leonro.local>
 <20170207184206.GA14102@obsidianresearch.com>
 <20170207194759.GU6005@mtr-leonro.local>
 <20170207201428.GV6005@mtr-leonro.local>
 <20170207205930.GA28922@obsidianresearch.com>
 <20170208063758.GZ6005@mtr-leonro.local>
 <20170208173335.GB30720@obsidianresearch.com>
 <20170208180104.GG6005@mtr-leonro.local>
 <20170208181820.GA31664@obsidianresearch.com>
 <20170208185446.GH6005@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170208185446.GH6005-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, 'Vladimir Sokolovsky' <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 08, 2017 at 08:54:46PM +0200, Leon Romanovsky wrote:

> > Hmm. Can you update your github? I'll look for you.
> 
> I pushed latest code to m/dv-1 branch, it is not for inclusion yet.
> https://github.com/rleon/rdma-core/commits/m/dv-v1
> Updated cover letter with changelog:
> https://github.com/rleon/rdma-core/commit/a332669511d5bbbd3dcdd977fbf95aa7ee47a69e
> And all cmake/packages stuff in the patch:
> https://github.com/rleon/rdma-core/commit/fcc4996c7fa5169fe599c2d568476314c1f65ddc

This should take care of most things

https://github.com/jgunthorpe/rdma-plumbing/commit/490b7fb184c414ab16b7056f1effa9136e8afe46

The debian packaging still needs some adjusting.

I suspect it is against Debian policy to include libmlx.so in the
providers package, it probably needs to have its own package and its
own -dev package.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
