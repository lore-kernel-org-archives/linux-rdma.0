From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 00/16] ib_mad: Add support for Intel Omni-Path
 Architecture (OPA) MAD processing.
Date: Wed, 19 Nov 2014 00:16:12 +0200
Message-ID: <CAJ3xEMhtm99dRdcEvhK9s961mDr7YSU3pkv-WK=sESKe_K4kYw@mail.gmail.com>
References: <1415908465-24392-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415908465-24392-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 13, 2014 at 9:54 PM,  <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> The following patch series modifies the kernel MAD processing (ib_mad/ib_umad)
> and related interfaces to process Intel Omni-Path Architecture MADs on devices
> which support them.

So this series allows to process such mad when it arrives or goes
beyond that and allows to send such mad too?

> In addition to supporting some IBTA management classes, OPA devices use MADs
> with lengths up to 2K.  These "jumbo" MADs increase the performance of
> management traffic.

Can you provide 1-2 use cases where such mads will be sent and by what
entity? I recall 2KB mads were mentioned over our LWG talks 8 years
ago on IB routers...

> To distinguish IBTA MADs from OPA MADs a new Base Version is introduced.  The
> new format shares the same common header with IBTA MADs which allows us to
> share most of the MAD processing code when dealing with the new Base Version.
>
>
> The patch series is broken into 3 main areas.
>
> 1) Add the ability for devices to indicate "jumbo" MAD support.  In addition,
>    modify the ib_mad module to detect those devices and allocate the resources
>    for the QPs on those devices.
>
> 2) Enhance the interface to the device agents to support larger and variable
>    length MADs.
>
> 3) Add support for creating and processing OPA Base Version MADs including
>    a new SMP class version specific to OPA devices.
>
>
>   [RFC PATCH 01/16] ib/mad: rename is_data_mad to is_rmpp_data_mad
>   [RFC PATCH 02/16] ib/core: add IB_DEVICE_JUMBO_MAD_SUPPORT device cap
>   [RFC PATCH 03/16] ib/mad: Add check for jumbo MADs support on a device
>   [RFC PATCH 04/16] ib/mad: add base version parameter to
>   [RFC PATCH 05/16] ib/mad: Add MAD size parameters to process_mad
>   [RFC PATCH 06/16] ib/mad: Create jumbo_mad data structures
>   [RFC PATCH 07/16] ib/mad: create a jumbo MAD kmem_cache

why not use a single kmem-cache instance with a non hard coded element
size, 256B (or whatever we use today) or 2KB?

Also (nit), please change the prefix for all patches to be IB/mad: and
not ib/mad: to comply with the existing habit of patch titles for the
IB subsystem

And (another nit), generate patch 0/N using

$ git format-patch --cover-letter

so we have the exact subject line for each patch and the over-all
diffstat in the cover-letter

>   [RFC PATCH 08/16] ib/mad: Add Intel Omni-Path Architecture defines
>   [RFC PATCH 09/16] ib/mad: Implement support for Intel Omni-Path
>   [RFC PATCH 10/16] ib/mad: Add registration check for Intel Omni-Path
>   [RFC PATCH 11/16] ib/mad: create helper function for
>   [RFC PATCH 12/16] ib/mad: create helper function for
>   [RFC PATCH 13/16] ib/mad: create helper function for
>   [RFC PATCH 14/16] ib/mad: Create helper function for SMI processing
>   [RFC PATCH 15/16] ib/mad: Implement Intel Omni-Path Architecture SMP
>   [RFC PATCH 16/16] ib/mad: Implement Intel Omni-Path Architecture General
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
