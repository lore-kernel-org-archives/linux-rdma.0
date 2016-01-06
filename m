From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 11/15] IB/srpt: Fix how aborted commands are processed
Date: Wed, 6 Jan 2016 06:13:05 +0100
Message-ID: <20160106051305.GK15574@lst.de>
References: <568BD0FC.70207@sandisk.com> <568BD26D.9080003@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <568BD26D.9080003-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>  	pr_debug("Aborting cmd with state %d and tag %lld\n", state,
>  		 ioctx->cmd.tag);
>  
> @@ -1299,14 +1291,16 @@ static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
>  	case SRPT_STATE_NEW:
>  	case SRPT_STATE_DATA_IN:
>  	case SRPT_STATE_MGMT:
> +	case SRPT_STATE_DONE:
>  		/*
>  		 * Do nothing - defer abort processing until
>  		 * srpt_queue_response() is invoked.
>  		 */
> -		WARN_ON(!(ioctx->cmd.transport_state & CMD_T_ABORTED));

Seems like this depends on your target core changes?  Maybe it would be better
to respin the series to got just on top of Doug's RDMA tree, as I think
we're more likely to get this series merged for 4.5 than the target core
changes..

Otherwise these changes look fine to me.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
