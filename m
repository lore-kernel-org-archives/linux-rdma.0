From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx5: Add support for efficient UAR allocation
Date: Wed, 1 Mar 2017 10:14:02 +0200
Message-ID: <c59eeb59-db71-bf2b-1973-7b76bb220209@dev.mellanox.co.il>
References: <1488278732-27829-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488278732-27829-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/28/2017 12:45 PM, Yishai Hadas wrote:
> From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> The hardware allows now to use UARs with a fixed size of 4KB. To enable
> this feature we need both firmware and driver to support this feature in
> order to make benefit of this. Benefit is obtained when the system page
> size is larger than 4KB, like power pc.
>
> In order to support compatbility between any version of
> library/driver/firmware we add a flags field to struct
> mlx5_alloc_ucontext to notify the kernel driver whether this is a new
> library that supports 4KB UARs. In response, the kernel driver will
> return log_uar_size and number of UARs in a page.
>
> We also make order in the terms used. So a "page" now refers to a system
> page, "uar" refers to the 4KB UAR area and "uuar" or micro uar refers to
> the section in the device registers that is used for posting doorbells.
>
> In case of larger page sizes, we will try to assign more lockless uuars
> and preserve the number of medium latency uuars.
>
> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>
> Pull request was sent:
> https://github.com/linux-rdma/rdma-core/pull/85
>
>  providers/mlx5/mlx5-abi.h |  17 +++++--
>  providers/mlx5/mlx5.c     | 127 ++++++++++++++++++++++++++++++++--------------
>  providers/mlx5/mlx5.h     |   8 ++-
>  3 files changed, 108 insertions(+), 44 deletions(-)
>
> diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
> index 272d14e..5d10486 100644
> --- a/providers/mlx5/mlx5-abi.h
> +++ b/providers/mlx5/mlx5-abi.h
> @@ -48,10 +48,16 @@ enum {
>  };

Merged.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
