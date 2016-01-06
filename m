From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 13/15] IB/srpt: Detect session shutdown reliably
Date: Wed, 6 Jan 2016 18:04:50 +0100
Message-ID: <20160106170450.GA26304@lst.de>
References: <568BD0FC.70207@sandisk.com> <568BD2A9.6070600@sandisk.com> <568D2707.9020309@dev.mellanox.co.il> <568D28CA.8010804@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <568D28CA.8010804-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 06, 2016 at 03:46:34PM +0100, Bart Van Assche wrote:
> I will make the patch description more detailed. Sorry if some of this code 
> is hard to follow but that's because of the high level of concurrency in 
> the SRP target driver. Some time ago I documented how session management in 
> the SCST ib_srpt driver works. This driver follows the same model. These 
> notes can be found here: 
> http://sourceforge.net/p/scst/svn/HEAD/tree/trunk/srpt/session-management.txt.

It might be useful to eventually add a version of that to the Linux
kernel tree as well.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
