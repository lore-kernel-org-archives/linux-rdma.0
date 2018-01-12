From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Building rdma-core from github gave an error "Unknown arguments
 specified"
Date: Fri, 12 Jan 2018 13:56:40 +0200
Message-ID: <20180112115640.GM15760@mtr-leonro.local>
References: <CAGXs5wUoLZLtmHhyRm3poALO5ZGSdS5u4+saKhigMgHivw-9Eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KaGhPsiNaI6/sRd6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGXs5wUoLZLtmHhyRm3poALO5ZGSdS5u4+saKhigMgHivw-9Eg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--KaGhPsiNaI6/sRd6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 12, 2018 at 11:35:04AM +0200, Kevin Wilson wrote:
> Hi,
> I had cloned the latest rdma-core:
> https://github.com/linux-rdma/rdma-core.git
>
> I am trying to build it on Fedora 27 x86_64 machine.
> When I ran:
> bash build.sh
> I got the following:
>
> CMake Error at buildlib/RDMA_BuildType.cmake:32 (if):
>   if given arguments:
>
>     "STREQUAL" "-O2 -g -DNDEBUG"
>
>   Unknown arguments specified
> Call Stack (most recent call first):
>   CMakeLists.txt:145 (RDMA_BuildType)
>
>
> -- Configuring incomplete, errors occurred!
> See also "/work/down/temp/rdma-core/build/CMakeFiles/CMakeOutput.log".
> See also "/work/down/temp/rdma-core/build/CMakeFiles/CMakeError.log".
>
> Any ideas what can it be ?

Most probably, there is a missing build dependency.
I tested clean fc27 build in container and it worked flawlessly.
https://patchwork.kernel.org/patch/10160339/

Thanks

>
> More details:
> As said, I am on the latest git commit, on the master branch:
> git log | more
> commit c4345781db3d4d24578873b612357124c6b3d1e3
> Author: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Date:   Thu Jan 4 15:27:51 2018 +0100
>
>     debian: Update changelog to include Debian uploads 16.x
>
> Regards,
> KW
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--KaGhPsiNaI6/sRd6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpYongACgkQ5GN7iDZy
WKeF3xAAk2YNNjOfFE/pb+af+TmkzPltoW0TnJpjfsCn7Hvzebrd9B6aHWN+Ev8U
LXHGPtersadaoJiOUBm2VbmsEAZ00oK4xHPmUi/xZwgHSdZHtcH1GOPwaQRVPrcF
Dc6sm7EtWIlAdHakvwkvBNxyPlVwYSnKrxctkbW9Nd4/1rsDj+4ysrA3kFmrW4ng
s/LrsnAOKuSS9GfBcT3rUtR+m0Npo2ZYwVQXU65zEnhj1iFSLG6Y7AnVkhOmMCsx
o+N9E9uQC6RVxLYnFC62BIaUHOE8cQQZQfQ0x0LxDl2I5LMt5eI8tN0O7+GM7Tq4
kZrac39JfsPvltmPapKdsDaiYbh/36vFkXu/jsfWNdjHiNnzNXLuR6wWXihveuHN
CR8bTJJ6+NZjpgVK90nVat68rtCzNiMl5sAYVFm1D2T+BlL7rg9aZAO65IFwIf1a
wmZa7Uy+jwy3ncn1ZZJsP3gFCw3L7RRZmdZmQW8TarZmPxo9HC1W/Axu66XRGT2S
L3FNEJbr+60n8ED/KZPtO1K4gome/s3qaAyoSb6BADecc8juIODIqhFwB6wC5aAd
IEIY0VZ9C1oQ8hm96stl9z+Y2iXiH8vLgyTgTrl6YuvPF5Js0K4NysjbIyjkAitG
INIvTR+ZXzUZQBqLr6ZpqRLEjJGJ40TCCeeqt9mc9qL2lNIPVIA=
=Y/UL
-----END PGP SIGNATURE-----

--KaGhPsiNaI6/sRd6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
