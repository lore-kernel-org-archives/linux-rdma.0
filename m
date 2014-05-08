From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ANNOUNCE] libmlx4 1.0.6 is released
Date: Thu, 08 May 2014 17:48:16 +0300
Message-ID: <536B9930.9000701@dev.mellanox.co.il>
References: <1399507582-23912-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1399507582-23912-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/8/2014 3:06 AM, Roland Dreier wrote:
> libmlx4 is a library that allows programs to use RDMA "verbs" for
> direct access to RDMA (currently InfiniBand and iWARP) hardware from
> userspace.
>
> The new stable release, 1.0.6, is available from
>
>      http://www.openfabrics.org/downloads/mlx4/libmlx4-1.0.6.tar.gz
>
> with sha1sum
>
>      ee22cc20f537b5e794465682d97e5ad0647d9464  libmlx4-1.0.6.tar.gz
>
> I also pushed the latest tree and tag out to kernel.org:
>
>      git://git.kernel.org/pub/scm/libs/infiniband/libmlx4.git
>
> (the name of the tag is libmlx4-1.0.6).
>
> The main new features in this release are: generic infrastructure for
> "verbs extensions", support for XRC, and support for flow steering.
> This release requires libiverbs >=3D 1.1.8 to build.
>
> This will be my last release of libmlx4; I am turning maintenance of
> the library over to Mellanox.

   Thanks Roland, I=92m taking the responsibility from Mellanox side on=
 libmlx4, hope to have a good cooperation with you.
   My GIT tree to be used: git://openfabrics.org/~yishaih/libmlx4.git

>
> The git shortlog since libmlx4 1.0.5 is:
>
> Matan Barak (1):
>        Add receive flow steering support
>
> Roland Dreier (5):
>        resize_cq: Fix possible endless loop scanning CQ
>        Remove compatibility with libibverbs < 1.1.7
>        Use dh-autoreconf to fix build on ppc64el
>        Enable subdir-objects for automake
>        Roll libmlx4 1.0.6 release
>
> Sean Hefty (1):
>        Add support for XRC QPs
>
> Yishai Hadas (1):
>        Update to use libiverbs extension support / verbs_register_dri=
ver()
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
