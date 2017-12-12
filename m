From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] Support writing man pages in MarkDown
Date: Tue, 12 Dec 2017 15:59:36 -0700
Message-ID: <20171212225936.GA29558@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The pages are converted during the build into *roff mdoc using
the pandoc tool.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 .travis.yml                   |  1 +
 CMakeLists.txt                |  4 +++
 buildlib/Findpandoc.cmake     | 21 +++++++++++++
 buildlib/cbuild               |  3 ++
 buildlib/rdma_functions.cmake | 33 --------------------
 buildlib/rdma_man.cmake       | 70 +++++++++++++++++++++++++++++++++++++++++++
 debian/control                |  1 +
 7 files changed, 100 insertions(+), 33 deletions(-)
 create mode 100644 buildlib/Findpandoc.cmake
 create mode 100644 buildlib/rdma_man.cmake

This is a very big series, I am only sending the first patch to the
mailing list. The whole series is on github here:

https://github.com/linux-rdma/rdma-core/pull/274

Overall, I'd like to see the man pages be more editable and viewable
when in patch format. Longer term I'd like to see them all rendered to
HTML and hosted on the web as libfabric and systemd are doing
successfully. While some of this can be done with the classic roff
format, it feels very painful.

Markdown was selected because we are already using it successfully for
other documentation, and libfabric has already demonstrated using it
for man pages. github will natively render the markdown documentation
internally for instance:

https://github.com/jgunthorpe/rdma-plumbing/blob/ea581c2d3d99d69083a8f4eaa9e55ae7ae233246/libibverbs/man/ibv_alloc_mw.3.md

Although some places are using features specific to the 'pandoc'
flavour of markdown, github still renders them in a readable format.

The next most popular choice is docbook XML, which I suspect would not
be well liked (and it is very baroque as well, just in a more modern
way)

The actual conversion of the man pages was done largely by script,
with some manual fixes and post-inspection. There doesn't seem to be a
useful mdoc to markdown conversion script, so I built a quick and
dirty one that works on our .3 man page style.

The converter is here:

https://github.com/jgunthorpe/rdma-plumbing/blob/migration-tooling/buildlib/man2md.py

I'm no mdoc expert, but it sure looks to me like there are many markup
problems in our man pages, even if they happen to render mostly properly.

Overall the conversion to markdown is very good in terms of resulting
'man ibv_foo' display with a few notable variances:
 - The 'synopsis' is shifted right by 8 spaces and isn't bolded in
   quite the same way
 - I ran all the C code through clang-format and asked it fit it to
   the standard 80 col terminal. Some of the results are 'interesting'
   to say the least. Others are much better than before.
 - Some of the hypenation choices are a little different
 
pandoc is fairly widely available in the distros with the notable
problem that centos 6 and 7 can only get it from EPEL.

Since this may be a problem, I am thinking about following the
libfabric approach and either including the precompiled man pages in
the source tree, or just providing a framework for downstream to
add-on precompiled files (with a cbuild command to make them)
Looking for feedback on what path is best..

diff --git a/.travis.yml b/.travis.yml
index 7af2aeb9072db5..b7723f38295bc0 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -32,6 +32,7 @@ addons:
       - libudev-dev
       - make
       - ninja-build
+      - pandoc
       - pkg-config
       - python
       - valgrind
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 6c5d6b7c539515..42fc5db0523687 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -135,6 +135,7 @@ include(RDMA_BuildType)
 include(RDMA_DoFixup)
 include(publish_headers)
 include(rdma_functions)
+include(rdma_man)
 
 if (NOT DEFINED ENABLE_STATIC)
   set(ENABLE_STATIC "OFF" CACHE BOOL "Produce static linking libraries as well as shared libraries.")
@@ -282,6 +283,9 @@ endif()
 # Look for Python
 FIND_PACKAGE (PythonInterp)
 
+# Look for pandoc
+FIND_PACKAGE(pandoc REQUIRED)
+
 #-------------------------
 # Find libraries
 # pthread
diff --git a/buildlib/Findpandoc.cmake b/buildlib/Findpandoc.cmake
new file mode 100644
index 00000000000000..f753165a7b6593
--- /dev/null
+++ b/buildlib/Findpandoc.cmake
@@ -0,0 +1,21 @@
+# COPYRIGHT (c) 2017 Mellanox Technologies Ltd
+# Licensed under BSD (MIT variant) or GPLv2. See COPYING.
+find_program(PANDOC_EXECUTABLE NAMES pandoc)
+
+if(PANDOC_EXECUTABLE)
+  execute_process(COMMAND "${PANDOC_EXECUTABLE}" -v
+    OUTPUT_VARIABLE _VERSION
+    RESULT_VARIABLE _VERSION_RESULT
+    ERROR_QUIET)
+
+  if(NOT _PYTHON_VERSION_RESULT)
+    string(REGEX REPLACE "^pandoc ([^\n]+)\n.*" "\\1" PANDOC_VERSION_STRING "${_VERSION}")
+  endif()
+  unset(_VERSION_RESULT)
+  unset(_VERSION)
+endif()
+
+include(FindPackageHandleStandardArgs)
+find_package_handle_standard_args(pandoc REQUIRED_VARS PANDOC_EXECUTABLE PANDOC_VERSION_STRING VERSION_VAR PANDOC_VERSION_STRING)
+
+mark_as_advanced(PANDOC_EXECUTABLE)
diff --git a/buildlib/cbuild b/buildlib/cbuild
index 29c5b4b87d9548..92672a20dafc54 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -98,6 +98,7 @@ class centos6(YumEnvironment):
         'libnl3-devel',
         'libudev-devel',
         'make',
+        'pandoc',
         'pkgconfig',
         'python',
         'rpm-build',
@@ -164,6 +165,7 @@ class trusty(APTEnvironment):
         'libudev-dev',
         'make',
         'ninja-build',
+        'pandoc',
         'pkg-config',
         'python',
         'valgrind',
@@ -309,6 +311,7 @@ class leap(ZypperEnvironment):
         'udev',
         'make',
         'ninja',
+        'pandoc',
         'pkg-config',
         'python3',
         'rpm-build',
diff --git a/buildlib/rdma_functions.cmake b/buildlib/rdma_functions.cmake
index 53a978e896acfa..0d858c56eee696 100644
--- a/buildlib/rdma_functions.cmake
+++ b/buildlib/rdma_functions.cmake
@@ -229,39 +229,6 @@ function(rdma_test_executable EXEC)
   set_target_properties(${EXEC} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${BUILD_BIN}")
 endfunction()
 
-# Install man pages. This deduces the section from the trailing integer in the
-# filename
-function(rdma_man_pages)
-  foreach(I ${ARGN})
-    if ("${I}" MATCHES "\\.in$")
-      string(REGEX REPLACE "^.+[.](.+)\\.in$" "\\1" MAN_SECT "${I}")
-      string(REGEX REPLACE "^(.+)\\.in$" "\\1" BASE_NAME "${I}")
-      get_filename_component(BASE_NAME "${BASE_NAME}" NAME)
-      rdma_subst_install(FILES "${I}"
-	DESTINATION "${CMAKE_INSTALL_MANDIR}/man${MAN_SECT}/"
-	RENAME "${BASE_NAME}")
-    else()
-      string(REGEX REPLACE "^.+[.](.+)$" "\\1" MAN_SECT "${I}")
-      install(FILES "${I}" DESTINATION "${CMAKE_INSTALL_MANDIR}/man${MAN_SECT}/")
-    endif()
-  endforeach()
-endfunction()
-
-# Create an alias for a man page, using a symlink.
-# Input is a list of pairs of names (MAN_PAGE ALIAS)
-# NOTE: The section must currently be the same for both.
-function(rdma_alias_man_pages)
-  list(LENGTH ARGN LEN)
-  math(EXPR LEN ${LEN}-1)
-  foreach(I RANGE 0 ${LEN} 2)
-    list(GET ARGN ${I} FROM)
-    math(EXPR I ${I}+1)
-    list(GET ARGN ${I} TO)
-    string(REGEX REPLACE "^.+[.](.+)$" "\\1" MAN_SECT ${FROM})
-    rdma_install_symlink("${FROM}" "${CMAKE_INSTALL_MANDIR}/man${MAN_SECT}/${TO}")
-  endforeach()
-endfunction()
-
 # Finalize the setup of the static libraries by copying the meta information
 # from the shared and setting up the libtool .la files.
 function(rdma_finalize_libs)
diff --git a/buildlib/rdma_man.cmake b/buildlib/rdma_man.cmake
new file mode 100644
index 00000000000000..83d7745ab0d608
--- /dev/null
+++ b/buildlib/rdma_man.cmake
@@ -0,0 +1,70 @@
+# COPYRIGHT (c) 2017 Mellanox Technologies Ltd
+# Licensed under BSD (MIT variant) or GPLv2. See COPYING.
+
+function(rdma_md_man_page SRC MAN_SECT MANFN)
+  set(OBJ "${CMAKE_CURRENT_BINARY_DIR}/${MANFN}")
+
+  add_custom_command(
+    OUTPUT "${OBJ}"
+    COMMAND "${PANDOC_EXECUTABLE}" -s -t man "${SRC}" -o "${OBJ}"
+    MAIN_DEPENDENCY "${SRC}"
+    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
+    COMMENT "Creating man page ${MANFN}"
+    VERBATIM)
+
+  add_custom_target("man-${MANFN}.${MAN_SECT}" ALL DEPENDS "${OBJ}")
+  install(FILES "${OBJ}"
+    DESTINATION "${CMAKE_INSTALL_MANDIR}/man${MAN_SECT}/")
+endfunction()
+
+# Install man pages. This deduces the section from the trailing integer in the
+# filename
+function(rdma_man_pages)
+  foreach(I ${ARGN})
+    if ("${I}" MATCHES "\\.md.in$")
+      string(REGEX REPLACE "^.+[.](.+)\\.md.in$" "\\1" MAN_SECT "${I}")
+      string(REGEX REPLACE "^(.+)\\.md.in$" "\\1" BASE_NAME "${I}")
+      get_filename_component(BASE_NAME "${BASE_NAME}" NAME)
+
+      configure_file("${I}" "${CMAKE_CURRENT_BINARY_DIR}/sub-${BASE_NAME}" @ONLY)
+      rdma_md_man_page(
+	"${CMAKE_CURRENT_BINARY_DIR}/sub-${BASE_NAME}"
+	"${MAN_SECT}"
+	"${BASE_NAME}")
+    elseif ("${I}" MATCHES "\\.md$")
+      string(REGEX REPLACE "^.+[.](.+)\\.md$" "\\1" MAN_SECT "${I}")
+      string(REGEX REPLACE "^(.+)\\.md$" "\\1" BASE_NAME "${I}")
+      get_filename_component(BASE_NAME "${BASE_NAME}" NAME)
+
+      rdma_md_man_page(
+	"${I}"
+	"${MAN_SECT}"
+	"${BASE_NAME}")
+    elseif ("${I}" MATCHES "\\.in$")
+      string(REGEX REPLACE "^.+[.](.+)\\.in$" "\\1" MAN_SECT "${I}")
+      string(REGEX REPLACE "^(.+)\\.in$" "\\1" BASE_NAME "${I}")
+      get_filename_component(BASE_NAME "${BASE_NAME}" NAME)
+      rdma_subst_install(FILES "${I}"
+	DESTINATION "${CMAKE_INSTALL_MANDIR}/man${MAN_SECT}/"
+	RENAME "${BASE_NAME}")
+    else()
+      string(REGEX REPLACE "^.+[.](.+)$" "\\1" MAN_SECT "${I}")
+      install(FILES "${I}" DESTINATION "${CMAKE_INSTALL_MANDIR}/man${MAN_SECT}/")
+    endif()
+  endforeach()
+endfunction()
+
+# Create an alias for a man page, using a symlink.
+# Input is a list of pairs of names (MAN_PAGE ALIAS)
+# NOTE: The section must currently be the same for both.
+function(rdma_alias_man_pages)
+  list(LENGTH ARGN LEN)
+  math(EXPR LEN ${LEN}-1)
+  foreach(I RANGE 0 ${LEN} 2)
+    list(GET ARGN ${I} FROM)
+    math(EXPR I ${I}+1)
+    list(GET ARGN ${I} TO)
+    string(REGEX REPLACE "^.+[.](.+)$" "\\1" MAN_SECT ${FROM})
+    rdma_install_symlink("${FROM}" "${CMAKE_INSTALL_MANDIR}/man${MAN_SECT}/${TO}")
+  endforeach()
+endfunction()
diff --git a/debian/control b/debian/control
index 451b379f01ae92..cfcdcc4e22884d 100644
--- a/debian/control
+++ b/debian/control
@@ -13,6 +13,7 @@ Build-Depends: cmake (>= 2.8.11),
                libsystemd-dev,
                libudev-dev,
                ninja-build,
+               pandoc,
                pkg-config,
                python,
                valgrind [!alpha !armel !hppa !m68k !powerpcspe !sh4 !sparc64 !x32]
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
