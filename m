From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [Patch infiniband-diags:perfquery] Loop through all local
 HCAs/ports
Date: Fri, 29 Jul 2011 16:09:12 -0600
Message-ID: <20110729220912.GL18090@obsidianresearch.com>
References: <4E332CE5.3010706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4E332CE5.3010706-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 29, 2011 at 05:57:57PM -0400, Doug Ledford wrote:
> The -a mode of perfquery is intended to loop through all ports on a
> single HCA and provide aggregated output across all ports.
> 
> The -l mode is intended to loop through all ports of a single HCA
> and output non-aggregated data.

Actually, none of these modes are intended to support HCA scenarios,
they are all only for switches.

Not sure what I think of this, is dumping counters on all local HCA
ports really that interesting? Would this be better done by doing
something fancy with nodeGUID so at least all ports on remote HCAs can
be dumped too?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
