From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 08/15] IB/srpt: Simplify srpt_shutdown_session()
Date: Wed, 6 Jan 2016 06:07:00 +0100
Message-ID: <20160106050700.GH15574@lst.de>
References: <568BD0FC.70207@sandisk.com> <568BD20F.7020101@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <568BD20F.7020101-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 05, 2016 at 03:24:15PM +0100, Bart Van Assche wrote:
> The target core guarantees that shutdown_session() is only invoked
> once per session. This means that the ib_srpt target driver doesn't
> have to track whether or not shutdown_session() has been called.
> Additionally, ensure that target_sess_cmd_list_set_waiting() is
> called before target_wait_for_sess_cmds() by moving it into
> srpt_release_channel_work().

Looks good,

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Mote that now most drivers return either always return 0 or 1 from
shutdown_session, so it might be worth to investigate if we can get
rid of this method in the future.

Minor nitpick below:

>  static int srpt_shutdown_session(struct se_session *se_sess)
>  {
>  	return true;
>  }


Given that the function returns in this really should be 1 in instead of
true, but it's not really worth respinning the patch just for this.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
