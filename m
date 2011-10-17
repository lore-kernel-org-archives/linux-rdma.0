From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] rdma/core: Really export ib_open_qp() to user space
Date: Mon, 17 Oct 2011 17:12:19 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E6B4CF@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E6AF56@ORSMSX101.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A8237316E6B1B1@ORSMSX101.amr.corp.intel.com>
 <4E9AA6B8.8090707@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E9AA6B8.8090707-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dotan Barak <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> So what else would you suggest for further testing, is that pulling
> the xrc branch of your ofa hosted librdmacm/libibverbs/libmlx4 trees
> and run librdmacm's rdma_{xclient,xserver} example? I was a bit confused
> since I see this example both in the master and the xrc brach.

I wanted to keep the rdma_client / rdma_server tests as simple as possible, but I still wanted a more complete client / server test where I could add RDMA reads / writes / etc.  The rdma_xclient / rdma_xserver tests are a place for those.  They support RC and XRC, so they're in the master branch for the RC support.  I have extensions for them in a private branch which aren't quite ready yet.

For my testing, I pulled mvapich2 and run with and without xrc support, plus the normal verbs tests.  For the xrc support I have to build with the OFED compatibility APIs added into verbs.

> BTW the master branch misses a tag for v1.0.15...

thanks - I'll add.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
