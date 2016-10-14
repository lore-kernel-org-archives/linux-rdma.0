From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [bug] build the user-space stack code in github is fail on ubuntu
Date: Fri, 14 Oct 2016 17:41:09 +0800
Message-ID: <5800A835.5020207@huawei.com>
References: <5800A467.2020602@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5800A467.2020602-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sorry, it is my careless.

 it is fail for building rdma-core branch.
 build environment: ubuntu

 is the user-space stack in github not support to ubuntu?

when use cmake build, the bug is as follows:
ubuntu@62fe1357a077:~/rdma_core/rdma-core/build_1$ cmake ..
-- Found PkgConfig: /usr/bin/pkg-config (found version "0.26")
-- checking for modules 'libnl-3.0;libnl-route-3.0'
--   found libnl-3.0, version 3.2.21
--   found libnl-route-3.0, version 3.2.21
-- Check size of long
-- Check size of long - done
-- Looking for rdma/rdma_user_rxe.h
-- Looking for rdma/rdma_user_rxe.h - not found
-- Looking for valgrind/memcheck.h
-- Looking for valgrind/memcheck.h - found
-- Looking for valgrind/drd.h
-- Looking for valgrind/drd.h - found
-- Performing Test LIBC_HAS_LIBRT
-- Performing Test LIBC_HAS_LIBRT - Success
-- Missing Optional Items:
--  rdma/rdma_user_rxe.h NOT found (old system kernel headers)
--  -Wmissing-field-initializers does NOT work
-- Configuring done
-- Generating done
-- Build files have been written to: /home/ubuntu/rdma_core/rdma-core/build_1

 but if i directly use the build.sh, the log as fllows:
 -- The C compiler identification is GNU 4.8.4
 -- Check for working C compiler using: Ninja
 -- Check for working C compiler using: Ninja -- broken
 CMake Error at /usr/share/cmake-2.8/Modules/CMakeTestCCompiler.cmake:61 (message):
   The C compiler "/usr/bin/cc" is not able to compile a simple test program.

   It fails with the following output:

    Change Dir: /home/ubuntu/rdma_core/rdma-core/build/CMakeFiles/CMakeTmp



   Run Build Command:/usr/sbin/ninja cmTryCompileExec2838577708

   log: reading configuration file: cmTryCompileExec2838577708



   die: error: unable to read configuration file



   CMake will not be able to correctly generate this project.
 Call Stack (most recent call first):
   CMakeLists.txt:24 (project)


 -- Configuring incomplete, errors occurred!



在 2016/10/14 17:24, oulijun 写道:
> Hi,leon
> it is fail for building rdma-core branch.
> build environment: ubuntu
> 
> is the user-space stack in github not support to ubuntu?
> 
> ubuntu@62fe1357a077:~/rdma_core/rdma-core$ cd build_1
> ubuntu@62fe1357a077:~/rdma_core/rdma-core/build_1$ cmake ..
> -- The C compiler identification is GNU 4.8.4
> -- Check for working C compiler: /usr/bin/cc
> -- Check for working C compiler: /usr/bin/cc -- works
> -- Detecting C compiler ABI info
> -- Detecting C compiler ABI info - done
> -- Could NOT find PkgConfig (missing:  PKG_CONFIG_EXECUTABLE)
> -- Performing Test SUPPORTS_GNU99
> -- Performing Test SUPPORTS_GNU99 - Success
> -- Performing Test HAVE_C_WARNINGS
> -- Performing Test HAVE_C_WARNINGS - Success
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
> CMake Error at CMakeLists.txt:199 (message):
>   Cannot find libnl-3.0 or libnl-1
> 
> 
> -- Configuring incomplete, errors occurred!
> See also "/home/ubuntu/rdma_core/rdma-core/build_1/CMakeFiles/CMakeOutput.log".
> See also "/home/ubuntu/rdma_core/rdma-core/build_1/CMakeFiles/CMakeError.log".
> ubuntu@62fe1357a077:~/rdma_core/rdma-core/build_1$ sudo apt-get install libnl-3.0
> [sudo] password for ubuntu:
> Reading package lists... Done
> Building dependency tree
> Reading state information... Done
> E: Unable to locate package libnl-3.0
> E: Couldn't find any package by regex 'libnl-3.0'
> ubuntu@62fe1357a077:~/rdma_core/rdma-core/build_1$ sudo apt-get install libnl-1
> Reading package lists... Done
> Building dependency tree
> Reading state information... Done
> E: Unable to locate package libnl-1
> 
> but if i directly use the build.sh, the log as fllows:
> -- The C compiler identification is GNU 4.8.4
> -- Check for working C compiler using: Ninja
> -- Check for working C compiler using: Ninja -- broken
> CMake Error at /usr/share/cmake-2.8/Modules/CMakeTestCCompiler.cmake:61 (message):
>   The C compiler "/usr/bin/cc" is not able to compile a simple test program.
> 
>   It fails with the following output:
> 
>    Change Dir: /home/ubuntu/rdma_core/rdma-core/build/CMakeFiles/CMakeTmp
> 
> 
> 
>   Run Build Command:/usr/sbin/ninja cmTryCompileExec2838577708
> 
>   log: reading configuration file: cmTryCompileExec2838577708
> 
> 
> 
>   die: error: unable to read configuration file
> 
> 
> 
>   CMake will not be able to correctly generate this project.
> Call Stack (most recent call first):
>   CMakeLists.txt:24 (project)
> 
> 
> -- Configuring incomplete, errors occurred!
> 
> _______________________________________________
> linuxarm mailing list
> linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
> http://rnd-openeuler.huawei.com/mailman/listinfo/linuxarm
> 
> .
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
