From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address
 resolution module into core
Date: Mon, 16 May 2016 12:27:43 -0600
Message-ID: <20160516182743.GF7248@obsidianresearch.com>
References: <1462563928-29164-1-git-send-email-leon@kernel.org>
 <1462563928-29164-6-git-send-email-leon@kernel.org>
 <ea50f1d2-6f05-66f7-18f7-0a569fd9cea5@redhat.com>
 <VI1PR05MB1391AD099C536541E79A09F9D2760@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <db369e8e-7993-dfb8-d459-2c4f3d6e5b14@redhat.com>
 <20160516163048.GB4662@leon.nu>
 <298657b0-6e57-745b-5eb3-001984bffbc3@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <298657b0-6e57-745b-5eb3-001984bffbc3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 16, 2016 at 01:42:34PM -0400, Doug Ledford wrote:
> Can you build netlink in and then init the ib_addr module after the
> netlink init is complete?  Wouldn't that resolve the dependency ordering
> issue without changing the module names?

Why are you so worried about ib_addr's module name? Is that actually
hand loaded instead of relying in the implicit dependencies???

Is failure to load a module going to break any existing scripts?

Worse comes to worse, just make dummy empty ib_addr.ko, but
I've never seen that in-kernel before.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
