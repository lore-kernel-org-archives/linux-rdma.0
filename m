From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RESEND] IB/device: Convert ib-comp-wq to be CPU-bound
Date: Fri, 24 Mar 2017 22:24:37 -0400
Message-ID: <1490408677.2404.40.camel@redhat.com>
References: <1489003397-2321-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489003397-2321-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-03-08 at 22:03 +0200, Sagi Grimberg wrote:
> This workqueue is used by our storage target mode ULPs
> via the new CQ API. Recent observations when working
> with very high-end flash storage devices reveal that
> UNBOUND workqueue threads can migrate between cpu cores
> and even numa nodes (although some numa locality is accounted
> for).
> 
> While this attribute can be useful in some workloads,
> it does not fit in very nicely with the normal
> run-to-completion model we usually use in our target-mode
> ULPs and the block-mq irq<->cpu affinity facilities.
> 
> The whole block-mq concept is that the completion will
> land on the same cpu where the submission was performed.
> The fact that our submitter thread is migrating cpus
> can break this locality.
> 
> We assume that as a target mode ULP, we will serve multiple
> initiators/clients and we can spread the load enough without
> having to use unbound kworkers.
> 
> Also, while we're at it, expose this workqueue via sysfs which
> is harmless and can be useful for debug.
> 
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
