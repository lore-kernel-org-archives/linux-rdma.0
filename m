From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/5] Dropples RQ
Date: Fri, 28 Jul 2017 14:18:51 -0400
Message-ID: <1501265931.2593.38.camel@redhat.com>
References: <20170530072914.9709-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530072914.9709-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-05-30 at 10:29 +0300, Leon Romanovsky wrote:
> Hi Doug,
> 
> From Maor:
> ---
> This series adding support to avoid RAW ethernet packet drops.
> 
> When packets received and there are no receive WQEs, then
> the packets are dropped. In certain scenarios it may be preferred
> to configure the device to avoid such packet drops, assuming
> the posting of WQEs will resume shortly.
> 
> Under such configuration, when a packet is received for a
> WQ with no receive WQEs, the packet processing is delayed
> until receive WQEs are posted.
> 
> If receive WQEs are still not posted after a device configured
> time, the packet is dropped.
> 
> To enable this delay drop feature on a WQ, the user should
> set the IB_WQ_FLAGS_DELAY_DROP flag on creation.

The series changes core code API, but only on the raw ethernet QP type,
which is essentially a Mellanox only thing, so I have no issues with
the API change as it is.  Series applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
