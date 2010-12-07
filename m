From: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: Re: static_rate broken in mlx4?
Date: Tue, 7 Dec 2010 18:04:24 +0200
Message-ID: <4CFE5B08.2070707@mellanox.co.il>
References: <20101206200050.GA16788@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101206200050.GA16788-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

  On 12/6/2010 10:00 PM, Jason Gunthorpe wrote:
> Does this work? Has anyone seen it work?
>
> I'm testing it on a pair of mlx4 MT25418 and I'm trying to get down to
> 2.5Gbps and I can't see any effect from twiddling the static_rate AH
> attribute for an RC QP. The value seems to be working, I put 30 in to
> a ibv_modify_qp with IBV_QP_AV and 2 comes back (the max, it looks
> like..)
>
>
Static rate is not implemented on ConnectX

Tziporet

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
