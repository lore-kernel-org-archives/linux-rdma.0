From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: ibacm: Required-Start on openibd
Date: Wed, 26 Apr 2017 18:56:07 -0400
Message-ID: <1493247367.3041.140.camel@redhat.com>
References: <1493046558.17795.8.camel@profitbricks.com>
         <20170424155907.GB7927@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170424155907.GB7927-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-04-24 at 09:59 -0600, Jason Gunthorpe wrote:
> On Mon, Apr 24, 2017 at 05:09:18PM +0200, Benjamin Drung wrote:
> > 
> > Hi,
> > 
> > The init script for ibacm adds a Required-Start on openibd, but
> > rdma-
> > core does not ship an openibd service. redhat/rdma.service and
> > redhat/rdma.kernel-init seem to do the same job as openibd, but
> > they
> > are only used in rpm packages.
> > 
> > Can rdma-core ship a service that loads all the relevant kernel
> > modules? Then ibacm can depend on that service. I am not sure if
> > rdma.service is the best name for such an service.
> 
> Debian should use the RH for this scripts, I think.. Is there a
> problem with them?
> 
> Why does ibacm need to depend on rdma.service anyhow? Ideally we'd
> fix
> that..

Other than the fact that it doesn't make much sense without RDMA
interfaces, it doesn't have to depend on the rdma.service.  However, in
the early days, that wasn't true, it had problems if it was started
before all interfaces were up.  Back in the day, I put that dependency
in there to help alleviate that issue.  I haven't tested it lately to
see if it's gone or not, but one would hope so.  However, at least in
the systemd world, the rdma service is autostarted, so ibacm probably
ought to be autostarted too, regardless of whether it depends on the
rdma service or not.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
