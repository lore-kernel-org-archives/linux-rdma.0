From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] rdma/core: Really export ib_open_qp() to user space
Date: Sun, 16 Oct 2011 11:41:12 +0200
Message-ID: <4E9AA6B8.8090707@mellanox.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E6AF56@ORSMSX101.amr.corp.intel.com> <1828884A29C6694DAF28B7E6B8A8237316E6B1B1@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E6B1B1-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dotan Barak <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/14/2011 10:22 PM, Hefty, Sean wrote:
> Just an update: the issues that I was seeing were caused by missing 
> patches in my libraries (one in libmlx4 and the other in the ofed 
> compatibility layer). The XRC patches in for-next are testing out fine 
> for me, though it would be good if someone from Mellanox could try 
> running some tests

Hi Sean,

I pulled for-next and made some basic IB tests with it, looks okay, 
specifically I used
ipoib connected mode and ibv_srq_pingpoing (libibverbs' srq test) to 
make sure non XRC
SRQs are working fine.

So what else would you suggest for further testing, is that pulling
the xrc branch of your ofa hosted librdmacm/libibverbs/libmlx4 trees
and run librdmacm's rdma_{xclient,xserver} example? I was a bit confused
since I see this example both in the master and the xrc brach.

BTW the master branch misses a tag for v1.0.15...

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
