From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: Re: [PATCH] rdma cm typo + bug report
Date: Mon, 09 May 2011 17:53:58 -0500
Message-ID: <4DC87086.60806@systemfabricworks.com>
References: <4DC861A7.5010005@systemfabricworks.com> <1828884A29C6694DAF28B7E6B8A82373B942@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373B942-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/09/2011 05:34 PM, Hefty, Sean wrote:

>> I also think there's a bug with ucma_create_cqs()/ucma_destroy_cqs()
>> because ucma_destroy_cqs unconditionally destroys the CQs, even if they
>> were given by the application. librdmacm should only destroy the CQs it
>> created.
> 
> I think we're okay here.  ucma_create_cqs() only allocates a CQ if the user specified a CQ of NULL as part of the QP attributes.  It stores the allocated CQ in id->send/recv_cq.  ucma_destroy_cqs() checks for id->send/recv_cq and destroys them.

Indeed. Sorry.

Frank.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
