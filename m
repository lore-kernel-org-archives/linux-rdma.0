From: santosh shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] rds-tools user space part of change for rds-stress -D
 option failure
Date: Tue, 1 Mar 2016 11:03:00 -0800
Message-ID: <56D5E764.3050006@oracle.com>
References: <1456796846-8596-1-git-send-email-zdai@linux.vnet.ibm.com>
 <1456796846-8596-2-git-send-email-zdai@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456796846-8596-2-git-send-email-zdai-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dai <zdai-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/29/2016 5:47 PM, David Dai wrote:
> ---
>   rds-stress.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/rds-stress.c b/rds-stress.c
> index 9f0623c..6632d58 100755
> --- a/rds-stress.c
> +++ b/rds-stress.c
> @@ -1400,7 +1400,7 @@ static int recv_message(int fd,
>   		return ret;
>   	if (ret && ret < sizeof(struct header))
>   		die("recvmsg() returned short data: %zd", ret);
> -	if (msg.msg_namelen < sizeof(struct sockaddr_in))
> +	if (ret && msg.msg_namelen < sizeof(struct sockaddr_in))
>   		die("socklen = %d < sizeof(sin) (%zu)\n",
>   		    msg.msg_namelen, sizeof(struct sockaddr_in));
>
External rds-tools repo's are really stale. Which sources you
used to create this patch against ?

Regards,
Santosh
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
