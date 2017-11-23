From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 0/3] mlx5: Add striding RQ support via the DV
 API
Date: Thu, 23 Nov 2017 09:46:18 +0200
Message-ID: <eb678443-e133-ca38-747e-710565ef788b@dev.mellanox.co.il>
References: <1511352668-1441-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1511352668-1441-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/22/2017 2:11 PM, Yishai Hadas wrote:
> This series from Noa is the supplementary part of the kernel series that was
> merged into 4.15.
> 
> This series exposes to mlx5 DV users the ability to create an RQ with the
> striding functionality.
> 
> PR was sent:
> https://github.com/linux-rdma/rdma-core/pull/257
> 
> Changes from V0:
> - Add an extra patch with a helper function to verify 64 bit comp mask and use
>    it when applicable.
> 
> Yishai
> 
> Noa Osherovich (3):
>    Add a helper function to verify 64 bit comp mask
>    mlx5: Report Multi-Packet RQ capabilities through mlx5 direct verbs
>    mlx5: Allow creation of a Multi-Packet RQ using direct verbs
> 
>   debian/ibverbs-providers.symbols         |  2 +
>   libibverbs/driver.h                      |  5 +++
>   providers/mlx4/verbs.c                   |  4 +-
>   providers/mlx5/CMakeLists.txt            |  2 +-
>   providers/mlx5/libmlx5.map               |  5 +++
>   providers/mlx5/man/mlx5dv_query_device.3 | 14 +++++-
>   providers/mlx5/mlx5-abi.h                | 14 +++++-
>   providers/mlx5/mlx5.c                    |  5 +++
>   providers/mlx5/mlx5.h                    |  1 +
>   providers/mlx5/mlx5dv.h                  | 58 +++++++++++++++++++++++-
>   providers/mlx5/verbs.c                   | 75 +++++++++++++++++++++++++++++---
>   11 files changed, 171 insertions(+), 14 deletions(-)
> 

Thanks, series was merged.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
