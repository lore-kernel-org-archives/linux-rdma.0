From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] rdma-core: Add missing systemd-devel dependency to the
 SUSE rdma-core.spec
Date: Wed, 6 Dec 2017 15:28:14 -0700
Message-ID: <20171206222814.GD3564@mellanox.com>
References: <20171205234005.10904-1-tatyana.e.nikolova@intel.com>
 <024a3b6a-2f04-36ee-5d4f-51f9e8cb719e@suse.de>
 <20171206171349.GF29197@mellanox.com>
 <c6d617e2-a531-b159-c67a-ddd9179ff424@suse.de>
 <20171206172731.GA3564@mellanox.com>
 <13AA599688F47243B14FCFCCC2C803BB3C65CD63@fmsmsx104.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <13AA599688F47243B14FCFCCC2C803BB3C65CD63-96pTJSsuoYQ64kNsxIetb7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 06, 2017 at 10:06:57PM +0000, Nikolova, Tatyana E wrote:

> The patch was prompted when the rdma-core daemons were unable to
> start on a SLES12SP2 system, because the shim version of the systemd
> functions were used instead. Unfortunately I don't have the details
> on how rdma-core was installed on this system.

Well, are you even sure it was built with rpmbuild?

> Checking the current SUSE spec file on the same system (without
> systemd-devel installed), it indeed detects a missing dependency:
> "error: Failed build dependencies: pkgconfig(libsystemd) is needed
> by rdma-core-15-0.x86_64"

Because rpmbuild shouldn't have succeeded, right?

> However libsystemd packages (libsystemd0-228-117.12.x86_64 and
> libsystemd0-32bit-228-117.12.x86_64) are installed on this system,
> but systemd-devel is necessary to install the required headers, for
> example "sd-daemon.h" needed by the daemons.

Yes, that is right. But pkgconfig(XXX) is a magic notation to 'bring
in -devel packages for XXX'

So pkgconfig(libsystemd) is supposed to bring in systemd-devel, for
instance.

You'd need to reproduce a failing rpmbuild where the deps are met and
the shims are used to understand this issue..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
