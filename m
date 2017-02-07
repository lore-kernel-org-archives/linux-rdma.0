From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: OFED-4.8, rdma-core, and library paths
Date: Tue, 7 Feb 2017 22:14:28 +0200
Message-ID: <20170207201428.GV6005@mtr-leonro.local>
References: <011b01d28153$e5f0adf0$b1d209d0$@opengridcomputing.com>
 <20170207171145.GB1077@obsidianresearch.com>
 <02c801d28166$693e17d0$3bba4770$@opengridcomputing.com>
 <20170207172752.GA12315@obsidianresearch.com>
 <20170207180642.GQ6005@mtr-leonro.local>
 <20170207181814.GA13368@obsidianresearch.com>
 <20170207183538.GT6005@mtr-leonro.local>
 <20170207184206.GA14102@obsidianresearch.com>
 <20170207194759.GU6005@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hmAoQ2KfXDe4pzCq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170207194759.GU6005-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, 'Vladimir Sokolovsky' <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--hmAoQ2KfXDe4pzCq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 07, 2017 at 09:47:59PM +0200, Leon Romanovsky wrote:
> On Tue, Feb 07, 2017 at 11:42:06AM -0700, Jason Gunthorpe wrote:
> > On Tue, Feb 07, 2017 at 08:35:38PM +0200, Leon Romanovsky wrote:
> > > I made it (rdma_shared_provider function), but have a very hard time
> > > to properly create ".." symlink, because during the build (in place too)
> > > the output is placed in build/lib in flat structure and symlinks need to
> > > be without "..". But during installation phase, these symlinks should
> > > be changed to ".." and it doesn't work for me in automatic way :(
> >
> > For symlinks build/ and installed are two different flows, they don't intermix
> >
> > Compile the library to build/lib/libibverbs-dv-mlx5.so.1.0.13
> > and setup a symlink build/lib/libmlx5-rdmav2.so -> libibverbs-dv-mlx5.so.1.0.13
>
> Just as a note, I'm calling it libmlx5 and not libibverbs-dv-mlx5.
>
> >
> > For install, use realpath like this:
> >
> >  execute_process(COMMAND "realpath --relative-to ${VERBS_PROVIDER_DIR} ${CMAKE_INSTALL_LIBDIR}/libmlx5.so.1.0.13" OUTPUT_VARIBALE LINK_PATH)
>
> It doesn't work for me :(
> -- verbs_provder_dir = /usr/lib64/libibverbs
> -- install_libdir = /usr/lib64
> -- link_path =
>
> lrwxrwxrwx 1 root root     18 Feb  7 21:43 /lib64/libibverbs/libmlx5-rdmav2.so -> /libmlx5.so.1.0.13
> lrwxrwxrwx 1 root root     10 Feb  7 21:43 /lib64/libmlx5-rdmav2.so -> libmlx5.so
> lrwxrwxrwx 1 root root     12 Feb  7 21:43 /lib64/libmlx5.so -> libmlx5.so.1
> lrwxrwxrwx 1 root root     17 Feb  7 21:43 /lib64/libmlx5.so.1 -> libmlx5.so.1.0.13
> -rwxr-xr-x 1 root root 666637 Feb  7 21:43 /lib64/libmlx5.so.1.0.13
> lrwxrwxrwx 1 root root     18 Feb  7 21:43 /usr/lib64/libibverbs/libmlx5-rdmav2.so -> /libmlx5.so.1.0.13
> lrwxrwxrwx 1 root root     10 Feb  7 21:43 /usr/lib64/libmlx5-rdmav2.so -> libmlx5.so
> lrwxrwxrwx 1 root root     12 Feb  7 21:43 /usr/lib64/libmlx5.so -> libmlx5.so.1
> lrwxrwxrwx 1 root root     17 Feb  7 21:43 /usr/lib64/libmlx5.so.1 -> libmlx5.so.1.0.13
> -rwxr-xr-x 1 root root 666637 Feb  7 21:43 /usr/lib64/libmlx5.so.1.0.13
>
>
> >  rdma_install_symlink("${LINK_PATH}/libibverbs-dv-mlx5.so.1.0.13" "${VERBS_PROVIDER_DIR}/libmlx5-rdmav2.so")
> >
> > The rdma_install_symlink helper takes care of the install step.
> >

At the end, my function looks as follow:

# Create a special provider with exported symbols in it
function(rdma_shared_provider DEST VERSION_SCRIPT SOVERSION VERSION)
  # Installed driver file
  file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${DEST}.driver" "driver ${DEST}\n")
  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${DEST}.driver" DESTINATION "${CONFIG_DIR}")

  # Uninstalled driver file
  file(MAKE_DIRECTORY "${BUILD_ETC}/libibverbs.d/")
  file(WRITE "${BUILD_ETC}/libibverbs.d/${DEST}.driver" "driver ${BUILD_LIB}/lib${DEST}\n")

  # Create a static provider library
  if (ENABLE_STATIC)
    add_library(${DEST} STATIC ${ARGN})
    set_target_properties(${DEST} PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
    install(TARGETS ${DEST} DESTINATION "${CMAKE_INSTALL_LIBDIR}")

    list(APPEND RDMA_STATIC_LIBS ${DEST}-rdmav2 ${DEST})
    set(RDMA_STATIC_LIBS "${RDMA_STATIC_LIBS}" CACHE INTERNAL "")
  endif()

  # Create the plugin shared library
  add_library(${DEST} SHARED ${ARGN})
  # Even though these are modules we still want to use Wl,--no-undefined
  set_target_properties(${DEST} PROPERTIES LINK_FLAGS ${CMAKE_SHARED_LINKER_FLAGS})
  rdma_set_library_map(${DEST} ${VERSION_SCRIPT})

  target_link_libraries(${DEST} LINK_PRIVATE ${COMMON_LIBS_PIC})
  target_link_libraries(${DEST} LINK_PRIVATE ibverbs)
  target_link_libraries(${DEST} LINK_PRIVATE ${CMAKE_THREAD_LIBS_INIT})
  set_target_properties(${DEST} PROPERTIES
  	SOVERSION ${SOVERSION}
  	VERSION ${VERSION}
  	LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
  add_custom_target(share_link ALL DEPENDS "${DEST}"  COMMAND ${CMAKE_COMMAND} -E create_symlink "lib${DEST}.so.${VERSION}"
	  "${BUILD_LIB}/lib${DEST}-rdmav2.so")
  add_dependencies(share_link ${DEST})

  install(TARGETS ${DEST} DESTINATION "${CMAKE_INSTALL_LIBDIR}")
  install(FILES "${BUILD_LIB}/lib${DEST}-rdmav2.so" DESTINATION "${CMAKE_INSTALL_LIBDIR}")
  rdma_install_symlink("${CMAKE_INSTALL_LIBDIR}/lib${DEST}.so.${VERSION}" "${VERBS_PROVIDER_DIR}/libmlx5-rdmav2.so")
endfunction()

> > Jason



--hmAoQ2KfXDe4pzCq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliaKqMACgkQ5GN7iDZy
WKdRNw/8CdgDw4zvgszU67fgCArC+mYVlI+YNsRHSESCRgO7GiZJdeChtA2ViwOT
uj0BvIUSLiHyJm3omadGSHT5N2Q6+ZMWGRizyaR4tWZqdEgjRkiS3zxI90lVoYRa
kZV0CKsYAV6l9/Jtpa2EAIpTtdX2SL8CsVj52FrT7ZXmYTuOuug1uqCnsyX/OPkR
vIR4pIjFDr/LMIN3nIYe67ibEfo+ghtpUceEyM7BnyUeGRayK40p+XULURpid+vR
YL+lcRHJTCGTje5nAi8/Ik10hnHUzE6sTMLpWDoPj8GT1sB+78W+q9Ym/9Ckl17L
hNr73+cyKLFigPwlNuZx9xCOoTQldn8OiBQVwoVTg3c9bJ3gN85hgdI3rSpy6ktd
hNtf1/YtzDIYXTSuL7AUBOL7dFTXUGd19gDcYGu+B8/OB/d5qgVZvS+d9rt3EZLS
gMMW+2jjw6foTrhakEFk14PAAfQ4ao6fUYsR7aEB9rv+IKqrqalnNCkZd1yaoCFy
2nXY7xOUMOOC6QSQ7JmZKbV5+BujlJVWaokUqIVCqicdC5zP1+EAZzmHBdRJjBaX
pir6AA4tdPaBjxmklq+F1nr49Z46gRD2dcQVkft3wU15dXOqXaoi0AKbOsaox3Ku
kwzuOljW/a1VysF8jcRjH4Y2jGVNZX0+h0Wcl+k8u0Sgczt3SOQ=
=AyzE
-----END PGP SIGNATURE-----

--hmAoQ2KfXDe4pzCq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
