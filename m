From: Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hfi: Properly set permissions for user device files
Date: Thu, 17 Sep 2015 11:48:05 -0400
Message-ID: <55FAE0B5.50306@redhat.com>
References: <1442439695-14275-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442439695-14275-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, "Haralanov, Mitko" <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/16/2015 05:41 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Some of the device files are required to be user accessible for PSM while
> most should remain accessible only by root.
>
> Add a parameter to hfi1_cdev_init which controls if the user should have access
> to this device which places it in a different class with the appropriate
> devnode callback.
>
> In addition set the devnode call back for the existing class to be a bit more
> explicit for those permissions.
>
> Signed-off-by: Haralanov, Mitko <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>   drivers/staging/rdma/hfi1/device.c   | 48 ++++++++++++++++++++++++++++++++++--
>   drivers/staging/rdma/hfi1/device.h   |  3 ++-
>   drivers/staging/rdma/hfi1/diag.c     |  5 ++--
>   drivers/staging/rdma/hfi1/file_ops.c |  9 ++++---
>   4 files changed, 57 insertions(+), 8 deletions(-)
>
Can add my
Tested-by: Donald Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Verified that permissions were modified as expected, and now
work with OPA libs that failed due to previous permission settings.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
