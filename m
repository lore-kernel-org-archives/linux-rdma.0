From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v1] libibverbs: Add support for usNIC nodes and
 transports
Date: Wed, 22 Jan 2014 17:32:06 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388D15319@ORSMSX109.amr.corp.intel.com>
References: <1390360721-14894-1-git-send-email-umalhi@cisco.com>
 <1828884A29C6694DAF28B7E6B8A8237388D1516D@ORSMSX109.amr.corp.intel.com>
 <97D33F82-21BA-4885-A909-7DCDBFCACD36@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <97D33F82-21BA-4885-A909-7DCDBFCACD36-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 	The underlaying requirement is to have two different transports for
> usNIC.  However, in verbs, there is a one to one relationship between node
> type and transport.  Hence, there are two nodes also.

The CA 'node' type supports multiple transports - UD, UC, RC, etc.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
