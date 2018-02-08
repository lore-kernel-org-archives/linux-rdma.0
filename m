From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/2] net/mlx5: increase async EQ to avoid EQ overrun
Date: Thu, 8 Feb 2018 09:26:05 -0700
Message-ID: <20180208162605.GK9051@mellanox.com>
References: <1517840992-29813-1-git-send-email-maxg@mellanox.com>
 <20180205180904.GB11446@mellanox.com>
 <d572b570-0844-e441-19a0-e6804557fb58@mellanox.com>
 <20180205231617.GQ11446@mellanox.com>
 <CALzJLG9QQ_B4xj-E+HtpxUWZhFU9eWeqSNHSaQjf5HH=9TPXTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALzJLG9QQ_B4xj-E+HtpxUWZhFU9eWeqSNHSaQjf5HH=9TPXTg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 07, 2018 at 09:45:52PM -0800, Saeed Mahameed wrote:

> I see, that this patch is already on its way to linus, with no proper
> mlx5 maintainer sign-off, nice.

Doug and I can be more careful to not accept patches without
maintainer ack's - but this means I will want to see Acks from you no
matter who sends the patch (including patches sent by Leon).

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
