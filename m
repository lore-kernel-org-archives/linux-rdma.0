From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: OFED-4.8, rdma-core, and library paths
Date: Wed, 8 Feb 2017 20:01:04 +0200
Message-ID: <20170208180104.GG6005@mtr-leonro.local>
References: <20170207172752.GA12315@obsidianresearch.com>
 <20170207180642.GQ6005@mtr-leonro.local>
 <20170207181814.GA13368@obsidianresearch.com>
 <20170207183538.GT6005@mtr-leonro.local>
 <20170207184206.GA14102@obsidianresearch.com>
 <20170207194759.GU6005@mtr-leonro.local>
 <20170207201428.GV6005@mtr-leonro.local>
 <20170207205930.GA28922@obsidianresearch.com>
 <20170208063758.GZ6005@mtr-leonro.local>
 <20170208173335.GB30720@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BspSmK1Kkx4+06Ky"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170208173335.GB30720-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, 'Vladimir Sokolovsky' <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--BspSmK1Kkx4+06Ky
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 08, 2017 at 10:33:35AM -0700, Jason Gunthorpe wrote:
> On Wed, Feb 08, 2017 at 08:37:58AM +0200, Leon Romanovsky wrote:
> > On Tue, Feb 07, 2017 at 01:59:30PM -0700, Jason Gunthorpe wrote:
> > > On Tue, Feb 07, 2017 at 10:14:28PM +0200, Leon Romanovsky wrote:
> > >
> > > > > > Compile the library to build/lib/libibverbs-dv-mlx5.so.1.0.13
> > > > > > and setup a symlink build/lib/libmlx5-rdmav2.so -> libibverbs-d=
v-mlx5.so.1.0.13
> > > > >
> > > > > Just as a note, I'm calling it libmlx5 and not libibverbs-dv-mlx5.
> > >
> > > That will clash with the legacy providers, don't recommend it.
> >
> > Is it real scenario? Will these legacy providers co-exists with
> > rdma-core library? I really don't like libibverbs-dv-mlx5 name, it is
> > too long and have feature name in the name.
>
> I'd save having the 'dv' in the name is sort of the point...
>
> The possible issue would be if an app links to this new library and is
> run on an old system with the old type of library - then you'd get a
> really ugly linker error message. It is best to avoid re using library
> names.
>
> That said, the old name is libmlx4-rdmav2.so so it should be OK..
>
> > >     execute_process(COMMAND "${CMAKE_COMMAND}" -E create_symlink
> > >                  "lib${DEST}.so.${VERSION}"
> > > 		 "${BUILD_LIB}/lib${DEST}-rdmav2.so")
> > >
> > > It creates a dangling link until compilation, which is fine..
> >
> > In non-ninja builds, it doesn't create libmlx5-rdmav2.so symlink in
> > build/lib, because libmlx5.so is not created yet. This is why I ended
> > with custom target.
>
> Eh? That doesn't sound right.
>
> > > >   install(FILES "${BUILD_LIB}/lib${DEST}-rdmav2.so" DESTINATION "${=
CMAKE_INSTALL_LIBDIR}")
> > >
> > > This line isn't needed, it is part of the next function
> >
> > Not for build/lib
> >
>
> ? Do not install something calleld lib*-rdmav2.so to /usr/lib/

Thanks for the help, my final version which works correctly for build in pl=
ace, install from
sources and packages for centos6/centos6 is below:

----
# Create a special provider with exported symbols in it
function(rdma_shared_provider DEST VERSION_SCRIPT SOVERSION VERSION)
  # Installed driver file
  file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${DEST}.driver" "driver ${DEST}\n=
")
  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${DEST}.driver" DESTINATION "$=
{CONFIG_DIR}")

  # Uninstalled driver file
  file(MAKE_DIRECTORY "${BUILD_ETC}/libibverbs.d/")
  file(WRITE "${BUILD_ETC}/libibverbs.d/${DEST}.driver" "driver ${BUILD_LIB=
}/lib${DEST}\n")

  # Create a static provider library
  if (ENABLE_STATIC)
    add_library(${DEST} STATIC ${ARGN})
    set_target_properties(${DEST} PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${BU=
ILD_LIB}")
    install(TARGETS ${DEST} DESTINATION "${CMAKE_INSTALL_LIBDIR}")

    list(APPEND RDMA_STATIC_LIBS ${DEST}-rdmav2 ${DEST})
    set(RDMA_STATIC_LIBS "${RDMA_STATIC_LIBS}" CACHE INTERNAL "")
  endif()

  # Create the plugin shared library
  add_library(${DEST} SHARED ${ARGN})
  # Even though these are modules we still want to use Wl,--no-undefined
  set_target_properties(${DEST} PROPERTIES LINK_FLAGS ${CMAKE_SHARED_LINKER=
_FLAGS})
  rdma_set_library_map(${DEST} ${VERSION_SCRIPT})

  target_link_libraries(${DEST} LINK_PRIVATE ${COMMON_LIBS_PIC})
  target_link_libraries(${DEST} LINK_PRIVATE ibverbs)
  target_link_libraries(${DEST} LINK_PRIVATE ${CMAKE_THREAD_LIBS_INIT})
  set_target_properties(${DEST} PROPERTIES
  	SOVERSION ${SOVERSION}
  	VERSION ${VERSION}
  	LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
  add_custom_target(share_link ALL DEPENDS "${DEST}"  COMMAND ${CMAKE_COMMA=
ND} -E create_symlink "lib${DEST}.so.${VERSION}"
	  "${BUILD_LIB}/lib${DEST}-rdmav2.so")
  add_dependencies(share_link ${DEST})

  install(TARGETS ${DEST} DESTINATION "${CMAKE_INSTALL_LIBDIR}")
  execute_process(COMMAND python ${CMAKE_SOURCE_DIR}/buildlib/relpath
    ${CMAKE_INSTALL_LIBDIR}/lib${DEST}.so.${VERSION} ${VERBS_PROVIDER_DIR}
    OUTPUT_VARIABLE DEST_LINK_PATH OUTPUT_STRIP_TRAILING_WHITESPACE)
  rdma_install_symlink("${DEST_LINK_PATH}" "${VERBS_PROVIDER_DIR}/lib${DEST=
}-rdmav2.so")
endfunction()

----
and buildlib/relpath
---
import os
import sys

print(os.path.relpath(sys.argv[1], sys.argv[2]))
---

But I still have issues with DEB package.
It creates absolute (and wrong)  symlink instead of relative one.

build/cbuild pkg jessie
=2E..
DESTDIR=3D/home/leonro/src/debian/tmp ninja -C build-deb install
ninja: Entering directory `build-deb'
[1/2] cd /home/leonro/src/build-deb/providers/mlx5 && /usr/bin/cmake -E cre=
ate_symlink libmlx5.so.1.0.13 /home/leonro/src/build-deb/lib/libmlx5-rdmav2=
=2Eso
[2/2] Install the project...
=2E...

=E2=9E=9C  ls -l  usr/lib/x86_64-linux-gnu/libibverbs
total 364K
drwxr-xr-x 2 leonro leonro 320 Feb  8 17:17 .
drwxr-xr-x 3 leonro leonro 120 Feb  8 17:17 ..
-rw-r--r-- 1 leonro leonro 22K Feb  8 17:13 libcxgb3-rdmav2.so
-rw-r--r-- 1 leonro leonro 30K Feb  8 17:13 libcxgb4-rdmav2.so
-rw-r--r-- 1 leonro leonro 18K Feb  8 17:13 libhfi1verbs-rdmav2.so
-rw-r--r-- 1 leonro leonro 22K Feb  8 17:13 libhns-rdmav2.so
-rw-r--r-- 1 leonro leonro 30K Feb  8 17:13 libi40iw-rdmav2.so
-rw-r--r-- 1 leonro leonro 18K Feb  8 17:13 libipathverbs-rdmav2.so
-rw-r--r-- 1 leonro leonro 46K Feb  8 17:13 libmlx4-rdmav2.so
lrwxrwxrwx 1 leonro leonro  65 Feb  8 17:13 libmlx5-rdmav2.so -> /home/leon=
ro/src/build-deb/lib/x86_64-linux-gnu/libmlx5.so.1.0.13
-rw-r--r-- 1 leonro leonro 34K Feb  8 17:13 libmthca-rdmav2.so
-rw-r--r-- 1 leonro leonro 23K Feb  8 17:13 libnes-rdmav2.so
-rw-r--r-- 1 leonro leonro 26K Feb  8 17:13 libocrdma-rdmav2.so
-rw-r--r-- 1 leonro leonro 34K Feb  8 17:13 libqedr-rdmav2.so
-rw-r--r-- 1 leonro leonro 18K Feb  8 17:13 librxe-rdmav2.so
-rw-r--r-- 1 leonro leonro 18K Feb  8 17:13 libvmw_pvrdma-rdmav2.so

Any pointer what should I need to fix in debian/ to make it work?

Thanks

>
> Jason

--BspSmK1Kkx4+06Ky
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlibXN8ACgkQ5GN7iDZy
WKdqJw/9GLhPo3oG9XpmsjsFHmtpPVos7x1NmF0W9bY202TJG8UJSf15FfuOQ7ID
Xz41SMwuiztDvfX+BLCahQZOCEGKDaHtVQId1p1euGsQUQEhEsKuVQHoaXwiFMRp
sbZF+5qJXTqLrpXL49Ny1MgFwkUp4pzRVAmyu8d0QOG9R4BDQosPLRJ6H3uyCcyQ
XWb5Uqx8LBpTMf2UTMuz6SHVseD7rqTZERp9ljkYdTENB+/CtJJOxsM1BLB+R8tA
o6fRY/hJWiVOua+DSrDDPAh2BBk9wWU23x+wmfgS5FfwyAdExKIT7FZImOkH/iPY
biRoGMuh/fJPixBx6ok1TqZXznV7P415AThyqXL7IqEU2YlpOBJXkjbvs0LBks9H
lDBntzdYBBy6Gc1k4ALzoh3hg7MYpDs9RYToyD47nKu4GFcbuVk9zbr8yB2RzyOX
PArTEQ93Ej6Qo7ouQcxh7R6dkZTAIHybrHHww2cNwqID32G1ndFJf5hUfWwcopcD
iQV2SgxdeY0AWCpc1KbBMvd6PBYEcYqkdtHTHvaIxK+sP0nHvXMQAtPAC1bsbyUQ
WtYE5u+TLhH7UsiOAhu6iuimI0Vnk28O6eIf7/DtQVSvpwzEQrnzdxZOXsNPozps
S4/QJVPrqllpVukw9SDYgs8Y3oxP+TgkmqGPavQMhi7Ai8HqYs8=
=Rexp
-----END PGP SIGNATURE-----

--BspSmK1Kkx4+06Ky--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
