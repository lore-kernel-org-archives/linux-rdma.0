From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 08/15] IB/pvrdma: Add support for Completion Queues
Date: Thu, 8 Sep 2016 12:46:08 -0600
Message-ID: <20160908184608.GG21614@obsidianresearch.com>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-9-git-send-email-aditr@vmware.com>
 <20160825124120.GB27446@yuval-lap.uk.oracle.com>
 <BLUPR0501MB83629470B22B65E27B4332AC5F80@BLUPR0501MB836.namprd05.prod.outlook.com>
 <20160908081802.GA3300@yuval-lap.mynet>
 <BLUPR0501MB836A35B3F4B839B1E2055A8C5FB0@BLUPR0501MB836.namprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BLUPR0501MB836A35B3F4B839B1E2055A8C5FB0-84Rf5TRaNBMVDhIuTCx1aJLWcSx1hRipwIZJ9u9yWa8oOQlpcoRfSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 08, 2016 at 06:26:35PM +0000, Adit Ranadive wrote:

> Ok, sounds reasonable. I understand Jason's concerns. Thanks for pointing me those
> links! I can return -EAGAIN here and add a dev warning to make sure we atleast log this
> condition.

EAGAIN doesn't sound right, you need to recover the CQ to a point
where it works properly or lock it into empty (ie return 0) and
trigger a whole device restart, or something else similar.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
