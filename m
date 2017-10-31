From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/2] Report software parsing capabilities
 through mlx5 DV
Date: Tue, 31 Oct 2017 10:18:08 +0200
Message-ID: <6b811248-0568-154e-cbf2-557dacb029f2@dev.mellanox.co.il>
References: <1509275258-9808-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509275258-9808-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/29/2017 1:07 PM, Yishai Hadas wrote:
> This patch set from Noa is the supplementary part of the kernel series that was
> accepted upstream into 4.14, it reports software parsing capabilities through
> the mlx5 DV API.
> 
> Software parsing (SWP) is a feature that can be used to instruct the device to
> stop using its internal parser and to parse packets on the transmit path
> according to offsets set for each packet. Through this feature, the device
> allows the handling of checksum and LSO by the hardware according to the
> location of IP and TCP/UDP headers.
> 
> Patches:
> #1: Report various SW parsing capabilities through mlx5 direct verbs interface.
> #2: Update mlx5dv_query_device man page to include SWP information.
> 
> PR was sent:
> https://github.com/linux-rdma/rdma-core/pull/234
> 
> Noa Osherovich (2):
>    mlx5: Report SW parsing capabilities through mlx5 direct verbs
>    mlx5: Update mlx5dv_query_device man page
> 
>   providers/mlx5/man/mlx5dv_query_device.3 | 32 +++++++++++++++++++++++++++++++-
>   providers/mlx5/mlx5-abi.h                |  1 +
>   providers/mlx5/mlx5.c                    |  5 +++++
>   providers/mlx5/mlx5.h                    |  1 +
>   providers/mlx5/mlx5dv.h                  | 15 ++++++++++++++-
>   providers/mlx5/verbs.c                   |  1 +
>   6 files changed, 53 insertions(+), 2 deletions(-)
> 

Series was merged, thanks.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
