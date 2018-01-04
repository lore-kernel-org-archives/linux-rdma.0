From: "Bernard Metzler" <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH v2 03/13] Attach/detach SoftiWarp to/from network and RDMA
 subsystem
Date: Thu, 4 Jan 2018 15:05:52 +0000
Message-ID: <OF156C6886.C5A736C2-ON0025820B.005235C2-0025820B.0052EF8F@notes.na.collabserv.com>
References: <20180103173658.GE11348@ziepe.ca>,<20171014064132.GT2106@mtr-leonro.local>
 <20171008130342.GV25829@mtr-leonro.local>
 <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-4-bmt@zurich.ibm.com>
 <OF406E95F8.33CF80BB-ON002581B9.00073D6F-002581B9.00081F69@notes.na.collabserv.com>
 <OF663C0801.8471532E-ON002581FE.003B73D6-002581FE.003F2369@notes.na.collabserv.com>
 <20180102213706.GB19027@ziepe.ca> <20180103052529.GI10145@mtr-leonro.local>
 <20180103155225.GA11348@ziepe.ca> <20180103173105.GX10145@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180103173658.GE11348-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



---
Bernard Metzler, PhD
Tech. Leader High Performance I/O, Principal Research Staff
IBM Zurich Research Laboratory
Saeumerstrasse 4
CH-8803 Rueschlikon, Switzerland
+41 44 724 8605

-----Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote: -----

>To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
>Date: 01/03/2018 06:37PM
>Cc: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Subject: Re: [PATCH v2 03/13] Attach/detach SoftiWarp to/from network
>and RDMA subsystem
>
>On Wed, Jan 03, 2018 at 07:31:05PM +0200, Leon Romanovsky wrote:
>> On Wed, Jan 03, 2018 at 08:52:25AM -0700, Jason Gunthorpe wrote:
>> > On Wed, Jan 03, 2018 at 07:25:29AM +0200, Leon Romanovsky wrote:
>> > > On Tue, Jan 02, 2018 at 02:37:06PM -0700, Jason Gunthorpe wrote:
>> > > > On Fri, Dec 22, 2017 at 11:29:38AM +0000, Bernard Metzler wrote:
>> > > >
>> > > > > One question I have - what is the recommended way of replacing
>> > > > > those module parameters, if we need to flexibly parameterize
>> > > > > things from user land? For the rxe driver, I see the usage of
>> > > > > module_param_cb, but this probably is not what we want in the
>> > > > > long run? Would a sysctl be appropriate, or a char device
>> > > > > (we may need to pass strings like interface names), or configfs?
>> > > >
>> > > > Probably something like 'rdmatool interface attach' eg cause it to
>> > > > create using the RDMA netlink protocol.
>> > > >
>> > > > Leon?
>> > >
>> > >
>https://urldefense.proofpoint.com/v2/url?u=https-3A__www.spinics.net_
>lists_linux-2Drdma_msg58498.html&d=DwIBAg&c=jf_iaSHvJObTbx-siA1ZOg&r=
>2TaYXQ0T-r8ZO1PP1alNwU_QJcRRLfmYTAgd3QCvqSc&m=j_ugxX4CwKK5qXMrL9qUL22
>vuEuR-QuZGL2SYI0U6zA&s=CutkYdjJcUPYU6HSJPpcszcnDWodIOZOUIjpochezeU&e=
>> > > "It looks like "ip" tool can be good fit ..."
>> > >
>> > > ip link add ...
>> > > ip link set ...
>> >
>> > ip link adds netdevs, so that doesn't quite feel right for adding rdma
>> > devices???
>> 
>> It depends on the add/delete order, currently we are adding
>> RDMA (RXE/SoftiWARP) device to existing netdev.
>
>> Will it make sense to reverse order and add/delete netdev device for
>> the existing RDMA (RXE/SoftiWARP) device?
>
> No.
>
> Jason
>

What about potentially enabling it on all interfaces which are used
by TCP? iWarp is an ULP to TCP... Exceptions might be interfaces which
implement their own RDMA protocol - like iWARP adapters, or IPoIB
devices, or interfaces which already have a use from SoftRoCE.

Thanks,
Bernard.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
