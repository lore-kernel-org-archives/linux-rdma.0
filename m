From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: OFED-4.8, rdma-core, and library paths
Date: Wed, 8 Feb 2017 20:54:46 +0200
Message-ID: <20170208185446.GH6005@mtr-leonro.local>
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
        protocol="application/pgp-signature"; boundary="ipnWYyHVFfcKpJnS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170208181820.GA31664-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, 'Vladimir Sokolovsky' <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ipnWYyHVFfcKpJnS
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
>
> >   install(TARGETS ${DEST} DESTINATION "${CMAKE_INSTALL_LIBDIR}")
> >   execute_process(COMMAND python ${CMAKE_SOURCE_DIR}/buildlib/relpath
> >     ${CMAKE_INSTALL_LIBDIR}/lib${DEST}.so.${VERSION} ${VERBS_PROVIDER_DIR}
> >     OUTPUT_VARIABLE DEST_LINK_PATH OUTPUT_STRIP_TRAILING_WHITESPACE)
> >   rdma_install_symlink("${DEST_LINK_PATH}" "${VERBS_PROVIDER_DIR}/lib${DEST}-rdmav2.so")
>
> > and buildlib/relpath
> > import os
> > import sys
> >
> > print(os.path.relpath(sys.argv[1], sys.argv[2]))
>
> Sure, yes, doing the escaping right would probably be quite hard, that is the
> usual nightmare with shell stuff unfortunately.
>
> > But I still have issues with DEB package.
> > It creates absolute (and wrong)  symlink instead of relative one.
>
> Hmm. Can you update your github? I'll look for you.

I pushed latest code to m/dv-1 branch, it is not for inclusion yet.
https://github.com/rleon/rdma-core/commits/m/dv-v1
Updated cover letter with changelog:
https://github.com/rleon/rdma-core/commit/a332669511d5bbbd3dcdd977fbf95aa7ee47a69e
And all cmake/packages stuff in the patch:
https://github.com/rleon/rdma-core/commit/fcc4996c7fa5169fe599c2d568476314c1f65ddc

>
> > -rw-r--r-- 1 leonro leonro 46K Feb  8 17:13 libmlx4-rdmav2.so
> > lrwxrwxrwx 1 leonro leonro  65 Feb  8 17:13 libmlx5-rdmav2.so -> /home/leonro/src/build-deb/lib/x86_64-linux-gnu/libmlx5.so.1.0.13
>
> Most likely this means that DEST_LINK_PATH passed to
> rdma_install_symlink is not correct. Which suggests python relpath is
> not working..
>
> relpath in python is done textually, from these args:
>
> >     ${CMAKE_INSTALL_LIBDIR}/lib${DEST}.so.${VERSION} ${VERBS_PROVIDER_DIR}
>
> But
>
>  set(VERBS_PROVIDER_DIR "${CMAKE_INSTALL_FULL_LIBDIR}/libibverbs"
>
> So if CMAKE_INSTALL_FULL_LIBDIR != CMAKE_INSTALL_LIBDIR (which depends
> on how the distro build script configures cmake) then it will fail.
>
> Switch to:
>
>      ${CMAKE_INSTALL_FULL_LIBDIR}/lib${DEST}.so.${VERSION} ${VERBS_PROVIDER_DIR}

You are right, it fixed debian, I'm testing other packages now.
diff --git a/buildlib/rdma_functions.cmake b/buildlib/rdma_functions.cmake
index 3d0683d0..3a1758f8 100644
--- a/buildlib/rdma_functions.cmake
+++ b/buildlib/rdma_functions.cmake
@@ -110,9 +110,15 @@ function(rdma_shared_provider DEST VERSION_SCRIPT SOVERSION VERSION)
   add_dependencies(share_link ${DEST})

   install(TARGETS ${DEST} DESTINATION "${CMAKE_INSTALL_LIBDIR}")
-  execute_process(COMMAND python ${CMAKE_SOURCE_DIR}/buildlib/relpath
-    ${CMAKE_INSTALL_LIBDIR}/lib${DEST}.so.${VERSION} ${VERBS_PROVIDER_DIR}
-    OUTPUT_VARIABLE DEST_LINK_PATH OUTPUT_STRIP_TRAILING_WHITESPACE)
+  if (NOT ${CMAKE_INSTALL_FULL_LIBDIR} STREQUAL ${CMAKE_INSTALL_LIBDIR})
+    execute_process(COMMAND python ${CMAKE_SOURCE_DIR}/buildlib/relpath
+	    ${CMAKE_INSTALL_FULL_LIBDIR}/lib${DEST}.so.${VERSION} ${VERBS_PROVIDER_DIR}
+      OUTPUT_VARIABLE DEST_LINK_PATH OUTPUT_STRIP_TRAILING_WHITESPACE)
+  else()
+    execute_process(COMMAND python ${CMAKE_SOURCE_DIR}/buildlib/relpath
+      ${CMAKE_INSTALL_LIBDIR}/lib${DEST}.so.${VERSION} ${VERBS_PROVIDER_DIR}
+      OUTPUT_VARIABLE DEST_LINK_PATH OUTPUT_STRIP_TRAILING_WHITESPACE)
+  endif()
   rdma_install_symlink("${DEST_LINK_PATH}" "${VERBS_PROVIDER_DIR}/lib${DEST}-rdmav2.so")
 endfunction()


>
> Jason

--ipnWYyHVFfcKpJnS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlibaXUACgkQ5GN7iDZy
WKe0uRAAxlX0M5Ecgru6CD/uZO9Q2jWE+n60dQtl8keubPpjZ9W/AMuRsyUPwrUH
TMY0MelqktfDqwA+4eo8Wl9eVvbD8IsiitFGjnheHvaQ4z62Vz/Xspg3uDXKsARB
G9vjHF2YUlTRcGVrKxYUK0u0ZCzlBkox3zDsVpkhMwRv7AD7SfzqSsLuonSnt2hK
DydRk2vhdNxw9FHOvRO5mnD5v83+RHZ4p7IHfbW00y27jOpnkTvA51hapVQnWkka
euTTrlnu1RdRnm7v7stXlZ+SNbNNCYuG/ebGjW55qUBp+Cmqsc04FEgyD5TvbdaY
HAf+VCq4qNTOb4Mq+wwsK1iJ0q6w27Y74YcJ/X+K8cROlFviuhi0GS/bgN6em+lG
8sxHaeG4io/2cZ6xpf11lbHDYND6oUDU57Ue29HxwpwkkVUgU5r910Kab4NIi2dC
R6GU1DvZTaFLPKIT4iQhLP+GMUD9jVPamCks2dHJYZ65NP6LQBJNPb5stfF824LF
H/nsXx1SnQZzUwnAHc6uDzT7MbY0pJNe3vBNvbLlD4mgFUwsmz55IqUqzaM16pim
1NqMwTX2oX6py0MrXYeY+gxJeMEsTlLXIhww9RXl1pm5RAwDGSvP+D9QTqvD3PtV
pbaB2ym45w4AdkuYSUaGmLTQQfok6nJO58N6N1icxiEIuQxbfIs=
=SfOS
-----END PGP SIGNATURE-----

--ipnWYyHVFfcKpJnS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
