From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] Enhanced mode for IPoIB driver
Date: Wed, 12 Apr 2017 09:50:24 -0600
Message-ID: <20170412155024.GB14409@obsidianresearch.com>
References: <20170404191732.31895-1-leon@kernel.org>
 <2807E5FD2F6FDA4886F6618EAC48510E67C8CAA0@CRSMSX101.amr.corp.intel.com>
 <20170404200335.GB20443@mtr-leonro.local>
 <2807E5FD2F6FDA4886F6618EAC48510E67C8DAB7@CRSMSX101.amr.corp.intel.com>
 <20170406052820.GB2269@mtr-leonro.local>
 <20170406151014.GA173962@knc-06.sc.intel.com>
 <20170410080228.GP2269@mtr-leonro.local>
 <20170410154039.GA7056@obsidianresearch.com>
 <20170412052223.GQ2269@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170412052223.GQ2269-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 12, 2017 at 08:22:23AM +0300, Leon Romanovsky wrote:

> Yes, you did, however for many reasons hfi ended to be subsystem on
> its own, and now we are moving this subsystem one layer up. I really
> failed to understand your point of view, why hfi-vnic is not linked
> to specific hardware.

Well, the ULP part is clearly not hardware specific, it uses generic
interfaces like mad and rdma netdev (eg the same generic interfaces as
ipoib) - that was part of the transformation since the first series
was presented.

We have been treating OPA as a top level protocol on par with
rocee,ib,iwarp - so an OPA specific ULP that only uses core interfaces
seems reasonable.

It has changed alot since the first series, it is no longer tightly
linked to hfi1. But it does use OPA specific MADs and requires the
driver implement the opa_vnic rdma_netdev API.

It very clearly has nothing to do with hfi1, other than hfi1 is the
only driver implementing OPA.

I think there is a path to make this work on IB if someone cared to do
it, but I think it is unreasonable to demand Intel do that work.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
