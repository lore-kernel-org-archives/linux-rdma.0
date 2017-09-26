From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 03/10] verbs: Split init_device into a match and
 alloc/bind step
Date: Tue, 26 Sep 2017 19:00:16 +0300
Message-ID: <5a30e4a3-e22c-5d1a-435d-d3c5d94333fd@dev.mellanox.co.il>
References: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1505855931-4956-4-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505855931-4956-4-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/20/2017 12:18 AM, Jason Gunthorpe wrote:
> The match step determines if the provider should bind to the sysfs device,
> and the allocation step creates the verbs_device and cleanly matches the
> uninit_device step which frees it.
> 
> This split makes it simpler to factor out all the duplicated code in the
> match step.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>   libibverbs/driver.h | 21 ++++++++++++++-
>   libibverbs/init.c   | 74 ++++++++++++++++++++++++++++++++++-------------------
>   2 files changed, 68 insertions(+), 27 deletions(-)
> 
> diff --git a/libibverbs/driver.h b/libibverbs/driver.h
> index f9f5cfa2308c2f..397441f49a0e5a 100644
> --- a/libibverbs/driver.h
> +++ b/libibverbs/driver.h
> @@ -40,6 +40,7 @@
>   #include <infiniband/kern-abi.h>
>   #include <ccan/list.h>
>   #include <config.h>
> +#include <stdbool.h>
>   
>   #ifdef __cplusplus
>   #  define BEGIN_C_DECLS extern "C" {
> @@ -95,10 +96,27 @@ struct verbs_qp {
>   	struct verbs_xrcd       *xrcd;
>   };
>   
> +/* A rdma device detected in sysfs */
> +struct verbs_sysfs_dev {
> +	struct list_node entry;
> +	void *provider_data;

It looks as this field isn't used in the series, correct ? if this is 
the case better add when it'll become applicable.

> +	char sysfs_name[IBV_SYSFS_NAME_MAX];
> +	char ibdev_name[IBV_SYSFS_NAME_MAX];
> +	char sysfs_path[IBV_SYSFS_PATH_MAX];
> +	char ibdev_path[IBV_SYSFS_PATH_MAX];
> +	int abi_ver;
> +	struct timespec time_created;
> +};
> +
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
