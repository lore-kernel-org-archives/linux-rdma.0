From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 4/4] IB/sa: Route SA pathrecord query through netlink
Date: Wed, 10 Jun 2015 13:10:26 -0600
Message-ID: <20150610191026.GA28334@obsidianresearch.com>
References: <1433861837-26177-1-git-send-email-kaike.wan@intel.com>
 <1433861837-26177-5-git-send-email-kaike.wan@intel.com>
 <55787838.3020606@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55787838.3020606-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 10, 2015 at 01:47:36PM -0400, Hal Rosenstock wrote:
> On 6/9/2015 10:57 AM, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > This patch routes a SA pathrecord query to netlink first
> 
> Should only unicast PRs be done in this manner or should API support
> enabling for unicast and/or multicast ?
> 
> AFAIK kernel doesn't query multicast PRs now (queries MCMRs) but this
> seems like it would help make it future proof and not have to take
> timeout on local query unless app supports it.

It is a good question. We can clearly extend toward that, using a MGID
as the DGID and adding additional nested netlink fields.

However, does it make sense? I don't think user space should be
joining on behalf of the kernel... Do we ever query without a join?

Jasno
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
