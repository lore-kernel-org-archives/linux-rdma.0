From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] rdma/core: Really export ib_open_qp() to user space
Date: Mon, 17 Oct 2011 21:11:13 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E6B6AD@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E6AF56@ORSMSX101.amr.corp.intel.com>
	<1828884A29C6694DAF28B7E6B8A8237316E6B1B1@ORSMSX101.amr.corp.intel.com>
	<4E9AA6B8.8090707@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237316E6B4CF@ORSMSX101.amr.corp.intel.com>
 <CAJZOPZKKJUJ=RgPZHPEoi6Z5rntxCAg_MRqvup+68fhn5=6sVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZKKJUJ=RgPZHPEoi6Z5rntxCAg_MRqvup+68fhn5=6sVg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dotan Barak <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> again, and just to make sure I got it - for basic XRC testing which doesn't go
> to MPI nor to
> the OFED compatability APIs, what env/test would you recommend - is that the
> xrc branch on the three libraries and rdma_x{client, server}?

Yes - please make sure you have pulled those branches recently (since last Friday).  The rdma_cm tests are fairly simple and just transfer one direction.  The ibv_xsrq_pingpong tests will connect and transfer data both ways.

- Sean 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
