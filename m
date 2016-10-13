From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 12/32] iwpmd: fix the prototype for the pthread_create start functions
Date: Thu, 13 Oct 2016 14:09:44 -0500
Message-ID: <021b01d22585$5b60bbf0$122233d0$@opengridcomputing.com>
References: <1476381095-20041-1-git-send-email-hch@lst.de> <1476381095-20041-13-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476381095-20041-13-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> @@ -1438,11 +1438,11 @@ int main(int argc, char *argv[])
>  	pthread_cond_init(&cond_req_complete, NULL);
>  	pthread_cond_init(&cond_pending_msg, NULL);
> 
> -	ret = pthread_create(&map_req_thread, NULL,
> &iwpm_mapping_reqs_handler, NULL);
> +	ret = pthread_create(&map_req_thread, NULL,
> iwpm_mapping_reqs_handler, NULL);
>  	if (ret)
>  		goto error_exit;
> 
> -	ret = pthread_create(&pending_msg_thread, NULL,
> &iwpm_pending_msgs_handler, NULL);
> +	ret = pthread_create(&pending_msg_thread, NULL,
> iwpm_pending_msgs_handler, NULL);
>  	if (ret)
>  		goto error_exit;

How did this work before?

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
