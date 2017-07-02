From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx4: Cleanup resources upon device fatal
Date: Sun, 2 Jul 2017 13:55:10 +0300
Message-ID: <3340ce2d-5baf-ae9e-e1e3-62608242860c@dev.mellanox.co.il>
References: <1498747317-2170-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498747317-2170-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/29/2017 5:41 PM, Yishai Hadas wrote:
> Cleanup driver resources upon device fatal on closing commands. (e.g.
> destroy qp/srq/cq etc.)
>
> Currently when a device fatal error occurred the uverbs layer returns
> from kernel EIO to indicate that the kernel driver low level
> resources were already cleaned up.
>
> However, closing commands as of destroy_qp/cq/srq might leak the user
> space driver memory that had to be freed upon success.
>
> The verbs layer (cmd.c) can't generally return a success in that case as
> it had to deal with an application flow that still handles the reported
> events in some other thread but the 'events_reported' data doesn't
> exist as part of the command response.
>
> In case the application takes control over the events before cleaning
> its resources (e.g. by using one thread, ack events before destroying its resources)
> the driver memory can be safely cleaned up.
>
> Let applications that use mlx4 to set some environment variable to
> indicate that so that won't be a memory leak upon driver device fatal.
>
> Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>
> Pull request was sent:
> https://github.com/linux-rdma/rdma-core/pull/158
>
>  providers/mlx4/mlx4.c  | 12 ++++++++++++
>  providers/mlx4/mlx4.h  |  6 ++++++
>  providers/mlx4/srq.c   |  2 +-
>  providers/mlx4/verbs.c | 19 ++++++++++---------
>  4 files changed, 29 insertions(+), 10 deletions(-)
>

Merged.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
