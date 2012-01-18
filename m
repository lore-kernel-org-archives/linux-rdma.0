From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/mad: Return unsupported for MADs as appropriate
Date: Wed, 18 Jan 2012 12:50:02 -0700
Message-ID: <20120118195002.GL2892@obsidianresearch.com>
References: <20120118084255.18560.40844.stgit@kop-dev-sles11-04.qlogic.org>
 <20120118084311.18560.22509.stgit@kop-dev-sles11-04.qlogic.org>
 <1828884A29C6694DAF28B7E6B8A823732DC03E16@ORSMSX101.amr.corp.intel.com>
 <20120118190214.GK2892@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A823732DC04EDB@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823732DC04EDB-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Swapna Thete <swapna.thete-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 18, 2012 at 07:06:40PM +0000, Hefty, Sean wrote:

> > I feel if the base version is not supported then a GetResp should
> > be returned without a memcpy. The base version set to the highest
> > supported value and the TID copied over from the reply but
> > everything else 0'd. This allows base version discovery which
> > might be important some day.
> 
> See C13-47 - "Packets failing one or more of these checks are
> discarded and no action is taken in response unless the method is a
> Get() or a Set()."

Okay, agree.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
