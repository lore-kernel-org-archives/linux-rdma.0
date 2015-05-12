From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Tue, 12 May 2015 12:08:15 -0600
Message-ID: <20150512180815.GB15891@obsidianresearch.com>
References: <1430750492.2407.9.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCA17C@ORSMSX109.amr.corp.intel.com>
 <1430761111.2407.85.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCA2F1@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB1418DF0669B6E6CABE1D9F1EB1D10@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <20BA79B2-9DA5-49B3-8455-BD4021CB882C@cisco.com>
 <1431142328.2407.488.camel@redhat.com>
 <CCC397F5-31B6-4A35-94E0-7EAAE6C4803F@cisco.com>
 <20150511223930.GA15628@obsidianresearch.com>
 <DC760F33-F704-4763-AEA3-6DE9016D0687@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DC760F33-F704-4763-AEA3-6DE9016D0687-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dave Goodell (dgoodell)" <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 12, 2015 at 05:41:14PM +0000, Dave Goodell (dgoodell) wrote:

> > I'd then guess the entire point of this is to hack some non-RDMA
> > device to export it's interface via uverbs?
> 
> If by "non-RDMA", you mean "does not currently support hardware
> offload of direct data placement", then yes.  There are a couple of
> things to keep in mind:

I actually mean 'does not provide RDMA services to the kernel'.

What actually happens if you, for instance, load the iser module and
try and use it with usnic?

What parts of the RDMA core code does usnic actually use beyond
command marshaling through uverbs?

Would things be easier for you if usnic lived within DPDK?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
