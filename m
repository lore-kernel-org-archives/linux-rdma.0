From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/5] ccan: Add list functionality
Date: Wed, 28 Sep 2016 10:53:37 -0600
Message-ID: <20160928165337.GB22668@obsidianresearch.com>
References: <1475076789-14359-1-git-send-email-yishaih@mellanox.com>
 <1475076789-14359-4-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475076789-14359-4-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 28, 2016 at 06:33:07PM +0300, Yishai Hadas wrote:
> @@ -2,4 +2,9 @@ publish_internal_headers(ccan
>    minmax.h
>    build_assert.h
>    config.h
> +  list.h
> +  str.h
> +  str_debug.h
> +  check_type.h
> +  container_of.h
>    )

Sorted too..

Should you include the .c files as well? Otherwise it looks like the
debug features do not work. Can't think of a reason not to include
them.

(see below)
.. and add any missing COPYING/LICENSE files.

> +#ifndef container_of
> +#define container_of(member_ptr, containing_type, member)		\
> +	 ((containing_type *)						\
> +	  ((char *)(member_ptr)						\
> +	   - container_off(containing_type, member))			\
> +	  + check_types_match(*(member_ptr), ((containing_type *)0)->member))
> +#endif

I wonder if we could figure out a way to avoid conflicting with the
version in verbs.h? This version is better as it has the
check_types_match.. For later..

Jason

diff --git a/buildlib/rdma_functions.cmake b/buildlib/rdma_functions.cmake
index ea53f382553f..5a1041f304e6 100644
--- a/buildlib/rdma_functions.cmake
+++ b/buildlib/rdma_functions.cmake
@@ -6,6 +6,9 @@
 # Global list of pairs of (SHARED STATIC) libary target names
 set(RDMA_STATIC_LIBS "" CACHE INTERNAL "Doc" FORCE)
 
+set(COMMON_LIBS_PIC ccan_pic)
+set(COMMON_LIBS ccan)
+
 # Install a symlink during 'make install'
 function(rdma_install_symlink LINK_CONTENT DEST)
   # Create a link in the build tree with the right content
@@ -59,6 +62,7 @@ function(rdma_library DEST VERSION_SCRIPT SOVERSION VERSION)
   # Create a shared library
   add_library(${DEST} SHARED ${ARGN})
   rdma_set_library_map(${DEST} ${VERSION_SCRIPT})
+  target_link_libraries(${DEST} LINK_PRIVATE ${COMMON_LIBS_PIC})
   set_target_properties(${DEST} PROPERTIES
     SOVERSION ${SOVERSION}
     VERSION ${VERSION}
@@ -98,6 +102,7 @@ function(rdma_provider DEST)
   # Even though these are modules we still want to use Wl,--no-undefined
   set_target_properties(${DEST} PROPERTIES LINK_FLAGS ${CMAKE_SHARED_LINKER_FLAGS})
   rdma_set_library_map(${DEST} ${BUILDLIB}/provider.map)
+  target_link_libraries(${DEST} LINK_PRIVATE ${COMMON_LIBS_PIC})
   target_link_libraries(${DEST} LINK_PRIVATE ibverbs)
   target_link_libraries(${DEST} LINK_PRIVATE ${CMAKE_THREAD_LIBS_INIT})
   set_target_properties(${DEST} PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
@@ -110,6 +115,7 @@ endfunction()
  # Create an installed executable
 function(rdma_executable EXEC)
   add_executable(${EXEC} ${ARGN})
+  target_link_libraries(${EXEC} LINK_PRIVATE ${COMMON_LIBS})
   set_target_properties(${EXEC} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${BUILD_BIN}")
   install(TARGETS ${EXEC} DESTINATION "${CMAKE_INSTALL_BINDIR}")
 endfunction()
@@ -117,6 +123,7 @@ endfunction()
  # Create an installed executable (under sbin)
 function(rdma_sbin_executable EXEC)
   add_executable(${EXEC} ${ARGN})
+  target_link_libraries(${EXEC} LINK_PRIVATE ${COMMON_LIBS})
   set_target_properties(${EXEC} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${BUILD_BIN}")
   install(TARGETS ${EXEC} DESTINATION "${CMAKE_INSTALL_SBINDIR}")
 endfunction()
@@ -124,6 +131,7 @@ endfunction()
 # Create an test executable (not-installed)
 function(rdma_test_executable EXEC)
   add_executable(${EXEC} ${ARGN})
+  target_link_libraries(${EXEC} LINK_PRIVATE ${COMMON_LIBS})
   set_target_properties(${EXEC} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${BUILD_BIN}")
 endfunction()
 
diff --git a/ccan/CMakeLists.txt b/ccan/CMakeLists.txt
index 70b54306bdaa..778c85130ff9 100644
--- a/ccan/CMakeLists.txt
+++ b/ccan/CMakeLists.txt
@@ -8,3 +8,10 @@ publish_internal_headers(ccan
   check_type.h
   container_of.h
   )
+
+set(C_FILES
+  str.c
+  )
+add_library(ccan STATIC ${C_FILES})
+add_library(ccan_pic STATIC ${C_FILES})
+set_property(TARGET ccan_pic PROPERTY POSITION_INDEPENDENT_CODE TRUE)
diff --git a/ibacm/CMakeLists.txt b/ibacm/CMakeLists.txt
index 8887c13af463..a09b7f789800 100644
--- a/ibacm/CMakeLists.txt
+++ b/ibacm/CMakeLists.txt
@@ -18,7 +18,7 @@ rdma_sbin_executable(ibacm
   src/acm.c
   src/acm_util.c
   )
-target_link_libraries(ibacm
+target_link_libraries(ibacm LINK_PRIVATE
   ibverbs
   ibumad
   ${CMAKE_THREAD_LIBS_INIT}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
