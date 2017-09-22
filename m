From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Suppress the retry related completion errors
Date: Fri, 22 Sep 2017 13:14:20 -0400
Message-ID: <1506100460.5172.5.camel@redhat.com>
References: <20170907103818.5303-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170907103818.5303-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-09-07 at 13:38 +0300, Yuval Shaia wrote:
> From: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> IPoIB doesn't support transport/rnr retry schemes as per
> RFC so those errors are expected. No need to flood the
> log files with them.
> 
> Tested-by: Michael Nowak <michael.nowak-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Tested-by: Rafael Alejandro Peralez <rafael.peralez-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Tested-by: Liwen Huang <liwen.huang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Tested-by: Hong Liu <hong.x.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reported-by: Rajiv Raja <rajiv.raja-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Even though this is a minor printk patch that could easily go to for-
next, because it brings us more into compliance with the RFC I went
ahead and processed it for rc.  Thanks.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
