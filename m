From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 14/14] RDMA/bnxt_re: Update the driver version
Date: Wed, 10 May 2017 11:06:31 -0400
Message-ID: <84d9a0ce-0e5c-fc50-237f-b7ad9d541324@intel.com>
References: <1494413139-11883-1-git-send-email-selvin.xavier@broadcom.com>
 <1494413139-11883-15-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494413139-11883-15-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/10/2017 6:45 AM, Selvin Xavier wrote:
> Update the driver version to the scheme used in the internal
> development branches.

See the feedback [1] we got from Greg KH on a similar patch.

[1] https://patchwork.kernel.org/patch/7490321/

> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/bnxt_re/bnxt_re.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
> index 30bff05..9041c23b 100644
> --- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
> +++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
> @@ -40,7 +40,7 @@
>  #ifndef __BNXT_RE_H__
>  #define __BNXT_RE_H__
>  #define ROCE_DRV_MODULE_NAME		"bnxt_re"
> -#define ROCE_DRV_MODULE_VERSION		"1.0.0"
> +#define ROCE_DRV_MODULE_VERSION		"20.6.1.0u"
>
>  #define BNXT_RE_DESC	"Broadcom NetXtreme-C/E RoCE Driver"
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
