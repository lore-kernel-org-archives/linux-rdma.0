From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1] libibverbs: Add support for usNIC nodes and
 transports
Date: Wed, 22 Jan 2014 17:59:20 +0000
Message-ID: <D0DEB791-D0BE-489F-AA66-7055099108B0@cisco.com>
References: <1390360721-14894-1-git-send-email-umalhi@cisco.com>
 <1828884A29C6694DAF28B7E6B8A8237388D1516D@ORSMSX109.amr.corp.intel.com>
 <97D33F82-21BA-4885-A909-7DCDBFCACD36@cisco.com>
 <1828884A29C6694DAF28B7E6B8A8237388D15319@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388D15319-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Content-ID: <AE7E75D7D940CF428D49FFECAE3A6CFF-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean,
	AFAIK can see from the code, the CA node type corresponds to the "IBV_TRANSPORT_IB."  The packet format might change slightly depending on QP type, but the *base* transport remains IB.

usNIC supports two distinct transports; custom roce and UDP.  Unless I am missing something, the only way to represent these in the verbs code is by having two separate nodes.

Upinder


On Jan 22, 2014, at 9:32 AM, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 wrote:

>> 	The underlaying requirement is to have two different transports for
>> usNIC.  However, in verbs, there is a one to one relationship between node
>> type and transport.  Hence, there are two nodes also.
> 
> The CA 'node' type supports multiple transports - UD, UC, RC, etc.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
