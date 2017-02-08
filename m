From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: OFED-4.8, rdma-core, and library paths
Date: Wed, 8 Feb 2017 21:39:49 +0200
Message-ID: <20170208193949.GI6005@mtr-leonro.local>
References: <20170207181814.GA13368@obsidianresearch.com>
 <20170207183538.GT6005@mtr-leonro.local>
 <20170207184206.GA14102@obsidianresearch.com>
 <20170207194759.GU6005@mtr-leonro.local>
 <20170207201428.GV6005@mtr-leonro.local>
 <20170207205930.GA28922@obsidianresearch.com>
 <20170208063758.GZ6005@mtr-leonro.local>
 <20170208173335.GB30720@obsidianresearch.com>
 <20170208180104.GG6005@mtr-leonro.local>
 <20170208181820.GA31664@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AD38IXAdxoUBh2A8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170208181820.GA31664-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, 'Vladimir Sokolovsky' <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--AD38IXAdxoUBh2A8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 08, 2017 at 11:18:20AM -0700, Jason Gunthorpe wrote:
> On Wed, Feb 08, 2017 at 08:01:04PM +0200, Leon Romanovsky wrote:
> > On Wed, Feb 08, 2017 at 10:33:35AM -0700, Jason Gunthorpe wrote:
>
> > Thanks for the help, my final version which works correctly for build in place, install from
> > sources and packages for centos6/centos6 is below:
>
> Looks good
>
> > # Create a special provider with exported symbols in it
> > function(rdma_shared_provider DEST VERSION_SCRIPT SOVERSION VERSION)
> >   # Installed driver file
> >   file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${DEST}.driver" "driver ${DEST}\n")
> >   install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${DEST}.driver" DESTINATION "${CONFIG_DIR}")
> >
> >   # Uninstalled driver file
> >   file(MAKE_DIRECTORY "${BUILD_ETC}/libibverbs.d/")
> >   file(WRITE "${BUILD_ETC}/libibverbs.d/${DEST}.driver" "driver ${BUILD_LIB}/lib${DEST}\n")
> >
> >   # Create a static provider library
> >   if (ENABLE_STATIC)
> >     add_library(${DEST} STATIC ${ARGN})
> >     set_target_properties(${DEST} PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
> >     install(TARGETS ${DEST} DESTINATION "${CMAKE_INSTALL_LIBDIR}")
> >
> >     list(APPEND RDMA_STATIC_LIBS ${DEST}-rdmav2 ${DEST})
> >     set(RDMA_STATIC_LIBS "${RDMA_STATIC_LIBS}" CACHE INTERNAL "")
> >   endif()
> >
> >   # Create the plugin shared library
> >   add_library(${DEST} SHARED ${ARGN})
> >   # Even though these are modules we still want to use Wl,--no-undefined
> >   set_target_properties(${DEST} PROPERTIES LINK_FLAGS ${CMAKE_SHARED_LINKER_FLAGS})
> >   rdma_set_library_map(${DEST} ${VERSION_SCRIPT})
> >
> >   target_link_libraries(${DEST} LINK_PRIVATE ${COMMON_LIBS_PIC})
> >   target_link_libraries(${DEST} LINK_PRIVATE ibverbs)
> >   target_link_libraries(${DEST} LINK_PRIVATE ${CMAKE_THREAD_LIBS_INIT})
> >   set_target_properties(${DEST} PROPERTIES
> >   	SOVERSION ${SOVERSION}
> >   	VERSION ${VERSION}
> >   	LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
> >   add_custom_target(share_link ALL DEPENDS "${DEST}"  COMMAND ${CMAKE_COMMAND} -E create_symlink "lib${DEST}.so.${VERSION}"
> > 	  "${BUILD_LIB}/lib${DEST}-rdmav2.so")
> >   add_dependencies(share_link ${DEST})
>
> Except this really shouldn't be a rule.  The non-rule method is used
> everywhere else (eg man pages), so it must work here, it doesn't make
> sense that ninja vs make would be any different. When you get
> everything working put it back to execute_process..

I tried it now and with ninja run, I'm getting the following error:
-- Performing Test HAVE_C_WREDUNDANT_DECLS - Success
failed to create symbolic link '/home/leonro/src/rdma-core/build/lib/libmlx5-rdmav2.so': No such file or directory
-- Missing Optional Items:

Thanks

--AD38IXAdxoUBh2A8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlibdAQACgkQ5GN7iDZy
WKfF3w//RC8XDTOk8Nn51f7ObZOuxuCaAYLXyrXZb8Ixu+a2zyknflTyyQ3yvTfj
qvjmBHCVWeQCdXYLuMFdlylo67ziIUxPLrW7r9S+jqkdB8Vg9Op+CjGPMgxm9xxb
boEeV0/MXK13H/w8YAgpPNSPbfX8rOtiSqBVj2du0AtHSswyCsZYTRcKHh5CUskw
QAmCYOLEioz2BVwfEOiAl+Il6un51rh4a88/mPJsgkCidjiiPgyxGnsB9Q20KxmQ
RMyUELHNtvHk9ROt7P78JcuPDOkCsmbEIBrLu4SQzntCAADonOLRIWow8FDkLTlj
GYw2ACFO/mJVsxMaPUEMz+JNOZqTEkidl+pg9c7yGNx//lyUq76kAkqFIuCHDMhS
Qhw/ObifZtInVVFvU0Dj4c9h/oJuJYx/aJaZk5/LVbTZaBTOPb+YK8+iyd6VXscc
MlDxG9D9rJO2Tk9bz2lNZDPiBENe28vg6yUX/lf5/TodrRAurc+L/Wy//6/azuQX
aAAXEcYkORXAIyptqCMI2JzT0+4f84vKmvqpAmWOs5VPSDp9F/9q8EXFKQatK6r5
86I0CC8vvIheHRer6l4A4url9w6KhkztPBH2HG2/35FauhYAvkNDArSHCChS691Q
+B/WSgIdEgtCRztXeFGqHBiquizZLOp3zsLp9VmQVyfcG8+wirE=
=37k/
-----END PGP SIGNATURE-----

--AD38IXAdxoUBh2A8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
