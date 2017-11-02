From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] cbuild: Add udev dependency to package list
 of SuSE Leap
Date: Thu, 2 Nov 2017 18:32:09 +0100
Message-ID: <3a06c93f-aa0f-93fa-1b74-af6388051f89@suse.de>
References: <20171102165556.22105-1-leon@kernel.org>
 <20171102165556.22105-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102165556.22105-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Leon, Jason, is there any news on switching the upstream validation to build/validate for all distrib instead of just the "travis" one ?

Nicolas

Le 02/11/2017 à 17:55, Leon Romanovsky a écrit :
> From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> rpmbuild under SUSE requires udev and produces the following errors:
>
> error: Failed build dependencies:
>         pkgconfig(udev) is needed by rdma-core-16-0.x86_64
>
> Signed-off-by: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  buildlib/cbuild | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/buildlib/cbuild b/buildlib/cbuild
> index 918bf233..d1455b6f 100755
> --- a/buildlib/cbuild
> +++ b/buildlib/cbuild
> @@ -298,6 +298,7 @@ class leap(ZypperEnvironment):
>          'cmake',
>          'gcc',
>          'libnl3-devel',
> +        'udev',
>          'libudev-devel',
>          'make',
>          'ninja',
> --
> 2.14.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
