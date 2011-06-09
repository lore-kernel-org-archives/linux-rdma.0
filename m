From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] [PATCH 1/2] libibverbs: Allow 3rd party extensions to
 verb routines
Date: Thu, 9 Jun 2011 10:55:28 -0600
Message-ID: <20110609165528.GA6257@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A82373012B5B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373012B5B-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jun 04, 2011 at 12:34:46AM +0000, Hefty, Sean wrote:
> In order to support OFED or vendor specific calls, define a
> generic extension mechanism.  This allows OFED, an RDMA vendor,
> or another registered 3rd party (for example, the librdmacm)
> to define RDMA extensions.

After looking at this a bit I'm a bit concerned that your first
extension goes around and requires edits to the various structs
anyhow, which sort of defeats the purpose of making extensions, IMHO..

Do you think such changes will be required so often that this is just
extra complexity? For instance, could you implement the multicast self
loop flag feature using an extension ?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
