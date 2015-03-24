From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v4 14/19] IB/core: Add IB_DEVICE_OPA_MAD_SUPPORT device
 cap flag
Date: Tue, 24 Mar 2015 13:49:37 +0100
Message-ID: <55115D61.9040201@profitbricks.com>
References: <550C2514.5070001@profitbricks.com>	<6A3D3202-0128-4F33-B596-D7A76AB66DF8@gmail.com>	<20150320235748.GA22703@phlsvsds.ph.intel.com>	<20150321000541.GA24717@phlsvsds.ph.intel.com> <CAJuTgQUsZ34F-dKpsmW+5=axDWb93pA43LZ-qKbEjqyu-RUUmg@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A8237399E82E58@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399E82E58-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/23/2015 05:31 PM, Hefty, Sean wrote:
>> [snip]
> To restate my suggesting, I was thinking of defining something like this:
>
> enum {
> 	IB_MGMT_PROTO_SM = (1 << 0),   /* supports IB SMPs */
> 	IB_MGMT_PROTO_SA = (1 << 1),   /* supports IB SA MADs */
> 	IB_MGMT_PROTO_GS = (1 << 2),   /* supports IB GSI MADs (e.g. PM, ...) */
> 	IB_MGMT_PROTO_CM = (1 << 3),   /* IB CM called out separately */
> 	IB_MGMT_PROTO_IW_CM = (1 << 4),/* iWarp CM */
> 	/* OPA can define new values here */
> };
>
> struct ib_port_attr {
> 	...
> 	u32	mgmt_proto;  /* bitmask of supported protocols */
> };

Thanks for the restate, Sean :) seems like your proposal is also to ask 
vendor
setup 'mgmt_proto' during ib_query_port(), correct?

>
> I am not familiar enough with RoCE (IBoE) to know off the top of my head if this breakdown works as I defined it, or if IB_MGMT_PROTO_GS needs to be separated into more mgmt classes.  (Hal or Ira might.)  I separated out the CM class, as the rdma cm has checks where it wants to distinguish between which CM protocol to execute (IB or iWarp).

Maybe we can apply this thought to CM part firstly?
>
> This change would be limited to management checks only.  There may still be places in the code where the link and transport checks would continue to exist.  Again, this is just a suggestion.  Without actually implementing the patch, I don't know if this would simplify things.  The checks in the rdma cm, in particular, are messy.
I think it's time to make a formal patch now and discuss the problem in
a separate thread, I'll still use the mechanism in draft and apply these
flags, let's see if it satisfied peoples ;-)

Regards,
Michael Wang

> - Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
