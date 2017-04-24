From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ibacm: Required-Start on openibd
Date: Mon, 24 Apr 2017 09:59:07 -0600
Message-ID: <20170424155907.GB7927@obsidianresearch.com>
References: <1493046558.17795.8.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1493046558.17795.8.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 24, 2017 at 05:09:18PM +0200, Benjamin Drung wrote:
> Hi,
> 
> The init script for ibacm adds a Required-Start on openibd, but rdma-
> core does not ship an openibd service. redhat/rdma.service and
> redhat/rdma.kernel-init seem to do the same job as openibd, but they
> are only used in rpm packages.
> 
> Can rdma-core ship a service that loads all the relevant kernel
> modules? Then ibacm can depend on that service. I am not sure if
> rdma.service is the best name for such an service.

Debian should use the RH for this scripts, I think.. Is there a
problem with them?

Why does ibacm need to depend on rdma.service anyhow? Ideally we'd fix
that..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
