From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH libibverbs 2/3] libibverbs: Add cross-channel QP
 initialization flags
Date: Sun, 20 Dec 2015 18:56:55 +0200
Message-ID: <5676DDD7.8020202@mellanox.com>
References: <1450610564-17279-1-git-send-email-leon@leon.nu>
 <1450610564-17279-3-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450610564-17279-3-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/20/2015 1:22 PM, Leon Romanovsky wrote:
> ---
>   include/infiniband/verbs.h | 3 +++
>   src/cmd.c                  | 5 ++++-
>   2 files changed, 7 insertions(+), 1 deletion(-)

You need to document the new creation flags in a man page. If this 
doesn't exist, this should be added to Eran's submission and you will 
enhance that.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
