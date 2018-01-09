From: "Bernard Metzler" <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH v2 03/13] Attach/detach SoftiWarp to/from network and RDMA
 subsystem
Date: Tue, 9 Jan 2018 16:58:59 +0000
Message-ID: <OF38355950.8A86F33F-ON00258210.005B3539-00258210.005D4AA4@notes.na.collabserv.com>
References: <20180104182108.GR11348@ziepe.ca>,<20171008130342.GV25829@mtr-leonro.local>
 <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-4-bmt@zurich.ibm.com>
 <OF406E95F8.33CF80BB-ON002581B9.00073D6F-002581B9.00081F69@notes.na.collabserv.com>
 <OF663C0801.8471532E-ON002581FE.003B73D6-002581FE.003F2369@notes.na.collabserv.com>
 <20180102213706.GB19027@ziepe.ca> <20180103052529.GI10145@mtr-leonro.local>
 <20180103155225.GA11348@ziepe.ca> <20180103173105.GX10145@mtr-leonro.local>
 <OF156C6886.C5A736C2-ON0025820B.005235C2-0025820B.0052EF8F@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180104182108.GR11348-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


-----Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote: -----

>To: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
>From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
>Date: 01/04/2018 07:21PM
>Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Subject: Re: [PATCH v2 03/13] Attach/detach SoftiWarp to/from network
>and RDMA subsystem
>
>On Thu, Jan 04, 2018 at 03:05:52PM +0000, Bernard Metzler wrote:
>
>> What about potentially enabling it on all interfaces which are used
>> by TCP? iWarp is an ULP to TCP... Exceptions might be interfaces
>which
>> implement their own RDMA protocol - like iWARP adapters, or IPoIB
>> devices, or interfaces which already have a use from SoftRoCE.
>
>Since soft iwarp is likely to start out as a huge security risk, it
>should be opted into.
>
>Jason
>
>
Right, security will likely be one of the debates..!

Can't parse that above - are you suggesting only explicitly enabling softiwarp
on a per interface basis?

Thanks!
Bernard.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
