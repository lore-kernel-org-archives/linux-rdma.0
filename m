From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 02/17] verbs: Include rdma/ib_user_verbs.h in
 kern-abi.h
Date: Fri, 12 Jan 2018 09:28:49 -0700
Message-ID: <20180112162849.GA15974@ziepe.ca>
References: <20180111221340.965-1-jgg@ziepe.ca>
 <20180111221340.965-3-jgg@ziepe.ca>
 <20180112063433.GH15760@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180112063433.GH15760-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 12, 2018 at 08:34:33AM +0200, Leon Romanovsky wrote:

> > -#define IB_USER_VERBS_CMD_FLAG_EXTENDED		0x80ul
> 
> This define was added to kernel api (rdma/ib_user_verbs.h) in commit
> f21519b23c1b ("IB/core: extended command: an improved infrastructure for uverbs commands")
> 
> It means that this proposed commit won't compile on the systems with
> kernel dated before 2013. I don't think that it is real issue, but worth
> to mention it in commit message/comment.

The very first patch in the series updates the internal copy of the
kernel header to 4.15-rc7 and ensures that systems with old distro
copies use the internal header instead.

Just as we have been doing for other kernel headers for a long time.

So it should build on everything. There are far newer needed symbols
than the one above as well..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
