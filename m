From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Mon, 11 May 2015 16:39:30 -0600
Message-ID: <20150511223930.GA15628@obsidianresearch.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
 <1430720099-32512-2-git-send-email-ira.weiny@intel.com>
 <1430750492.2407.9.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCA17C@ORSMSX109.amr.corp.intel.com>
 <1430761111.2407.85.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCA2F1@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB1418DF0669B6E6CABE1D9F1EB1D10@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <20BA79B2-9DA5-49B3-8455-BD4021CB882C@cisco.com>
 <1431142328.2407.488.camel@redhat.com>
 <CCC397F5-31B6-4A35-94E0-7EAAE6C4803F@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CCC397F5-31B6-4A35-94E0-7EAAE6C4803F-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dave Goodell (dgoodell)" <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 11, 2015 at 10:19:29PM +0000, Dave Goodell (dgoodell) wrote:

> > I really need to just sit down and read your driver front to back.
> 
> Feel free to ping me off-list if you want any explanation about
> what's going on in the usnic_verbs module.  I'm happy to help.

So, I look at this:

int usnic_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
                                struct ib_send_wr **bad_wr)
{
        usnic_dbg("\n");
        return -EINVAL;
}

And conclude that usnic doesn't actually provide any RDMA services to
in-kernel users, correct?

I'd then guess the entire point of this is to hack some non-RDMA
device to export it's interface via uverbs? Presumably because someone
nack'd using your own char device or whatever?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
