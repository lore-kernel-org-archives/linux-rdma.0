From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 0/2] Performance Improvents for Secured Mode NVMe over
 Fabrics and other RDMA ULPs
Date: Sun, 29 Oct 2017 18:59:17 +0200
Message-ID: <e1ba4993-5c77-4754-967c-4da8ec34bf77@grimberg.me>
References: <1509295101-14081-1-git-send-email-idanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509295101-14081-1-git-send-email-idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Idan,

One minor nit, there is no "secured mode", its the normal sane
mode. The other mode compromises insecurity for performance.

> The following two patches are including performance
> optimizations for RDMA kernel ULPs that register/invalidate
> per IO (e.g. NVMe over Fabrics, iSER, NFS RDMA). The patches
> improve the IOPs could be achieved by a single network
> adapter with the above ULPs, specifically for NVMe over
> Fabrics the IOPs have improved x5 for small IO reads could
> be achieved in Linux using a single network adapter.

That is very good! Thanks for doing this!
You should note that its mlx5 specific enhancement, which is
an important device, but its not a performance improvement for
RDMA ULPs as it is.

What about mlx4 btw?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
