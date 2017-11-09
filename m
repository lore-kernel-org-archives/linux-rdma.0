From: "Bernard Metzler" <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH v2 03/13] Attach/detach SoftiWarp to/from network and RDMA
 subsystem
Date: Thu, 9 Nov 2017 14:43:41 +0000
Message-ID: <OFCB0BDB52.EB9864CE-ON002581D3.004282CC-002581D3.0050E7A2@notes.na.collabserv.com>
References: <20171109084610.GB18825@mtr-leonro.local>,<20171008130342.GV25829@mtr-leonro.local>
 <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-4-bmt@zurich.ibm.com>
 <OF14995472.9A0A4CF8-ON002581D2.005950C6-002581D2.005C2475@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171109084610.GB18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


-----Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote: -----

>To: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
>From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>Date: 11/09/2017 09:52AM
>Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Subject: Re: [PATCH v2 03/13] Attach/detach SoftiWarp to/from network
>and RDMA subsystem
>
>On Wed, Nov 08, 2017 at 04:46:26PM +0000, Bernard Metzler wrote:
>> -----Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote: -----
>>
>> >> + */
>> >> +static __init int siw_init_module(void)
>> >> +{
>> >> +	int rv;
>> >> +	int nr_cpu;
>> >> +
>> >> +	if (SENDPAGE_THRESH < SIW_MAX_INLINE) {
>> >> +		pr_info("siw: sendpage threshold too small: %u\n",
>> >> +			(int)SENDPAGE_THRESH);
>> >> +		rv = EINVAL;
>> >> +		goto out;
>> >> +	}
>> >> +	/*
>> >> +	 * The xprtrdma module needs at least some rudimentary bus to
>set
>> >> +	 * some devices path MTU.
>> >> +	 */
>> >> +	rv = bus_register(&siw_bus);
>> >
>> >bus register for the driver? no way.
>>
>> I admit - this looks ugly. And the comment above is incomplete.
>> I did this mainly to allow siw to register with loopback devices.
>> During device registration, we need to present a real parent
>device:
>> device_add() needs it, as called by ib_device_register_sysfs().
>> The loopback device does not have a parent device, nor dma_ops.
>> The dma_ops can be satisfied by global dma_virt_ops. But I did not
>> find a similar 'virtual parent device' I could present during
>registration.
>> So I 'invented' that one.
>>
>> I see no other way yet than dropping loopback device support, if
>this
>> approach is not acceptable. But, we found it nice to have, since
>performance
>> for the loopback case improved significantly.
>>
>> Any suggestion on how to enable loopback support (referencing
>127.0.0.x
>> addresses during connection management) in a more elegant way would
>> be highly appreciated....
>>
>
>RXE solved it by relying on loopback from netdevice, see
>rxe_dma_device call
>in rxe_register_device.
>
>Will it work for SIW?
>
>Thanks
>

Right...this is basically what siw can do as well for all
other devices it attaches to. But it will not work for the
real loopback device (addr 127.0.0.1 and friends), since that
device does not come with a parent device it belongs
to. Loopback seem to be kind of a 'top level' device.

rxe_dma_device() returns netdev->dev.parent, which is
NULL for loopback. So there is probably currently no support
for lo devices within rxe.

I'll take the loopback devices itself as the parent device.
That seem to work. I'd suggest that for rxe as well.

Thank you!

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
