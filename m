From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: cq-event kernel panic
Date: Fri, 20 Jan 2012 16:04:42 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823732DC11554@ORSMSX101.amr.corp.intel.com>
References: <4F194ABE.5080108@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F194ABE.5080108-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> We are still seeing kernel panics with linux-3.2, this time initiated
> from mthca_cq_event(). I'm unsure if this is somehow related to the
> yesterdays cq_completion patch. In any case, I'm CCing Sean therefore.

Was your patch applied when testing?  mthca uses kmalloc to allocate the QP structure.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
