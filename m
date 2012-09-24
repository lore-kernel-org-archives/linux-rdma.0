From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/8] libibverbs: Infra-structure changes to support verbs
 extension
Date: Mon, 24 Sep 2012 14:51:18 -0600
Message-ID: <20120924205118.GA10964@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A8E7ED@ORSMSX101.amr.corp.intel.com>
 <20120924202314.GA9472@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237346A8F003@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A8F003-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 24, 2012 at 08:39:10PM +0000, Hefty, Sean wrote:

> > This makes compatability with old verbs easier, and means you can
> > detect if the verbs_device is present based only on an 'ibv_device
> > *' pointer, this is more flexible going forward.
> 
> ibverbs could always export an extended device through a
> compatibility layer, similar to what I added in patch 2.

We only get one chance to re-use the alloc_contex entry as an
extension flag, and this is it. What is here is fine for the two
functions added but if we want a new device function in future that is
not tied to a context (eg query_device_capabilities_ex, say) then we
are pretty stuck.
 
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
