From: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] rdma-core: Add missing systemd-devel dependency to the
 SUSE rdma-core.spec
Date: Wed, 6 Dec 2017 22:06:57 +0000
Message-ID: <13AA599688F47243B14FCFCCC2C803BB3C65CD63@fmsmsx104.amr.corp.intel.com>
References: <20171205234005.10904-1-tatyana.e.nikolova@intel.com>
 <024a3b6a-2f04-36ee-5d4f-51f9e8cb719e@suse.de>
 <20171206171349.GF29197@mellanox.com>
 <c6d617e2-a531-b159-c67a-ddd9179ff424@suse.de>
 <20171206172731.GA3564@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171206172731.GA3564-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
> Sent: Wednesday, December 06, 2017 11:28 AM
> To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
> Cc: Nikolova, Tatyana E <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>;
> dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> Subject: Re: [PATCH] rdma-core: Add missing systemd-devel dependency to
> the SUSE rdma-core.spec
> 
> On Wed, Dec 06, 2017 at 06:24:20PM +0100, Nicolas Morey-Chaisemartin
> wrote:
> 
> > > This is does something else and isn't needed, AFAIK:
> > >
> > >   BuildRequires:  pkgconfig(systemd)
> >
> > This was requested by the main OpenSUSE maintainer so I blindly
> > trusted him with this :) I'll still ask him if both are really needed
> > (and if yes, what's the diff)
> 
> I would anticipate this is the reason:
> 
>   Our build systems checks that scriptlets call existing binaries.
>   Without udev, udevadm does not exists which gets some errors in the
>   build logs.
> 
> As we also call systemd binaries in various places.
> 
> > Tatyana, could you give some more info on what prompted this patch ?
> 
> +1
> 
The patch was prompted when the rdma-core daemons were unable to start on a SLES12SP2 system, because the shim version of the systemd functions were used instead. Unfortunately I don't have the details on how rdma-core was installed on this system.

Checking the current SUSE spec file on the same system (without systemd-devel installed), it indeed detects a missing dependency:
"error: Failed build dependencies: pkgconfig(libsystemd) is needed by rdma-core-15-0.x86_64"

However libsystemd packages (libsystemd0-228-117.12.x86_64 and libsystemd0-32bit-228-117.12.x86_64) are installed on this system, but systemd-devel is necessary to install the required headers, for example "sd-daemon.h" needed by the daemons. 

Maybe it would be better to replace pkgconfig(libsystemd) with pkgconfig(systemd-devel) in the spec file, since systemd-devel requires libsystemd?

Thank you,
Tatyana


> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
