From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs v2 1/3] Add new call ibv_cmd_create_ah_ex
 which supports extra parameters
Date: Mon, 19 Sep 2016 06:29:24 +0200
Message-ID: <1474259364.20134.114.camel@oracle.com>
References: <cover.0e6854f557aa8aa6ed7681cdf58397ef4f106505.1474063039.git-series.knut.omang@oracle.com>
         <5cc0157c0f05701d8cb1334e6ee11e1e7be6fa24.1474063039.git-series.knut.omang@oracle.com>
         <20160919030122.GA23152@obsidianresearch.com>
         <1474257063.20134.103.camel@oracle.com>
         <20160919040854.GA28241@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160919040854.GA28241-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2016-09-18 at 22:08 -0600, Jason Gunthorpe wrote:
> On Mon, Sep 19, 2016 at 05:51:03AM +0200, Knut Omang wrote:
> 
> > I was a bit concerned about the "structure", but ultimately decided to
> > follow the pattern since I could not find any documentation with this syntax
> > (which is probably because it is not supported?)
> 
> It is something carried over from Solaris, it is not implemented in
> linux today, but it is good practice to follow the solaris
> method. Drepper talks about it in his various documentations of symbol
> versioning.
> 
> Each stanza should refer to its predecessor.

Ok, I see...
That also means that this patch would have to be based on the IBVERBS_1.2 and IBVERBS_1.3 fixups
to avoid introducing conflicts.

Knut

> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
