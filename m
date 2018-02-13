From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 1/2] Support writing man pages in MarkDown
Date: Mon, 12 Feb 2018 20:51:29 -0700
Message-ID: <20180213035130.980-2-jgg@ziepe.ca>
References: <20180213035130.980-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213035130.980-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

If pandoc is installed then it will be run automatically during the build
to create the *roff versions of the man pages. Otherwise 'make install'
will fail if building from git.

To support distributions without pandoc, the official .tar.gz on github is
revised to include copies of the prebuilt pandoc output from the travis
container. This is done automatically each time a release is tagged.

This can also be done locally with:
 $ cbuild make travis
 $ cp -r build-travis/pandoc-prebuilt buildlib/

cbuild knows how to do the above automatically when building packages for
centos6 and centos7.

Of the supported distributions only CentOS 6 and 7 do not include
pandoc. Developers using those distros are encouraged to get pandoc from
EPEL.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 .travis.yml                   |  1 +
 CMakeLists.txt                | 13 ++++++-
 README.md                     |  2 +-
 buildlib/Findpandoc.cmake     | 21 ++++++++++++
 buildlib/cbuild               | 46 +++++++++++++++++++++----
 buildlib/github-release       |  4 ++-
 buildlib/pandoc-prebuilt.py   | 37 ++++++++++++++++++++
 buildlib/rdma_functions.cmake | 51 ++++++---------------------
 buildlib/rdma_man.cmake       | 80 +++++++++++++++++++++++++++++++++++++++++++
 debian/control                |  1 +
 redhat/rdma-core.spec         |  5 +++
 suse/rdma-core.spec           |  1 +
 12 files changed, 212 insertions(+), 50 deletions(-)
 create mode 100644 buildlib/Findpandoc.cmake
 create mode 100644 buildlib/pandoc-prebuilt.py
 create mode 100644 buildlib/rdma_man.cmake

diff --git a/.travis.yml b/.travis.yml
index 9d9667a9ecd838..20d3dd2e8562fb 100644
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
index e63f4cf563677a..d8c33c39a1b611 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -135,6 +135,7 @@ include(RDMA_BuildType)
 include(RDMA_DoFixup)
 include(publish_headers)
 include(rdma_functions)
+include(rdma_man)
 
 if (NOT DEFINED ENABLE_STATIC)
   set(ENABLE_STATIC "OFF" CACHE BOOL "Produce static linking libraries as well as shared libraries.")
@@ -280,7 +281,10 @@ else()
 endif()
 
 # Look for Python
-FIND_PACKAGE (PythonInterp)
+FIND_PACKAGE(PythonInterp REQUIRED)
+
+# Look for pandoc
+FIND_PACKAGE(pandoc)
 
 #-------------------------
 # Find libraries
@@ -500,6 +504,13 @@ else()
     message(STATUS " netlink/route/link.h and net/if.h NOT co-includable (old headers)")
   endif()
 endif()
+if (NOT PANDOC_FOUND)
+  if (NOT EXISTS "${CMAKE_SOURCE_DIR}/buildlib/pandoc-prebuilt")
+    message(STATUS " pandoc NOT found and NO prebuilt man pages. 'install' disabled")
+  else()
+    message(STATUS " pandoc NOT found (using prebuilt man pages)")
+  endif()
+endif()
 if (NOT SYSTEMD_FOUND)
   message(STATUS " libsystemd NOT found (disabling features)")
 endif()
diff --git a/README.md b/README.md
index 4d7e949b220ed3..0594272ffd553d 100644
--- a/README.md
+++ b/README.md
@@ -82,7 +82,7 @@ best experience.
 
 ```sh
 $ yum install epel-release
-$ yum install cmake3 unzip ninja-build
+$ yum install cmake3 ninja-build pandoc
 ```
 
 NOTE: EPEL uses the name 'ninja-build' for the 'ninja' command, and 'cmake3'
diff --git a/buildlib/Findpandoc.cmake b/buildlib/Findpandoc.cmake
new file mode 100644
index 00000000000000..ca1694ae640eff
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
+  if(NOT _VERSION_RESULT)
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
index 32fdc04c542536..93ae79f9dfd839 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -73,6 +73,7 @@ class DockerFile(object):
         self.lines = ["FROM %s"%(src)];
 
 class Environment(object):
+    pandoc = True;
     python_cmd = "python";
     aliases = set();
     use_make = False;
@@ -106,18 +107,21 @@ class centos6(YumEnvironment):
     };
     name = "centos6";
     use_make = True;
+    pandoc = False;
 
 class centos7(YumEnvironment):
     docker_parent = "centos:7";
     pkgs = centos6.pkgs | {'systemd-devel'};
     name = "centos7";
     use_make = True;
+    pandoc = False;
     specfile = "redhat/rdma-core.spec";
 
 class centos7_epel(centos7):
-    pkgs = (centos7.pkgs - {"cmake","make"}) | {"ninja-build","cmake3"};
+    pkgs = (centos7.pkgs - {"cmake","make"}) | {"ninja-build","cmake3","pandoc"};
     name = "centos7_epel";
     use_make = False;
+    pandoc = True;
     ninja_cmd = "ninja-build";
     # Our spec file does not know how to cope with cmake3
     is_rpm = False;
@@ -130,7 +134,7 @@ class centos7_epel(centos7):
 
 class fc27(Environment):
     docker_parent = "fedora:27";
-    pkgs = (centos7.pkgs - {"make"}) | {"ninja-build"};
+    pkgs = (centos7.pkgs - {"make"}) | {"ninja-build","pandoc"};
     name = "fc27";
     specfile = "redhat/rdma-core.spec";
     ninja_cmd = "ninja-build";
@@ -165,6 +169,7 @@ class trusty(APTEnvironment):
         'libudev-dev',
         'make',
         'ninja-build',
+        'pandoc',
         'pkg-config',
         'python',
         'valgrind',
@@ -300,6 +305,7 @@ class ZypperEnvironment(Environment):
         return res;
 
 class leap(ZypperEnvironment):
+    proxy = False;
     docker_parent = "opensuse:42.3";
     specfile = "suse/rdma-core.spec";
     pkgs = {
@@ -310,6 +316,7 @@ class leap(ZypperEnvironment):
         'udev',
         'make',
         'ninja',
+        'pandoc',
         'pkg-config',
         'python3',
         'rpm-build',
@@ -432,6 +439,35 @@ def get_image_id(args,image_name):
 
 # -------------------------------------------------------------------------
 
+def get_tar_file(tarfn,pandoc_prebuilt=False):
+    """Create a tar file that matches what buildlib/github-release would do if it
+    was a tagged release"""
+    prefix = "%s-%s/"%(project,get_version());
+    if not pandoc_prebuilt:
+        subprocess.check_call(["git","archive",
+                               # This must match the prefix generated buildlib/github-release
+                               "--prefix",prefix,
+                               "--output",tarfn,
+                               "HEAD"]);
+        return;
+
+    # When the OS does not support pandoc we got through the extra step to
+    # build pandoc output in the travis container and include it in the
+    # tar. This is similar to what buildlib/github-release does.
+    subprocess.check_call(["buildlib/cbuild","make","travis","docs"]);
+
+    tmp_tarfn = os.path.join(os.path.dirname(tarfn),"tmp.tar");
+    get_tar_file(tmp_tarfn,False);
+
+    subprocess.check_call([
+        "tar",
+        "-rf",tmp_tarfn,
+        "build-travis/pandoc-prebuilt/",
+        "--xform","s|build-travis/pandoc-prebuilt|%sbuildlib/pandoc-prebuilt|g"%(prefix)]);
+    with open(tarfn,"w") as F:
+        subprocess.check_call(["gzip","-9c",tmp_tarfn],stdout=F);
+    os.unlink(tmp_tarfn);
+
 def run_rpm_build(args,spec_file,env):
     with open(spec_file,"r") as F:
         for ln in F:
@@ -447,11 +483,7 @@ def run_rpm_build(args,spec_file,env):
         os.mkdir(os.path.join(tmpdir,"SOURCES"));
         os.mkdir(os.path.join(tmpdir,"tmp"));
 
-        subprocess.check_call(["git","archive",
-                               # This must match the prefix generated buildlib/github-release
-                               "--prefix","%s-%s/"%(project,get_version()),
-                               "--output",os.path.join(tmpdir,"SOURCES",tarfn),
-                               "HEAD"]);
+        get_tar_file(os.path.join(tmpdir,"SOURCES",tarfn),pandoc_prebuilt=not env.pandoc);
 
         with open(spec_file,"r") as inF:
             spec = list(inF);
diff --git a/buildlib/github-release b/buildlib/github-release
index 9740b51d682405..0347ed9fa9b17c 100755
--- a/buildlib/github-release
+++ b/buildlib/github-release
@@ -6,5 +6,7 @@ if [[ $TRAVIS_TAG == v* ]] && [ "$TRAVIS_OS_NAME" = "linux" ]; then
 	# Let's create release for vX tags only.
 	# Strip the v from the TRAVIS_TAG for our prefix and output items
 	REL_TAG=`echo $TRAVIS_TAG | sed -e 's/^v//'`
-	git archive --prefix rdma-core-$REL_TAG/ --output rdma-core-$REL_TAG.tar.gz $TRAVIS_TAG
+	git archive --prefix rdma-core-$REL_TAG/ --output rdma-core-$REL_TAG.tar $TRAVIS_TAG
+	tar -rf rdma-core-$REL_TAG.tar build-clang/pandoc-prebuilt/ --xform "s|build-clang/pandoc-prebuilt|rdma-core-$REL_TAG/buildlib/pandoc-prebuilt|g"
+	gzip -9 rdma-core-$REL_TAG.tar
 fi
diff --git a/buildlib/pandoc-prebuilt.py b/buildlib/pandoc-prebuilt.py
new file mode 100644
index 00000000000000..c1db6a25a23bad
--- /dev/null
+++ b/buildlib/pandoc-prebuilt.py
@@ -0,0 +1,37 @@
+#!/usr/bin/env python
+import os
+import shutil
+import subprocess
+import sys
+import hashlib
+
+def get_id(SRC):
+    """Return a unique ID for the SRC file. For simplicity and robustness we just
+    content hash it"""
+    with open(SRC,"rb") as F:
+        return hashlib.sha1(F.read()).hexdigest();
+
+def do_retrieve(src_root,SRC):
+    """Retrieve the file from the prebuild cache and write it to DEST"""
+    prebuilt = os.path.join(src_root,"buildlib","pandoc-prebuilt",get_id(SRC))
+    sys.stdout.write(prebuilt);
+
+def do_build(build_root,pandoc,SRC,DEST):
+    """Build the markdown into a man page with pandoc and then keep a copy of the
+    output under build/pandoc-prebuilt"""
+    try:
+        subprocess.check_call([pandoc,"-s","-t","man",SRC,"-o",DEST]);
+    except subprocess.CalledProcessError:
+        sys.exit(100);
+    shutil.copy(DEST,os.path.join(build_root,"pandoc-prebuilt",get_id(SRC)));
+
+# We support python 2.6 so argparse is not available.
+if len(sys.argv) == 4:
+    assert(sys.argv[1] == "--retrieve");
+    do_retrieve(sys.argv[2],sys.argv[3]);
+elif len(sys.argv) == 7:
+    assert(sys.argv[1] == "--build");
+    assert(sys.argv[3] == "--pandoc");
+    do_build(sys.argv[2],sys.argv[4],sys.argv[5],sys.argv[6]);
+else:
+    raise ValueError("Must provide --build or --retrieve");
diff --git a/buildlib/rdma_functions.cmake b/buildlib/rdma_functions.cmake
index 53a978e896acfa..9a2e2ff511d5f2 100644
--- a/buildlib/rdma_functions.cmake
+++ b/buildlib/rdma_functions.cmake
@@ -10,6 +10,16 @@ set(RDMA_STATIC_LIBS "" CACHE INTERNAL "Doc" FORCE)
 set(COMMON_LIBS_PIC ccan_pic rdma_util_pic)
 set(COMMON_LIBS ccan rdma_util)
 
+function(rdma_make_dir DDIR)
+  if(NOT EXISTS "${DDIR}/")
+    execute_process(COMMAND "${CMAKE_COMMAND}" "-E" "make_directory"
+      "${DDIR}" RESULT_VARIABLE retcode)
+    if(NOT "${retcode}" STREQUAL "0")
+      message(FATAL_ERROR "Failed to create directory ${DDIR}")
+    endif()
+  endif()
+endfunction()
+
 # Create a symlink at filename DEST
 # If the directory containing DEST does not exist then it is created
 # automatically.
@@ -26,13 +36,7 @@ function(rdma_create_symlink LINK_CONTENT DEST)
     get_filename_component(DDIR "${DEST}" DIRECTORY)
   endif()
 
-  IF(NOT EXISTS "${DDIR}/")
-    execute_process(COMMAND "${CMAKE_COMMAND}" "-E" "make_directory"
-      "${BUILD_LIB}" RESULT_VARIABLE retcode)
-    if(NOT "${retcode}" STREQUAL "0")
-      message(FATAL_ERROR "Failed to create directory ${DDIR}")
-    endif()
-  endif()
+  rdma_make_dir("${DDIR}")
 
   # Newer versions of cmake can use "${CMAKE_COMMAND}" "-E" "create_symlink"
   # however it is broken weirdly on older versions.
@@ -229,39 +233,6 @@ function(rdma_test_executable EXEC)
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
index 00000000000000..0db455f0cc6029
--- /dev/null
+++ b/buildlib/rdma_man.cmake
@@ -0,0 +1,80 @@
+# COPYRIGHT (c) 2017-2018 Mellanox Technologies Ltd
+# Licensed under BSD (MIT variant) or GPLv2. See COPYING.
+
+rdma_make_dir("${CMAKE_BINARY_DIR}/pandoc-prebuilt")
+add_custom_target("docs" ALL DEPENDS "${OBJ}")
+
+function(rdma_md_man_page SRC MAN_SECT MANFN)
+  set(OBJ "${CMAKE_CURRENT_BINARY_DIR}/${MANFN}")
+
+  if (PANDOC_EXECUTABLE)
+    add_custom_command(
+      OUTPUT "${OBJ}"
+      COMMAND "${PYTHON_EXECUTABLE}" "${CMAKE_SOURCE_DIR}/buildlib/pandoc-prebuilt.py" --build "${CMAKE_BINARY_DIR}" --pandoc "${PANDOC_EXECUTABLE}" "${SRC}" "${OBJ}"
+      MAIN_DEPENDENCY "${SRC}"
+      WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
+      COMMENT "Creating man page ${MANFN}"
+      VERBATIM)
+    add_custom_target("man-${MANFN}" ALL DEPENDS "${OBJ}")
+    add_dependencies("docs" "man-${MANFN}")
+  else()
+    # If pandoc is not installed then we install the man page from the
+    # pre-built cache directory under buildlib. When the release tar file is
+    # made the man pages are pre-built and included. This is done via install
+    # so that ./build.sh never depends on pandoc, only 'ninja install'.
+    execute_process(
+      COMMAND "${PYTHON_EXECUTABLE}" "${CMAKE_SOURCE_DIR}/buildlib/pandoc-prebuilt.py" --retrieve "${CMAKE_SOURCE_DIR}" "${SRC}"
+      WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
+      OUTPUT_VARIABLE OBJ
+      RESULT_VARIABLE retcode)
+    if(NOT "${retcode}" STREQUAL "0")
+      message(FATAL_ERROR "Failed to load prebuilt pandoc output")
+    endif()
+  endif()
+
+  install(FILES "${OBJ}"
+    RENAME "${MANFN}"
+    DESTINATION "${CMAKE_INSTALL_MANDIR}/man${MAN_SECT}/")
+endfunction()
+
+# Install man pages. This deduces the section from the trailing integer in the
+# filename
+function(rdma_man_pages)
+  foreach(I ${ARGN})
+    if ("${I}" MATCHES "\\.md$")
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
index c3b1aadc2da397..e89398f20fa920 100644
--- a/debian/control
+++ b/debian/control
@@ -13,6 +13,7 @@ Build-Depends: cmake (>= 2.8.11),
                libsystemd-dev,
                libudev-dev,
                ninja-build,
+               pandoc,
                pkg-config,
                python,
                valgrind [!alpha !armel !hppa !ia64 !m68k !powerpcspe !sh4 !sparc64 !x32]
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 896849b8679ed3..752bdbb47f9132 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -45,6 +45,11 @@ BuildRequires: make
 %define cmake_install DESTDIR=%{buildroot} make install
 %endif
 
+%if 0%{?fedora} >= 25
+# pandoc was introduced in FC25
+BuildRequires: pandoc
+%endif
+
 %description
 RDMA core userspace infrastructure and documentation, including initialization
 scripts, kernel driver-specific modprobe override configs, IPoIB network
diff --git a/suse/rdma-core.spec b/suse/rdma-core.spec
index 698c15366ca547..64e21e836fb6fc 100644
--- a/suse/rdma-core.spec
+++ b/suse/rdma-core.spec
@@ -51,6 +51,7 @@ Source1:        baselibs.conf
 BuildRequires:  binutils
 BuildRequires:  cmake >= 2.8.11
 BuildRequires:  gcc
+BuildRequires:  pandoc
 BuildRequires:  pkgconfig
 BuildRequires:  pkgconfig(libsystemd)
 BuildRequires:  pkgconfig(libudev)
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
