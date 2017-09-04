From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/5] Small fixes for verbs
Date: Mon, 4 Sep 2017 15:07:55 +0300
Message-ID: <6da6cbbb-7157-b817-dc91-5871a7c9feea@dev.mellanox.co.il>
References: <1504212659-9674-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504212659-9674-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/31/2017 11:50 PM, Jason Gunthorpe wrote:
> This is a precursor to a larger series reworking how the providers
> are loaded.
>
> The big item is switching verbs fully to use ccan lists and using the new
> ccan functions to rework how the sysfs list is merged into the device list.
>
> Jason Gunthorpe (5):
>   verbs: Remove diagnostic ignored "-Wmissing-prototypes"
>   util: Fix check_snprintf to use __rc__ for local
>   verbs: Use ccan list.h instead of open coding lists
>   verbs: Tidy up ibverbs_get_device_list
>   ocrdma: Remove ocrdma_dev_list
>
>  libibverbs/init.c              | 145 ++++++++++++++++++++---------------------
>  providers/ocrdma/ocrdma_main.c |   7 --
>  providers/ocrdma/ocrdma_main.h |   1 -
>  util/util.h                    |   4 +-
>  4 files changed, 73 insertions(+), 84 deletions(-)
>

The series in the ML is not up-to-date with the latest pull request from 
GITHUB, let's please have it in sync for next time.

Passed over the pull request, it looks fine to me.
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
