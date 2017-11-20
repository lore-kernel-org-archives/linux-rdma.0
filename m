From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v3 2/3] nvme-rdma: don't complete requests before a
        send work request has completed
Date: Mon, 20 Nov 2017 12:19:24 +0100
Message-ID: <20171120111924.GA32087@lst.de>
References: <20171120104156.31344-1-sagi@grimberg.me> <20171120104156.31344-3-sagi@grimberg.me> <20171120105324.GA31524@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171120105324.GA31524-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 20, 2017 at 11:53:24AM +0100, Christoph Hellwig wrote:
> > +	req->cqe.status = cqe->status;
> > +	req->cqe.result = cqe->result;
> 
> I think we'll need to do a memcpy of the whole CQE here.

Or we could just store the status and results fields in the
nvme_rdma_request.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
