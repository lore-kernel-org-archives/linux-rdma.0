From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3 for-next 02/33] IB/core: Add kref to IB devices
Date: Fri, 1 May 2015 09:34:24 +0300
Message-ID: <CAAKD3BCJbUAMYhBzwuQFct=cRSXnGC=ELzNkvw2X04a4UipQwQ@mail.gmail.com>
References: <9f65de5e-ed5f-48d2-bff2-03ffbe4f4876@CMEXHTCAS2.ad.emulex.com>
	<CAJ3xEMhBNt-VNNds37sXnJi3nP9ZTMd6mC3s+qZWh0XsO1n_Nw@mail.gmail.com>
	<553DF294.4070507@mellanox.com>
	<CAJ3xEMjzgS_uR1VaeGzW+jcfG2oiVo4=fCctX6o4OVbKRX2n0Q@mail.gmail.com>
	<553F931F.6000302@mellanox.com>
	<20150428174312.GB5497@obsidianresearch.com>
	<5540F8F4.5010906@dev.mellanox.co.il>
	<20150429164847.GA12781@obsidianresearch.com>
	<5541E5ED.7000606@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A82373A8FC929B@ORSMSX109.amr.corp.intel.com>
	<20150430175252.GB32666@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150430175252.GB32666-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 30, 2015 at 8:52 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Thu, Apr 30, 2015 at 04:56:13PM +0000, Hefty, Sean wrote:
>
>> I still don't even buy that a cache is needed at all.  The RDMA CM
>> can accept as input UDP/IP addresses.  RoCEv2 puts UDP/IP addresses
>> on the wire.  Why should there be a conversion from an IP address to
>> a GID to get back to the same IP address?  Why aren't IP addresses
>> passed directly to the drivers?  Just change how the RDMA CM
>> associates an IP address with the RDMA device.
>
> I feel it looks overdesigned too..
>
> But, how could RDMA CM work? Inbound CM messages will be filtered if
> the IP is not in the HW GID table? How could UD work?
>
> This current scheme is just so ugly, there are so many wonky
> possibilities. What happens if I remove an IP and then add a new one?
> The GID index will eventually be re-used, and QPs bound to that gid
> index will silently change source IPs. Horrible.

This should be handled by the vendor's driver/other future ib_core part.
This patchset introduces roce_gid_cache that manages the GID table and
notify vendors about GID changes.

The vendor needs to:
(a) Move all QPs that use GID x to error state when GID x is deleted from
      the table.
(b) Change all QPs that use GID x to use a special invalid GID entry.
(c) Don't delete GIDs that are being used by a QP.

>
> Jason

Matan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
