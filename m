From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 9/9] IB/srpt: convert to the generic RDMA READ/WRITE
	API
Date: Wed, 9 Mar 2016 13:59:41 +0100
Message-ID: <20160309125941.GC31210@lst.de>
References: <1457461000-24088-1-git-send-email-hch@lst.de> <1457461000-24088-10-git-send-email-hch@lst.de> <20160308201342.GL13396@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160308201342.GL13396@leon.nu>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, dledford@redhat.com, bart.vanassche@sandisk.com, sagig@mellanox.com, swise@opengridcomputing.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> You can jump to unwind label from one place only. In that stage
> "ioctx->rw_ctxs != NULL" will always be true.

There's two places actually, but it can't be NULL for both, so I
will removed that condition.

I'll update the git tree with the current review feedback, but I'll
wait for you to finish the review before resending it.
