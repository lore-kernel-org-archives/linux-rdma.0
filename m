From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/5] Clock information
Date: Tue, 23 Jan 2018 16:22:17 +0200
Message-ID: <f1213c63-392d-e48b-53bf-0b31b415fa33@dev.mellanox.co.il>
References: <1516197093-20699-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516197093-20699-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 1/17/2018 3:51 PM, Yishai Hadas wrote:
> This series from Feras is the supplementary part of the kernel series that was
> sent upstream for 4.16.
> 
> The series enables user space applications to query the mlx5 core clock and use
> it to translate timestamps from HCA core clock units to nanoseconds.
> 
> PR was sent:
> https://github.com/linux-rdma/rdma-core/pull/284
> 
> Note:
> The Travis error in GITHUB is some checkpatch false alarm that relates
> to some macro usage.
> 
> Yishai
> 
> Feras Daoud (5):
>    mlx5: Support for user space clock info
>    mlx5: Add direct verbs support for query clock info
>    mlx5: Add direct verb to translate device timestamp to nanoseconds
>    verbs: Add support to read completion's timestamp in wall clock
>      nanoseconds
>    mlx5: Implement read_completion_wallclock_ns
> 
>   debian/ibverbs-providers.symbols           |   2 +
>   libibverbs/man/ibv_create_cq_ex.3          |   9 +-
>   libibverbs/verbs.h                         |  10 +-
>   providers/mlx5/CMakeLists.txt              |   2 +-
>   providers/mlx5/cq.c                        | 181 +++++++++++++++++++++++------
>   providers/mlx5/libmlx5.map                 |   5 +
>   providers/mlx5/man/CMakeLists.txt          |   2 +
>   providers/mlx5/man/mlx5dv_get_clock_info.3 |  37 ++++++
>   providers/mlx5/man/mlx5dv_query_device.3   |   2 +-
>   providers/mlx5/man/mlx5dv_ts_to_ns.3       |  35 ++++++
>   providers/mlx5/mlx5-abi.h                  |  24 +++-
>   providers/mlx5/mlx5.c                      |  71 +++++++++++
>   providers/mlx5/mlx5.h                      |   7 +-
>   providers/mlx5/mlx5dv.h                    |  65 ++++++++++-
>   providers/mlx5/verbs.c                     |  15 ++-
>   15 files changed, 421 insertions(+), 46 deletions(-)
>   create mode 100644 providers/mlx5/man/mlx5dv_get_clock_info.3
>   create mode 100644 providers/mlx5/man/mlx5dv_ts_to_ns.3
> 

The PR was re-based over the latest code, series was merged.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
