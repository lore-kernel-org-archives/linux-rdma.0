From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] rdma-core: Add missing systemd-devel dependency to the
 SUSE rdma-core.spec
Date: Thu, 7 Dec 2017 11:16:20 +0100
Message-ID: <d47ea839-09dd-df5c-871d-43162f4b18aa@suse.de>
References: <20171205234005.10904-1-tatyana.e.nikolova@intel.com>
 <024a3b6a-2f04-36ee-5d4f-51f9e8cb719e@suse.de>
 <20171206171349.GF29197@mellanox.com>
 <c6d617e2-a531-b159-c67a-ddd9179ff424@suse.de>
 <20171206172731.GA3564@mellanox.com>
 <13AA599688F47243B14FCFCCC2C803BB3C65CD63@fmsmsx104.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <13AA599688F47243B14FCFCCC2C803BB3C65CD63-96pTJSsuoYQ64kNsxIetb7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Le 06/12/2017 à 23:06, Nikolova, Tatyana E a écrit :
>
>
> The patch was prompted when the rdma-core daemons were unable to start on a SLES12SP2 system, because the shim version of the systemd functions were used instead. Unfortunately I don't have the details on how rdma-core was installed on this system.

If you don't mind me asking, why are you trying to do this on SLE12SP2 ?
SP2 is using now ancient libraries from OFEd (pre rdma-core).
Even it compiled right for SP2, I have very strong doubt about the system being fully working unless you recompile all IB related RPMs...

I strongly advise doing this from a SLE12SP3 which uses rdma-core v14.
>
> Checking the current SUSE spec file on the same system (without systemd-devel installed), it indeed detects a missing dependency:
> "error: Failed build dependencies: pkgconfig(libsystemd) is needed by rdma-core-15-0.x86_64"
>
> However libsystemd packages (libsystemd0-228-117.12.x86_64 and libsystemd0-32bit-228-117.12.x86_64) are installed on this system, but systemd-devel is necessary to install the required headers, for example "sd-daemon.h" needed by the daemons. 
>
> Maybe it would be better to replace pkgconfig(libsystemd) with pkgconfig(systemd-devel) in the spec file, since systemd-devel requires libsystemd?


Coud you try with this instead of your patch:
diff --git a/suse/rdma-core.spec b/suse/rdma-core.spec
index 5be0e1e8..fa41b724 100644
--- a/suse/rdma-core.spec
+++ b/suse/rdma-core.spec
@@ -54,7 +54,8 @@ BuildRequires:  binutils
 BuildRequires:  cmake >= 2.8.11
 BuildRequires:  gcc
 BuildRequires:  pkgconfig
-BuildRequires:  pkgconfig(libsystemd)
+BuildRequires:  pkgconfig(libsystemd-daemon)
+BuildRequires:  pkgconfig(libsystemd-journal)
 BuildRequires:  pkgconfig(libudev)
 BuildRequires:  pkgconfig(systemd)
 BuildRequires:  pkgconfig(udev)

Nicolas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
