From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 14/14] IB/mad: Add final OPA MAD processing
Date: Wed, 10 Jun 2015 12:56:53 -0600
Message-ID: <20150610185653.GA28153@obsidianresearch.com>
References: <1433615915-24591-1-git-send-email-ira.weiny@intel.com>
 <1433615915-24591-15-git-send-email-ira.weiny@intel.com>
 <HE1PR05MB1418BB6C461790B76D9C02A3B1BD0@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <1433961446.71666.26.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433961446.71666.26.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 10, 2015 at 02:37:26PM -0400, Doug Ledford wrote:
> On Wed, 2015-06-10 at 06:30 +0000, Liran Liss wrote:
> > > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > Hi Ira,
> > 
> > OPA cannot impersonate IB; OPA node and link types have to be
> > designated as such.  In terms of MAD processing flows, both
> > explicit (as in the handle_opa_smi() call below) and implicit code
> > paths (which share IB flows - there are several cases) must make
> > this distinction.
> 
> As far as in the kernel is concerned, the individual capability bits
> are much more important.  I would actually like to do away with the
> node_type variable from struct ib_device eventually.  As for user
> space,

All SMI code has different behavior if it is running on a switch or
HCA, so testing for 'switchyness' is very appropriate here.
cap_is_switch_smi would be a nice refinement to let us drop nodetype.

I don't have a problem with sharing the IBA constant names for MAD
structures (like RDMA_NODE_IB_SWITCH) between IB and OPA code. They
already share the structure layouts/etc.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
