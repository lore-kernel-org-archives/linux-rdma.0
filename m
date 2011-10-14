From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rdma: 3.1.0-rc9 breaks UD
Date: Fri, 14 Oct 2011 16:36:59 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E6AFC1@ORSMSX101.amr.corp.intel.com>
References: <alpine.DEB.2.00.1110140852210.6411@router.home>
 <1828884A29C6694DAF28B7E6B8A8237316E6AF8E@ORSMSX101.amr.corp.intel.com>
 <alpine.DEB.2.00.1110141131150.6411@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1110141131150.6411-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Our 3.1-rc9 included Rolands for-next branch.

Actually, mine did too.  I wonder if this OFED patch to libibverbs is causing the issue:

http://git.openfabrics.org/git?p=ofed_1_5/libibverbs.git;a=blob;f=fixes/rocee_examples.patch;h=eda5a401a3424a104e8100848b5b6bf4e5b63bee;hb=HEAD
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
