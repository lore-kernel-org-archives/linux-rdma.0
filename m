From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/3] Fixes and package improvement to Travis CI
Date: Mon, 13 Nov 2017 10:55:15 +0100
Message-ID: <65be5c4f-0127-78c7-db0c-f54c22884902@suse.de>
References: <20171113060806.27354-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171113060806.27354-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Le 13/11/2017 à 07:08, Leon Romanovsky a écrit :
> Hi,
>
> This patchset comes from Alaa, who fixed two issues discovered during
> his work to enable checks of distribution packages in Travis CI.
> These fixes allowed us to add Ubuntu Artful to the list of checked
> distributions.
>
> PR can be found at:
> https://github.com/linux-rdma/rdma-core/pull/248
>
> Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Cc: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
>
> Thanks
>
> Alaa Hleihel (3):
>   Fix compilation warnings when NDEBUG is set
>   util/mmio.c: Fix compilation errors when __SSE__ is not set on 32 bit
>   travis: Test Debian packaging under artful container
>
>  .travis.yml                 |  6 ------
>  buildlib/cbuild             |  7 +++++++
>  buildlib/package-build-test |  2 +-
>  buildlib/travis-build       | 16 +---------------
>  libibverbs/neigh.c          |  2 +-
>  librdmacm/rsocket.c         |  4 ++--
>  util/mmio.c                 |  4 ++--
>  7 files changed, 14 insertions(+), 27 deletions(-)
>
> --
> 2.15.0
>

For the series:
Reviewed-by: Nicolas Morey-Chaisemartin <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
