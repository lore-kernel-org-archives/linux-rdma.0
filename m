From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] rdma-core: Add missing systemd-devel dependency to the
 SUSE rdma-core.spec
Date: Wed, 6 Dec 2017 09:00:50 +0100
Message-ID: <024a3b6a-2f04-36ee-5d4f-51f9e8cb719e@suse.de>
References: <20171205234005.10904-1-tatyana.e.nikolova@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171205234005.10904-1-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Le 06/12/2017 à 00:40, Tatyana Nikolova a écrit :
> Without systemd-devel, all rdma-core daemons are using shim version of
> systemd include file (in-turn, shim version of systemd functions)
> causing them to not communicate with systemd.
>
> Add the missing required systemd-devel package to SUSE's rdma-core.spec
> so the correct header file is used and correct functions are linked
> with the daemons.
>
> Fixes: 8854eefa60b5 ("suse: Add spec file for SUSE")
> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  suse/rdma-core.spec | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/suse/rdma-core.spec b/suse/rdma-core.spec
> index 0eba0507..912a77c5 100644
> --- a/suse/rdma-core.spec
> +++ b/suse/rdma-core.spec
> @@ -57,6 +57,7 @@ BuildRequires:  pkgconfig
>  BuildRequires:  pkgconfig(libsystemd)
>  BuildRequires:  pkgconfig(libudev)
>  BuildRequires:  pkgconfig(systemd)
> +BuildRequires:  pkgconfig(systemd-devel)
>  BuildRequires:  pkgconfig(udev)
>  BuildRequires:  python3-base
>  %ifnarch s390 s390x

You should not need that.
This is what this line is for:

 BuildRequires:  pkgconfig(systemd)

We don't expressly name systemd-devel and use the pkgconfig macro to allow building using systemd-mini-devel when needed.

Nicolas

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
