From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 12/15] IB/srpt: Eliminate srpt_find_channel()
Date: Wed, 6 Jan 2016 06:15:17 +0100
Message-ID: <20160106051517.GL15574@lst.de>
References: <568BD0FC.70207@sandisk.com> <568BD28E.40302@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <568BD28E.40302-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 05, 2016 at 03:26:22PM +0100, Bart Van Assche wrote:
> In the CM REQ message handler, store the channel pointer in
> cm_id->context such that the function srpt_find_channel() is no
> longer needed. Additionally, make the CM event messages more
> informative.

Looks fine,

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
