From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 07/15] IB/srpt: Simplify channel state management
Date: Wed, 6 Jan 2016 06:01:45 +0100
Message-ID: <20160106050145.GG15574@lst.de>
References: <568BD0FC.70207@sandisk.com> <568BD1F1.5050107@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <568BD1F1.5050107-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 05, 2016 at 03:23:45PM +0100, Bart Van Assche wrote:
> The only allowed channel state changes are those that change
> the channel state into a state with a higher numerical value.
> This allows to merge the functions srpt_set_ch_state() and
> srpt_test_and_set_ch_state() into a single function.

It would be great having a little comment in srpt_set_ch_state explaining
why only changing to the numerical greater state is fine.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
