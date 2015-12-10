From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 03/37] IB/rdmavt: Add protection domain to rdmavt.
Date: Thu, 10 Dec 2015 19:10:40 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AAFE87D7@ORSMSX109.amr.corp.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
 <20151207204309.8144.26707.stgit@phlsvslse11.ph.intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AAFE7252@ORSMSX109.amr.corp.intel.com>
 <20151208190854.GA16976@phlsvsds.ph.intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AAFE79BE@ORSMSX109.amr.corp.intel.com>
 <20151208195236.GC16976@phlsvsds.ph.intel.com>
 <20151210164939.GD13412@phlsvsds.ph.intel.com>
 <20151210185944.GA7855@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151210185944.GA7855-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > How about I reword the comment to say that while we could continue
> > allocating PDs being only constrained by system resources, the spec says
> > there is a limit so we enforce that?
> 
> I'm ok with that, Sean?

That's fine
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
