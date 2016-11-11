From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: some question for help
Date: Fri, 11 Nov 2016 14:47:05 +0200
Message-ID: <20161111124705.GH28957@leon.nu>
References: <582569DF.5030909@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ewQ5hdP4CtoTt3oD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <582569DF.5030909-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ewQ5hdP4CtoTt3oD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 11, 2016 at 02:49:03PM +0800, oulijun wrote:
> Hi, Jason & leon.
>   I have a question for rdma-core building.
>   Today, I use cross-build tool for rdma-core in the latest rdma-core version and it is fail.
>
> The log as follows:
> ubuntu@62fe1357a077:~/rdma_core_origin/rdma-core/build$ CC=aarch64-linux-gnu-gcc cmake  -DENABLE_RESOLVE_NEIGH=0 ..
> CMake Error at /usr/share/cmake-2.8/Modules/CMakeDetermineCCompiler.cmake:56 (message):
>   Could not find compiler set in environment variable CC:
>
>   aarch64-linux-gnu-gcc.

Do you have this compiler in your PATH?


> Call Stack (most recent call first):
>   CMakeLists.txt:26 (project)
>
>
> CMake Error: Error required internal CMake variable not set, cmake may be not be built correctly.
> Missing variable is:
> CMAKE_C_COMPILER_ENV_VAR
> CMake Error: Error required internal CMake variable not set, cmake may be not be built correctly.
> Missing variable is:
> CMAKE_C_COMPILER
> CMake Error: Could not find cmake module file: /home/ubuntu/rdma_core_origin/rdma-core/build/CMakeFiles/2.8.12.2/CMakeCCompiler.cmake
> CMake Error: CMAKE_C_COMPILER not set, after EnableLanguage
> -- Configuring incomplete, errors occurred!
>
>
> ubuntu@62fe1357a077:~/rdma_core_origin/rdma-core/build$ CC=aarch64-linux-gnu-gcc cmake -Gninja -DENABLE_RESOLVE_NEIGH=0 ..
> CMake Error: Could not create named generator ninja
>
> and if use the default script build.sh, it is ok
> ubuntu@62fe1357a077:~/rdma_core_origin/rdma-core$ export CC=gcc
> ubuntu@62fe1357a077:~/rdma_core_origin/rdma-core$ ./build.sh
> -- The C compiler identification is GNU 4.8.4
> -- Check for working C compiler using: Ninja
> -- Check for working C compiler using: Ninja -- works
> -- Detecting C compiler ABI info
> -- Detecting C compiler ABI info - done
> -- Found PkgConfig: /usr/bin/pkg-config (found version "0.26")
> -- Performing Test SUPPORTS_GNU99
> -- Performing Test SUPPORTS_GNU99 - Success
> -- Performing Test HAVE_C_WARNINGS
> -- Performing Test HAVE_C_WARNINGS - Success
> -- Performing Test HAVE_C_WMISSING_PROTOTYPES
> -- Performing Test HAVE_C_WMISSING_PROTOTYPES - Success
> -- Performing Test HAVE_C_WMISSING_DECLARATIONS
> -- Performing Test HAVE_C_WMISSING_DECLARATIONS - Success
> -- Performing Test HAVE_C_WWRITE_STRINGS
> -- Performing Test HAVE_C_WWRITE_STRINGS - Success
> -- Performing Test HAVE_C_WFORMAT_2
> -- Performing Test HAVE_C_WFORMAT_2 - Success
> -- Performing Test HAVE_C_WORKING_SHADOW
> -- Performing Test HAVE_C_WORKING_SHADOW - Success
> -- Performing Test HAVE_C_WORKING_MISSING_FIELD_INITIALIZERS
> -- Performing Test HAVE_C_WORKING_MISSING_FIELD_INITIALIZERS - Failed
> -- Performing Test HAVE_C_WNO_MISSING_FIELD_INITIALIZERS
> -- Performing Test HAVE_C_WNO_MISSING_FIELD_INITIALIZERS - Success
> -- Performing Test HAVE_NO_STRICT_ALIASING
> -- Performing Test HAVE_NO_STRICT_ALIASING - Success
> -- Performing Test HAS_CLOEXEC
> -- Performing Test HAS_CLOEXEC - Success
> -- Performing Test HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE
> -- Performing Test HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE - Success
> -- Performing Test SUPPORTS_AS_NEEDED
> -- Performing Test SUPPORTS_AS_NEEDED - Success
> -- Performing Test SUPPORTS_NO_UNDEFINED
> -- Performing Test SUPPORTS_NO_UNDEFINED - Success
> -- Performing Test _LDSYMVER_SUCCESS
> -- Performing Test _LDSYMVER_SUCCESS - Success
> -- Found LDSymVer: GNU
> -- Looking for include file pthread.h
> -- Looking for include file pthread.h - found
> -- Looking for pthread_create
> -- Looking for pthread_create - not found
> -- Looking for pthread_create in pthreads
> -- Looking for pthread_create in pthreads - not found
> -- Looking for pthread_create in pthread
> -- Looking for pthread_create in pthread - found
> -- Found Threads: TRUE
> -- checking for modules 'libnl-3.0;libnl-route-3.0'
> --   found libnl-3.0, version 3.2.21
> --   found libnl-route-3.0, version 3.2.21
> -- Performing Test HAVE_WORKING_IF_H
> -- Performing Test HAVE_WORKING_IF_H - Failed
> -- Check size of long
> -- Check size of long - done
> -- Performing Test HAVE_RDMA_IB_USER_VERBS_H
> -- Performing Test HAVE_RDMA_IB_USER_VERBS_H - Success
> -- Performing Test HAVE_RDMA_IB_USER_SA_H
> -- Performing Test HAVE_RDMA_IB_USER_SA_H - Success
> -- Performing Test HAVE_RDMA_IB_USER_CM_H
> -- Performing Test HAVE_RDMA_IB_USER_CM_H - Success
> -- Performing Test HAVE_RDMA_IB_USER_MAD_H
> -- Performing Test HAVE_RDMA_IB_USER_MAD_H - Success
> -- Performing Test HAVE_RDMA_RDMA_NETLINK_H
> -- Performing Test HAVE_RDMA_RDMA_NETLINK_H - Failed
> -- Performing Test HAVE_RDMA_RDMA_USER_CM_H
> -- Performing Test HAVE_RDMA_RDMA_USER_CM_H - Success
> -- Performing Test HAVE_RDMA_RDMA_USER_RXE_H
> -- Performing Test HAVE_RDMA_RDMA_USER_RXE_H - Failed
> -- Looking for valgrind/memcheck.h
> -- Looking for valgrind/memcheck.h - found
> -- Looking for valgrind/drd.h
> -- Looking for valgrind/drd.h - found
> -- Performing Test LIBC_HAS_LIBRT
> -- Performing Test LIBC_HAS_LIBRT - Success
> -- Performing Test HAVE_C_WSTRICT_PROTOTYPES
> -- Performing Test HAVE_C_WSTRICT_PROTOTYPES - Success
> -- Performing Test HAVE_C_WOLD_STYLE_DEFINITION
> -- Performing Test HAVE_C_WOLD_STYLE_DEFINITION - Success
> -- Performing Test HAVE_C_WREDUNDANT_DECLS
> -- Performing Test HAVE_C_WREDUNDANT_DECLS - Failed
> -- Missing Optional Items:
> --  netlink/route/link.h and net/if.h NOT co-includable (old headers)
> --  rdma/rdma_netlink.h NOT found (old system kernel headers)
> --  rdma/rdma_user_rxe.h NOT found (old system kernel headers)
> --  -Wmissing-field-initializers does NOT work
> --  -Wredundant-decls does NOT work
> -- Configuring done
> -- Generating done
> -- Build files have been written to: /home/ubuntu/rdma_core_origin/rdma-core/build
> [167/167] Linking C shared module lib/libibacmp.so
>
> But, the two build way to build the previous rdma-core version(patchv1/patchv2/patchv3) is ok.
> they use the same environment.
>
> Did The build evironment have changed?

I don't think so, but you can always git bisect to be sure.

>
> Lijun Ou
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--ewQ5hdP4CtoTt3oD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYJb3JAAoJEORje4g2clininsP/A8zoszVx/b3+GHxBOCea7GP
RnxV7RqON2BFiEzYwu6SrjQxMzNZQXg5OHwS84HHwRexsdvAXyHdbKSthK5dC74X
Pr6VYjCr2s6JlH6X6GBf3O/yFSnsQDB5ql0Hz/D0VRWtdEF90goYo+LZRFtbJnq0
orsCwaYUz3C+bpbFEX98B5YmYEA6ktYoaaOqzd2YoCTeFOk96Tupzb6MbV5er94Y
5NP0ujWT0RvuoqKO0PtzsM3pdtBBxd7wawbEJJGTPcBzqBBu9wnDCoXyvFdOfn5M
QJNkhqCbiC7FUIp+BQcMUXHGz7wDYWs/hwgnOVWWMRIxhX9Phb9Y0hIXTkFNOE3S
1GReTvnjHrArYHiWJauoCdp6BSYoJJQoLksxqvzFBg3Rw7c7WZZDC7q6oDLOORIK
gzqq7b+WWihg2e/s9Xk9Wx+tyadGCcKr8/2zUR/WBrjqrbh058X//SPYZ1Rn/JuH
Q4wCc+ZByEJLSj0gykGP2fMP5E16aaWzAgJKyxpQmcUv5M4DolJjjdVK3ME51CA2
NzLWW5+LH2cnWysLX7SHkfrSeQgqvVvictLoET3OWJ/RPVa9Yp8umDZ9LmIxcz0E
kor9JeA2uYGTLsFALb8qcY1MynXk67m6OXHmioweIK68EWGotDtlS9kAEodVNVyy
PK3Dv9bfJCqSeLt5iDIU
=KjzN
-----END PGP SIGNATURE-----

--ewQ5hdP4CtoTt3oD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
