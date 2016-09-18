From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH libmlx5 0/5] RSS support
Date: Sun, 18 Sep 2016 14:19:56 +0300
Message-ID: <64f1ffc1-6fc8-5d5c-1c6f-e0d8132e71da@dev.mellanox.co.il>
References: <1472571523-12067-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472571523-12067-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 8/30/2016 6:38 PM, Yishai Hadas wrote:
> This patch set implements the RSS libibverbs series
> that was sent upstream.
>
> It can serve as some driver reference code to justify and demonstrate the usage
> of the new verbs and objects.
>
> Yishai
>
> Yishai Hadas (5):
>   Add support for RSS WQ verbs
>   Add support for Receive WQ indirection table verbs
>   Add RSS QP support
>   Expose RSS capabilities
>   Add RSS data path support
>
>  src/cq.c       |  55 +++++++---
>  src/mlx5-abi.h |  62 +++++++++++
>  src/mlx5.c     |   5 +
>  src/mlx5.h     |  35 ++++++
>  src/qp.c       |  96 +++++++++++++++++
>  src/verbs.c    | 333 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  6 files changed, 566 insertions(+), 20 deletions(-)
>

Series applied.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
