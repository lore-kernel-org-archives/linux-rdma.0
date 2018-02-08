From: Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/2] net/mlx5: increase async EQ to avoid EQ overrun
Date: Thu, 8 Feb 2018 10:58:14 -0800
Message-ID: <CALzJLG87QNzP=tSGg7zTGVtOX5TPAHCHZ66bTWS9ZQDABQKV2w@mail.gmail.com>
References: <1517840992-29813-1-git-send-email-maxg@mellanox.com>
 <20180205180904.GB11446@mellanox.com> <d572b570-0844-e441-19a0-e6804557fb58@mellanox.com>
 <20180205231617.GQ11446@mellanox.com> <CALzJLG9QQ_B4xj-E+HtpxUWZhFU9eWeqSNHSaQjf5HH=9TPXTg@mail.gmail.com>
 <20180208162605.GK9051@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180208162605.GK9051-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 8, 2018 at 8:26 AM, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Wed, Feb 07, 2018 at 09:45:52PM -0800, Saeed Mahameed wrote:
>
>> I see, that this patch is already on its way to linus, with no proper
>> mlx5 maintainer sign-off, nice.
>
> Doug and I can be more careful to not accept patches without
> maintainer ack's - but this means I will want to see Acks from you no
> matter who sends the patch (including patches sent by Leon).
>

Thanks for understanding, Leon and I almost always in sync,
we don't submit patches to each other tree (especially pure patches)
without notifying the other first.

> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
