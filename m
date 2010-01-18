From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv7 4/9] ib_core: RoCEE CMA device binding
Date: Mon, 18 Jan 2010 10:00:08 +0200
Message-ID: <4B541508.5050306@Voltaire.com>
References: <20100105103257.GF31480@mtls03> <4B45E977.70805@Voltaire.com>	<20100107151912.GB2892@mtls03>	<1E5F6C57727E4A3BB737240D2D1942A4@amr.corp.intel.com>	<20100107182451.GD4664@obsidianresearch.com> <20100111105450.GA10818@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100111105450.GA10818@mtls03>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Eli Cohen wrote:
> The other place is IPoIB:path_rec_completion() where we need not require
> GRH since IPoIB over RoCEE is disable

please note that can't assume that IPoIB need not use GRH, as at some future point this code can operate across IB subnets, for couple of years patches to allow for supporting that are merged into the code, e.g see 46f1b3d7 "IB/ipoib: Use ib_init_ah_from_path to initialize ah_attr"

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
