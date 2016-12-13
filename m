From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: SR-IOV with mlx4 on ConnectX-2 fails with DMAR errors
Date: Tue, 13 Dec 2016 09:54:41 -0700
Message-ID: <20161213165441.GB11099@obsidianresearch.com>
References: <CAN27Ff4RYh3y_45PUxxXhGuDvrrrjm8qe38fj5JPq7oV2QmdYA@mail.gmail.com>
 <CAN27Ff74Ov8bgsZP1QJJOwvWc5_KOW_U=PsP+=Z87AJz+VSAOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAN27Ff74Ov8bgsZP1QJJOwvWc5_KOW_U=PsP+=Z87AJz+VSAOw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joshua McBeth <joshua.mcbeth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 12, 2016 at 10:57:58PM -0500, Joshua McBeth wrote:
> Regarding this issue, I discovered earlier kernels were working with
> SR-IOV enabled and bisected to the commit
> 4be90bc60df47f6268b594c4fb6c90f0ff2f519f ("IB/mad: Remove
> ib_get_dma_mr calls").
> 
> However, this commit seems to be part of a larger refactoring patch
> set and reverting just this commit does not resolve the DMAR errors
> nor enable the 'ib0' interface to function.

?? if you bisected correctly then reverting the ID'd patch should
solve the problem.

Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
