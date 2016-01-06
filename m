From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 10/15] IB/srpt: Fix srpt_handle_cmd() error paths
Date: Wed, 6 Jan 2016 06:09:54 +0100
Message-ID: <20160106050954.GJ15574@lst.de>
References: <568BD0FC.70207@sandisk.com> <568BD249.1000100@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <568BD249.1000100-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 05, 2016 at 03:25:13PM +0100, Bart Van Assche wrote:
> The target core function that should be called if target_submit_cmd()
> fails is target_put_sess_cmd(). Additionally, change the return type
> of srpt_handle_cmd() from int into void.

I actually ran into this bug a long time ago with a modified srpt driver
and forgot to send a similar fix..

Looks good:

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Minor nitpick below:

> +	send_ioctx->state = SRPT_STATE_DONE;
> +	target_put_sess_cmd(cmd);
> +	return;
>  }

no need for that return statement.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
