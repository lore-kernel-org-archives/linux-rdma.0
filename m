From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v2 3/4] nvme: enable SG gaps support
Date: Fri, 21 Apr 2017 08:44:27 +0200
Message-ID: <20170421064427.GB6095@lst.de>
References: <1492098977-5231-1-git-send-email-maxg@mellanox.com> <1492098977-5231-4-git-send-email-maxg@mellanox.com> <2bd673ee-8455-32b7-1bad-34fa9eebb076@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2bd673ee-8455-32b7-1bad-34fa9eebb076-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 20, 2017 at 02:27:59PM +0300, Sagi Grimberg wrote:
> I think it would be better if the ctrl will hold a virt_boundary
> provided by the fabric driver? Then we would always
> blk_queue_virt_boundary but with capable devices the fabric driver
> can set it to 0. This will also allow for dword aligned sgls to
> fit in pretty easily.

All our block I/O must be cache line aligned, so dword aligned SGLs
should not be an issue.  And for PRPs or MRs we'll always use the
host page size.

But I don't think I really care in the end..
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
