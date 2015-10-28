From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/mlx5: Publish mlx5 driver support for extended
 create QP
Date: Wed, 28 Oct 2015 12:24:00 -0600
Message-ID: <20151028182400.GB26645@obsidianresearch.com>
References: <1445993915-111262-1-git-send-email-eli@mellanox.com>
 <1445993915-111262-3-git-send-email-eli@mellanox.com>
 <20151028163225.GA14310@obsidianresearch.com>
 <HE1PR05MB1355F2259428B7DB0D096583C5210@HE1PR05MB1355.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <HE1PR05MB1355F2259428B7DB0D096583C5210-eBadYZ65MZ+lkJP6d7MyxNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org" <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 28, 2015 at 06:18:27PM +0000, Eli Cohen wrote:
> > Same comment as last time.
> >
> > http://thread.gmane.org/gmane.linux.drivers.rdma/26110/focus=26163
> >
> >This still hasn't been fixed.
> 
> Jason,
> 
> The relevant IB core patches have been accepted. Can you elaborate more on
> what your comments against this are?

Did you read the above thread?

Don't set uverbs_ex_cmd_mask in drivers.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
