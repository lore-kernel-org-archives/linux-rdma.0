From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v5 for-4.13 2/7] mlx5e: don't assume anything on the
        irq affinity mappings of the device
Date: Fri, 16 Jun 2017 11:45:47 +0200
Message-ID: <20170616094547.GA12547@lst.de>
References: <1497533594-11579-1-git-send-email-sagi@grimberg.me> <1497533594-11579-3-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1497533594-11579-3-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 15, 2017 at 04:33:09PM +0300, Sagi Grimberg wrote:
> mlx5e currently assumes that irq affinity is really spread first
> irq vectors across device home node cpus, with the new generic affinity
> mappings this is no longer the case, hence mlxe should not rely on
> this anymore.

Looks fine, but the explanation sounds a bit short - only spreading
the vectors of the single node sounds rather odd, so there needs to
be an explanation of why this was done before and isn't valid anymore.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
