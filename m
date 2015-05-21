From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] IB/sa: Route SA pathrecord query through netlink
Date: Thu, 21 May 2015 19:14:57 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB0CAB304D@CRSMSX101.amr.corp.intel.com>
References: <3F128C9216C9B84BB6ED23EF16290AFB0CAB2E96@CRSMSX101.amr.corp.intel.com>
 <20150521181200.GC6771@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150521181200.GC6771-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > The general format of the request and response will be the same:
> >
> >   | netlink header |
> >   |  Data header   |
> >   |      Data      |
> >
> > The data header contains information about the type of
> > request/response, the status (for response), the type (format) of the
> > data, the total length of the data header + data, and a flags field about the
> request/response or data.
> 
> I assume we can stack multiple data records?
> 
> So a response can have the required number of path records?

Yes, you can. The type indicates the data format of individual record. The length field, along with potential flags definition (multi-record indicator), can determine how many records are returned.

> 
> There is growing interest in APM as well, please ensure that all 6 APM
> records can be returned to any query:
>  - Primary GMP Path
>  - Primary Forward Path
>  - Primary Return Path
>  - Alternate GMP Path
>  - Alternate Forward Path
>  - Alternate Return Path
> 

Using struct ib_path_rec_data in each record should be able to accomplish this. Again a type should be defined for this format. Alternative, we could define a mixed type where each data record has a subheader (subheader + data == data section):

#define IB_NL_DATA_TYPE_MIXED			0x0008

struct ib_nl_data_sub_hdr {
	__u16	type;
	__u16	flags;
	__u32	length;
};

----------------------
|  netlink header |
----------------------
| Data header      |
---------------------
| data subhdr 1   |
--------------------
|  data rec 1         |
--------------------
| data subhdr 2 |
--------------------
|  data rec 2       |
-------------------
|         ....                |
--------------------
| data subhdr N|
--------------------
| data rec N       |
-------------------


> [Somewhere I have an experimental patch that globally enables one-shot
> APM for RDMA-CM users, it isn't a big step]
> 
> Please at least consider how we could use the netlink interface to maintain
> APM when alternate paths trigger and new path data needs to be loaded.
> 
> Please consider how we could use this netlink interface to alter existing
> alternate paths on established QPs.
> 
> (Consider, means just think through how the protocol would work, not
> implement)
> 
> Can you please provide a some quick examples of exactly what the exchange
> will look like:
>  - IPoIB UD mode connecting to a peer based on a ND response
>  - IPoIB RC mode connecting to a peer based on a ND response

Not familiar with IPoIB and not sure what information exchange is needed here except for multicast group joining. MCMemberRecord could be gotten from a user application (SA proxy), similar to that for pathrecord, by sending query to the user application and getting back the MCMemberRecord. If the use application supports setting this attribute, it can be set through similar request/response exchange.

Any help for details?

>  - RDMA CM connecting RC from a src IP to a dst IP

Request from rdma_cm to resolve src/dst IP could be sent to user application (eg ibacm) and the pathrecord is sent back as the response. rdma_cm could use the returned info to establish connections. Again I am not familiar with the rdma_cm details.

Any expert out there? I know Sean is out today.

> 
> > #define IB_NL_DATA_TYPE_INVALID			0x0000
> > #define IB_NL_DATA_TYPE_NAME			0x0001
> > #define IB_NL_DATA_TYPE_ADDRESS_IP		0x0002
> > #define IB_NL_DATA_TYPE_ADDRESS_IP6		0x0003
> > #define IB_NL_DATA_TYPE_PATH_RECORD		0x0004
> > #define IB_NL_DATA_TYPE_USER_PATH_REC		0x0005
> > #define IB_NL_DATA_TYPE_MAD			0x0006
> 
> We definitely want to include policy information:
>  - What IPoIB netdev is this associated with, if any
>  - IP TOS bits, tclass, flowlabel
>  - Requesting kernel agent
>  - Src/Dst IP
> 
> I see this as a way to delegate path lookup to user space, so that userspace
> can inject policy.

As shown above, we can use subheader (or data sections) to aggregate data into one request/response.

Kaike

> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
