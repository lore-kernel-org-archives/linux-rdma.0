From: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/4] RDMA/nes and RDMA/cxgb4: iWARP Port Mapper Overview
Date: Thu, 5 Sep 2013 16:01:47 +0000
Message-ID: <13AA599688F47243B14FCFCCC2C803BB0D834874@FMSMSX104.amr.corp.intel.com>
References: <20130831194127.GA22152@TENIKOLO-MOBL1>
 <52260168.8030706@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52260168.8030706-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Sharp, Robert O" <robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Lacombe, John S" <john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org" <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Hello Steve,

Thank you for the feedback.

>> I think there are lots of #defines and enums replicated in both 
>> nes_netlink.h and c4iw_netlink.h.  For example, the IWPM_* 
>> defines and enums.  It seems like we could put all this in a common header file to be included by all iwarp providers?  
>> Say include/rdma/iw_portmap.h or something.

Having a common rdma/iw_portmap.h is a good idea. 

>> (and maybe even a common core module if there is enough common 
>> functions)

At this early stage of the project, I think that having a separate core module for the iwarp port mapper could be overhead. That is the reason we initially decided to keep the changes locally in the drivers using the service.

Tatyana

-----Original Message-----
From: Steve Wise [mailto:swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org] 
Sent: Tuesday, September 03, 2013 10:34 AM
To: Nikolova, Tatyana E
Cc: Roland Dreier; Sharp, Robert O; Lacombe, John S; vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [PATCH 0/4] RDMA/nes and RDMA/cxgb4: iWARP Port Mapper Overview

On 8/31/2013 2:41 PM, Tatyana Nikolova wrote:
> Hello All,
>
> This patch series adds iWARP Port Mapper (IWPM) service support in 
> RDMA/core, RDMA/nes driver and RDMA/cxgb4 driver. The iWARP Port 
> Mapper implementation is based on the port mapper specification 
> section in the Sockets Direct Protocol paper - 
> http://www.rdmaconsortium.org/home/draft-pinkerton-iwarp-sdp-v1.0.pdf
>

Hey Tatyana,

I'm replying to 0/4 because these comments are for both iwarp providers.

I think there are lots of #defines and enums replicated in both nes_netlink.h and c4iw_netlink.h.  For example, the IWPM_* defines and enums.  It seems like we could put all this in a common header file to be included by all iwarp providers?  Say include/rdma/iw_portmap.h or something.  Basically the interface to the user mode daemon is the same for all providers, no?  Those bits should be in a common header.  (and maybe even a common core module if there is enough common functions).

Thoughts?

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
