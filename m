From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH libibverbs 0/7] RSS support
Date: Wed, 31 Aug 2016 10:01:30 +0300
Message-ID: <6794de45-534b-be0c-2076-d8a048ce721a@grimberg.me>
References: <1472569796-26162-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472569796-26162-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 30/08/16 18:09, Yishai Hadas wrote:
> Hi Doug,
>
> This patch-set exposes to user space the required objects and verbs in order to
> allow verbs based solution to utilize the RSS offload capability.
>
> The kernel part for the 5 first patches was already accepted into 4.8, the
> capabilities patch (#6) was sent few days ago into 4.9, reviewed by Sagi
> Grimberg and waits to your acceptance. The last patch adds and updates relevant
> man pages
>
> The series was tested successfully with mlx5 driver (lib, kernel) and can be
> accessed also from my openfabrics GIT at:
> git://openfabrics.org/~yishaih/libibverbs.git branch: rss_v0
>
> Will send shortly the libmlx5 candidate patches as some driver code that
> implements and use the new verbs.
>
> Yishai

Thanks Yishai,

Verbs RSS is very useful for me. The series looks good,
I'll take it (with the libmlx5 series) for testing.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
