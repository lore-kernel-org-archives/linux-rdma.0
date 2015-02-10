From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: mlx4: IB_EVENT_PATH_MIG not generated on path migration
Date: Tue, 10 Feb 2015 11:00:39 -0700
Message-ID: <20150210180039.GD7427@obsidianresearch.com>
References: <20150210155643.GB13690@fholler.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150210155643.GB13690-99BIx50xQYGELgA04lAiVw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Fabian Holler <fabian.holler-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 10, 2015 at 04:56:43PM +0100, Fabian Holler wrote:

> Does anybody have an idea what could be wrong?
> Are the PATH_MIG* notifications with mlx4 drivers are working for somebody?

IIRC rdmacm does not forward these events.

There is a lot missing to support APM with RDMA CM, it doesn't do any
of the CM state machine operations to coordinate loading alternate
paths, for instance.

> As soon as the migration happens I expect that a IB_EVENT_PATH_MIG* is
> generated on the QP event handler, but I don't receive any QP events.

qp_event_handler is a RDMA CM event handler, it handles
RDMA_CM_EVENT_* and there is no RDMA_CM_EVENT_PATH_MIGRATED.

You'd need to listen to the verbs level events directly, I don't
recall if this is possible with RDMA CM or not, sorry.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
