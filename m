From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH rfc 2/3] RDMA/core: expose cpu affinity based
        completion vector lookup
Date: Thu, 13 Jul 2017 17:50:00 +0200
Message-ID: <20170713155000.GA2577@lst.de>
References: <1499007694-7231-1-git-send-email-sagi@grimberg.me> <1499007694-7231-3-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1499007694-7231-3-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 02, 2017 at 06:01:33PM +0300, Sagi Grimberg wrote:
> A ULP might want to lookup an optimal completion vector based on
> a given cpu core affinity. Expose a lookup routine for it iterating
> on the device completion vectors searching a vector with affinity
> matching the given cpu.

Shouldn't this return the mask of cpus with the matching affinity
instead of always the first one?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
