From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 17/50] IB/hfi1: add PSM driver control/data path
Date: Thu, 30 Jul 2015 13:40:41 -0600
Message-ID: <20150730194041.GA28754@obsidianresearch.com>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
 <20150730191859.25256.28987.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150730191859.25256.28987.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 30, 2015 at 03:18:59PM -0400, Mike Marciniszyn wrote:
> +static ssize_t hfi1_write_iter(struct kiocb *kiocb, struct iov_iter *from)
> +{
> +	struct hfi1_user_sdma_pkt_q *pq;
> +	struct hfi1_user_sdma_comp_q *cq;
> +	int ret = 0, done = 0, reqs = 0;
> +	unsigned long dim = from->nr_segs;

I thought you were getting rid of this?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
