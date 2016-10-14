From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [bug] build the user-space stack code in github is fail on ubuntu
Date: Fri, 14 Oct 2016 14:56:07 +0300
Message-ID: <20161014115607.GH9282@leon.nu>
References: <5800A467.2020602@huawei.com>
 <5800A835.5020207@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ixDdryD3ui8aoCe5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5800A835.5020207-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ixDdryD3ui8aoCe5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 14, 2016 at 05:41:09PM +0800, oulijun wrote:
> Sorry, it is my careless.
>
>  it is fail for building rdma-core branch.
>  build environment: ubuntu
>
>  is the user-space stack in github not support to ubuntu?
>
> when use cmake build, the bug is as follows:
> ubuntu@62fe1357a077:~/rdma_core/rdma-core/build_1$ cmake ..
> -- Found PkgConfig: /usr/bin/pkg-config (found version "0.26")
> -- checking for modules 'libnl-3.0;libnl-route-3.0'
> --   found libnl-3.0, version 3.2.21
> --   found libnl-route-3.0, version 3.2.21
> -- Check size of long
> -- Check size of long - done
> -- Looking for rdma/rdma_user_rxe.h
> -- Looking for rdma/rdma_user_rxe.h - not found
> -- Looking for valgrind/memcheck.h
> -- Looking for valgrind/memcheck.h - found
> -- Looking for valgrind/drd.h
> -- Looking for valgrind/drd.h - found
> -- Performing Test LIBC_HAS_LIBRT
> -- Performing Test LIBC_HAS_LIBRT - Success
> -- Missing Optional Items:
> --  rdma/rdma_user_rxe.h NOT found (old system kernel headers)
> --  -Wmissing-field-initializers does NOT work
> -- Configuring done
> -- Generating done
> -- Build files have been written to: /home/ubuntu/rdma_core/rdma-core/build_1
>
>  but if i directly use the build.sh, the log as fllows:
>  -- The C compiler identification is GNU 4.8.4
>  -- Check for working C compiler using: Ninja
>  -- Check for working C compiler using: Ninja -- broken
>  CMake Error at /usr/share/cmake-2.8/Modules/CMakeTestCCompiler.cmake:61 (message):
>    The C compiler "/usr/bin/cc" is not able to compile a simple test program.
>
>    It fails with the following output:
>
>     Change Dir: /home/ubuntu/rdma_core/rdma-core/build/CMakeFiles/CMakeTmp
>
>
>
>    Run Build Command:/usr/sbin/ninja cmTryCompileExec2838577708
>
>    log: reading configuration file: cmTryCompileExec2838577708
>
>
>
>    die: error: unable to read configuration file
>
>
>
>    CMake will not be able to correctly generate this project.
>  Call Stack (most recent call first):
>    CMakeLists.txt:24 (project)
>
>
>  -- Configuring incomplete, errors occurred!

According to error log, you didn't install ninja build system.
sudo apt-get install ninja-build

--ixDdryD3ui8aoCe5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYAMfXAAoJEORje4g2clinFWsQAMvA4+Bo9D9tR/kbGWig5sV/
wl1IUQ31z2r+pbKsQTp4uRrZ0Tc5Ve9KS5X33AQzLiAFvLkd2zLhS9Gno3JL6grz
VRjxok0bPimXYaqHmFT0VOs2oxdrvDG+gFGsT6ZGNYsjzlWjp9cfxbpBPU+DmdZx
o3ISKRa4m/8dnfqWFykTfhSOTGRxLG7Deg+JWczDRfavhCLJtZHkqy0fKXjfWfoS
gMr74rPZ+BPz0YN73uKtj0GrD7M7vPEL0wIWxQOuNG97A9NQeGjmKyQ2p0Wc0IXL
aW4VTmY7FRbVzCO7E1NPaf4QTFY9COYei9OGMsoI4UdSd5x+e9uC3TlTpD0ZXAlX
e58trhRLXh7RmOzhj1w/CJ4VUnFNDlzU45jZUOpSGK8Z4t7rGWp4w+h0/Y8lPfXU
J7v8IsaIifVvKrhPtrG9hsR4c5sRwqsqLXET01Hm+Mn/Y2QPuSt6Ptt0sx7SvrS4
W08JXLsNYkbfQlMdfe+gBEKO/8jEi8bugRU45kgrryO5ZlHFFNWk+jEEGWjSjoQC
WY20/SlocSW5XsTf1Ktc7diYi92NtVvHpY5ztbcSTVbsNeZnrseUFLvswhM/iOfD
PduuVW8sJXkXKnTIpA9wPvW66GfkM37fpfb3+Rs5nRaK3UvA+8/YR57ekX8V3Svx
y64NHic17cgTzFPenO/i
=VT5y
-----END PGP SIGNATURE-----

--ixDdryD3ui8aoCe5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
