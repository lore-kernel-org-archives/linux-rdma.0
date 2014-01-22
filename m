From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v1] libibverbs: Add support for usNIC nodes and
 transports
Date: Wed, 22 Jan 2014 18:47:00 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388D155AC@ORSMSX109.amr.corp.intel.com>
References: <1390360721-14894-1-git-send-email-umalhi@cisco.com>
 <1828884A29C6694DAF28B7E6B8A8237388D1516D@ORSMSX109.amr.corp.intel.com>
 <97D33F82-21BA-4885-A909-7DCDBFCACD36@cisco.com>
 <1828884A29C6694DAF28B7E6B8A8237388D15319@ORSMSX109.amr.corp.intel.com>
 <D0DEB791-D0BE-489F-AA66-7055099108B0@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D0DEB791-D0BE-489F-AA66-7055099108B0-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 	AFAIK can see from the code, the CA node type corresponds to the
> "IBV_TRANSPORT_IB."  The packet format might change slightly depending on
> QP type, but the *base* transport remains IB.

You're right from an API perspective.  The actual transport layer is reported by verbs using multiple fields: transport + QP type.
 
> usNIC supports two distinct transports; custom roce and UDP.  Unless I am
> missing something, the only way to represent these in the verbs code is by
> having two separate nodes.

Verbs seems broken.  The node hasn't changed, and I don't see why some version of usNIC couldn't run both transport protocols at once.  Maybe a better way of mapping usNIC to verbs is to map custom RoCE (sounds like code for non-compliant) and UDP to a QP type?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
