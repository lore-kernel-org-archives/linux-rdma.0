From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC 2/5] verbs: Introduce tag matching SRQ
Date: Mon, 12 Jun 2017 10:38:56 -0600
Message-ID: <20170612163856.GA12282@obsidianresearch.com>
References: <1497249767-15353-1-git-send-email-artemyko@mellanox.com>
 <1497249767-15353-3-git-send-email-artemyko@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1497249767-15353-3-git-send-email-artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, anag-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 12, 2017 at 09:42:44AM +0300, Artemy Kovalyov wrote:
> Introducing tag matching SRQ (TM-SRQ), which retains basic semantic of
> regular SRQ, reports completions to own CQ, and has additional tag
> based message receiving mechanism.
> 
> Change-Id: Ic527680984f343608507ba2162147435be2f7aee

Drop change-id from all your patches

>  enum ibv_srq_type {
>  	IBV_SRQT_BASIC,
> -	IBV_SRQT_XRC
> +	IBV_SRQT_XRC,
> +	IBV_SRQT_TAG_MATCHING
>  };

Please put trailing commas on all these enum changes in all patches

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
