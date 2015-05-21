From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] IB/sa: Route SA pathrecord query through netlink
Date: Thu, 21 May 2015 20:40:17 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FDE257@ORSMSX109.amr.corp.intel.com>
References: <3F128C9216C9B84BB6ED23EF16290AFB0CAB2E96@CRSMSX101.amr.corp.intel.com>
 <20150521194439.GA6389@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150521194439.GA6389-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > #define IB_NL_DATA_TYPE_INVALID			0x0000
> > #define IB_NL_DATA_TYPE_NAME			0x0001
> > #define IB_NL_DATA_TYPE_ADDRESS_IP		0x0002
> > #define IB_NL_DATA_TYPE_ADDRESS_IP6		0x0003
> > #define IB_NL_DATA_TYPE_PATH_RECORD		0x0004
> > #define IB_NL_DATA_TYPE_USER_PATH_REC		0x0005
> 
> Do we need both PATH_RECORD and USER_PATH_REC?
> 
> I'm having trouble determining when the OP == QUERY_PATH and the DATA_TYPE
> !=
> PATH_RECORD.
> 
> Why don't we remove "QUERY_PATH" above and allow OP == RESOLVE and
> DATA_TYPE ==
> PATH_RECORD be a "query for path record"?

I agree with Ira.

Conceptually, there are at least 2 pieces of information that need to be provided.  The format/type of the input data and the desired output data.  It looks like Kaike is using the ibacm protocol as a base.  I *think* the QUERY_PATH operation for ibacm forced an SA query.  (It is used for testing purposes.  That, or I'm remembering something else and associating it with QUERY_PATH.)

The desired output data can either be encoded as part of the operation or separated into its own field.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
