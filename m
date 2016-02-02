From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v2 07/22] IB/srpt: Simplify srpt_handle_tsk_mgmt()
Date: Tue, 2 Feb 2016 11:59:38 +0100
Message-ID: <20160202105938.GB28315@lst.de>
References: <56ABF16E.7070006@sandisk.com> <56ABF21C.5070409@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56ABF21C.5070409-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 29, 2016 at 03:13:32PM -0800, Bart Van Assche wrote:
> Let the target core check task existence instead of the SRP target
> driver. Additionally, let the target core check the validity of the
> task management request instead of the ib_srpt driver.

Looks good,

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

But two comments:

 - it would be nice to move this to the front of the series to
   ease stable backports as Alex seems to be hitting a bug this
   fixes.
 - maybe defer adding the UNKNOWN_TMR constants to minimize conflicts
   with target core updates.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
