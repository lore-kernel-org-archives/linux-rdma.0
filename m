From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] IB/sa: Route SA pathrecord query through netlink
Date: Thu, 21 May 2015 12:12:00 -0600
Message-ID: <20150521181200.GC6771@obsidianresearch.com>
References: <3F128C9216C9B84BB6ED23EF16290AFB0CAB2E96@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB0CAB2E96-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 21, 2015 at 01:52:36PM +0000, Wan, Kaike wrote:
> 
> In our previous posting to the mailing list, we proposed to send a MAD request from kernel (more
> specifically, from ib_sa module) to a user space application (ibacm in this case) through netlink.
> The user space application will send back the response. This simple scheme can achieve the goal 
> of a local SA cache in user space.
> 
> The format of the request and response is diagrammed below:
> 
>   | netlink header |
>   |     MAD        |
> 
> The kernel requests for a pathrecord, and the user application finds it in its local cache and sends
> it to the kernel. If the netlink request fails, the kernel will send the request to SA through the
> normal IB path (ib_mad -> hca driver -> wire).
> 
> Jason pointed out that this message format was limited to lower stack format (MAD) and its use
> could not be readily extended to upper layer modules like rdma_cm. After lengthy discussions, we 
> come up with a new and modified scheme, as described below.
> 
> The general format of the request and response will be the same:
> 
>   | netlink header |
>   |  Data header   |
>   |      Data      |
> 
> The data header contains information about the type of request/response, the status (for response),
> the type (format) of the data, the total length of the data header + data, and a flags field about
> the request/response or data.

I assume we can stack multiple data records?

So a response can have the required number of path records?

There is growing interest in APM as well, please ensure that all 6 APM
records can be returned to any query:
 - Primary GMP Path
 - Primary Forward Path
 - Primary Return Path
 - Alternate GMP Path
 - Alternate Forward Path
 - Alternate Return Path

[Somewhere I have an experimental patch that globally enables one-shot
 APM for RDMA-CM users, it isn't a big step]

Please at least consider how we could use the netlink interface to
maintain APM when alternate paths trigger and new path data needs to
be loaded.

Please consider how we could use this netlink interface to alter
existing alternate paths on established QPs.

(Consider, means just think through how the protocol would work, not implement)

Can you please provide a some quick examples of exactly what the
exchange will look like:
 - IPoIB UD mode connecting to a peer based on a ND response
 - IPoIB RC mode connecting to a peer based on a ND response
 - RDMA CM connecting RC from a src IP to a dst IP

> #define IB_NL_DATA_TYPE_INVALID			0x0000
> #define IB_NL_DATA_TYPE_NAME			0x0001
> #define IB_NL_DATA_TYPE_ADDRESS_IP		0x0002
> #define IB_NL_DATA_TYPE_ADDRESS_IP6		0x0003
> #define IB_NL_DATA_TYPE_PATH_RECORD		0x0004
> #define IB_NL_DATA_TYPE_USER_PATH_REC		0x0005
> #define IB_NL_DATA_TYPE_MAD			0x0006

We definitely want to include policy information:
 - What IPoIB netdev is this associated with, if any
 - IP TOS bits, tclass, flowlabel
 - Requesting kernel agent
 - Src/Dst IP

I see this as a way to delegate path lookup to user space, so that
userspace can inject policy.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
