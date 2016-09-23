From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 01/13] Be consistent about defining NDEBUG
Date: Fri, 23 Sep 2016 13:16:56 -0600
Message-ID: <1474658228-5390-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474658228-5390-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We setup the two standard CMake build_types so that Release includes
NDEBUG and RelWithDebInfo does not (by default CMake sets it in both).

The recommendation is for packagers to use Release (by setting
-DCMAKE_BUILD_TYPE=Release) and developers use RelWithDebInfo
(the default)

This also replaces the default flags for Release with the RelWithDebInfo,
flags (-O2 -g -DNDEBUG) which is what we consider suitable for packaging.
The CMake default of -O3 is not tested.

Note that all the packaging systems I looked at force NDEBUG into the
CFLAGS.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                |  5 +++++
 buildlib/RDMA_BuildType.cmake | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)
 create mode 100644 buildlib/RDMA_BuildType.cmake

diff --git a/CMakeLists.txt b/CMakeLists.txt
index a829cd477c52..06dd98203349 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -7,6 +7,9 @@
 # Common options passed to cmake are:
 #  -DCMAKE_EXPORT_COMPILE_COMMANDS=1
 #      Write a compile_commands.json file for clang tooling
+#  -DCMAKE_BUILD_TYPE=RelWithDebInfo
+#      Change the optimization level, Debug disables optimization,
+#      Release is for packagers
 #  -DENABLE_VALGRIND=1 (default disabled)
 #      Embed valgrind notations, this has a tiny negative performance impact
 #  -DENABLE_RESOLVE_NEIGH=0 (default enabled)
@@ -58,12 +61,14 @@ include(CheckCCompilerFlag)
 include(CheckIncludeFile)
 include(CheckTypeSize)
 include(RDMA_EnableCStd)
+include(RDMA_BuildType)
 include(RDMA_DoFixup)
 include(publish_headers)
 include(rdma_functions)
 
 #-------------------------
 # Setup the basic C compiler
+RDMA_BuildType()
 include_directories(${BUILD_INCLUDE})
 # FIXME: Eliminate HAVE_CONFIG_H, we always have it.
 add_definitions(-DHAVE_CONFIG_H)
diff --git a/buildlib/RDMA_BuildType.cmake b/buildlib/RDMA_BuildType.cmake
new file mode 100644
index 000000000000..4f7485c397a0
--- /dev/null
+++ b/buildlib/RDMA_BuildType.cmake
@@ -0,0 +1,41 @@
+# COPYRIGHT (c) 2015 Obsidian Research Corporation. See COPYING file
+
+function(RDMA_BuildType)
+  set(build_types Debug Release RelWithDebInfo MinSizeRel)
+
+  # Set the default build type to RelWithDebInfo. Since RDMA is typically used
+  # in performance contexts it doesn't make much sense to have the default build
+  # turn off the optimizer.
+  if(NOT CMAKE_BUILD_TYPE)
+    set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE String
+      "Options are ${build_types}"
+      FORCE
+      )
+    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS ${build_types})
+  endif()
+
+  # Release should be used by packagers, it is the same as the default RelWithDebInfo,
+  # this means it uses -O2 and -DNDEBUG (not -O3)
+  foreach (language CXX C)
+    set(VAR_TO_MODIFY "CMAKE_${language}_FLAGS_RELEASE")
+    if ("${${VAR_TO_MODIFY}}" STREQUAL "${${VAR_TO_MODIFY}_INIT}")
+      set(${VAR_TO_MODIFY} "${CMAKE_${language}_FLAGS_RELWITHDEBINFO_INIT}"
+	  CACHE STRING "Default flags for Release configuration" FORCE)
+    endif()
+  endforeach()
+
+  # RelWithDebInfo should be used by developers, it is the same as Release but
+  # with the -DNDEBUG removed
+  foreach (language CXX C)
+    set(VAR_TO_MODIFY "CMAKE_${language}_FLAGS_RELWITHDEBINFO")
+    if (${${VAR_TO_MODIFY}} STREQUAL ${${VAR_TO_MODIFY}_INIT})
+	string(REGEX REPLACE "(^| )[/-]D *NDEBUG($| )"
+	  " "
+	  replacement
+	  "${${VAR_TO_MODIFY}}"
+	  )
+	set(${VAR_TO_MODIFY} "${replacement}"
+	    CACHE STRING "Default flags for RelWithDebInfo configuration" FORCE)
+    endif()
+  endforeach()
+endfunction()
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
