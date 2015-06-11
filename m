From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 0/4] Sending kernel pathrecord query to user cache
 server
Date: Thu, 11 Jun 2015 12:58:35 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB0CABD09D@CRSMSX101.amr.corp.intel.com>
References: <1433861837-26177-1-git-send-email-kaike.wan@intel.com>
 <55783D84.6040709@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373A8FE6677@ORSMSX109.amr.corp.intel.com>
 <55786ACC.4070704@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373A8FE680D@ORSMSX109.amr.corp.intel.com>
 <20150610191439.GB28334@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150610191439.GB28334-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Wednesday, June 10, 2015 3:15 PM
> 
> On Wed, Jun 10, 2015 at 05:04:55PM +0000, Hefty, Sean wrote:
> > > Not in the patches themselves but in the general issue when a PR changes.
> > >
> > > Do you think this needs addressing or are things fine as they are now ?
> >
> > IMO, I think it needs addressing in terms of "can the proposed netlink
> > architecture and design accommodate this sort of request in the
> > future?"  We shouldn't design in a limitation up front.  I don't see
> > anything in the current approach that would cause an issue.
> > There would likely be a need for new messages and attributes.
> 
> I think the kernel netlink side is fine.
> 
> But userspace needs to understand what to do if it gets a request with an
> attribute it does not understand.
> 
> It should tell the kernel 'no, do it yourself', rather than try and answer.

I will add some code in ibacm to do that.

Kaike

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
