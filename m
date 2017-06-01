From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/6] IB/core: Enable QP creation which is
 associated to underlay QP
Date: Thu, 1 Jun 2017 17:42:25 +0300
Message-ID: <1d799662-bc2b-ed12-882c-42d12d1ed8a1@dev.mellanox.co.il>
References: <20170530071602.8139-1-leon@kernel.org>
 <20170530071602.8139-2-leon@kernel.org>
 <20170530160447.GA21513@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530160447.GA21513-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/30/2017 7:04 PM, Jason Gunthorpe wrote:
> On Tue, May 30, 2017 at 10:15:57AM +0300, Leon Romanovsky wrote:
>> From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Enable QP creation which is associated to underlay QP.
>> The created QP will manage the scattering objects as of RQ and SQ, while
>> the transport attributes will be managed by its underlay QP
>>
>> This comes as a pre-patch for downstream patches in this series to
>> enable flow steering on the underlay IPoIB QP.
>
> I think you need to define the semantics here much more precisely.

Sure, please find below some clarifications on the semantics and the 
usage, will add as part of V1 to this commit log.

As described above this patch enables QP creation which is associated to 
some underlay QP as of IPoIB QP. It comes to allow in downstream patches 
a user space applications to accelerate send and receive traffic which 
is typically handled by IPoIB ULP.

A successful QP creation will end-up by having an overlay QP (e.g. the 
created one) which is associated to an already existing underlay one
(e.g. IPoIB QP).

The underlay QP is responsible for the transport, the packets on the 
wire will hold its QPN, its pkey will be used, etc.

The overlay QP can steer incoming packets which were target to the 
underlay QP into its own RQ. It can post send WQEs on its own SQ, the 
hardware will use the transport properties of the underlay QP
to format the packets on the wire.
Note: The underlay QP should be in an RTR/RTS state in order to enable 
the overlay QP to work properly.

Each QP should manage its properties and objects via modify, query and 
destroy. Specifically, overlay QP can't affect the underlay QP 
properties and vice versa.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
