From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: =?UTF-8?Q?=e3=80=90For_help=e3=80=91_configure_crossbar_build_tool_?=
 =?UTF-8?Q?in_CMakelist.txt?=
Date: Tue, 18 Oct 2016 18:55:08 +0800
Message-ID: <5805FF8C.1060902@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi, all

   I am working for debugging userspace code  of hns in rdma-core.git.

  I have met a cmake question now.  please give a help for me.

  if I use crossbar build tool aarch64-linux-gnu-gcc for building the directory(provider/hns),  what i should do it ?

My modification currently according to the others as fllows:

in the file : provider/hns/CMakelist.txt

set(CMAKE_C_COMPILER /opt/gcc-linaro-aarch64-linux-gnu-4.9-2014.09_linux/bin/aarch64-linux-gnu-gcc)

but the modification is fail

-- The C compiler identification is GNU 4.8.4
-- Check for working C compiler using: Ninja
-- Check for working C compiler using: Ninja -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- cmake_share:
-- GNU:
-- BUILD_BIN_DIR:/home/ubuntu/rdma-core/build/bin
-- CMAKE_INSTALL: /usr/local/var/run
-- Found PkgConfig: /usr/bin/pkg-config (found version "0.26")
-- rdma_build: Debug;Release;RelWithDebInfo;MinSizeRel
-- BUILD_INCLUDE_DIR:/home/ubuntu/rdma-core/build/include
-- Performing Test SUPPORTS_GNU99
-- Performing Test SUPPORTS_GNU99 - Success
-- Performing Test HAVE_C_WARNINGS
-- Performing Test HAVE_C_WARNINGS - Success
-- Performing Test HAVE_C_WMISSING_PROTOTYPES
-- Performing Test HAVE_C_WMISSING_PROTOTYPES - Success
-- Performing Test HAVE_C_WMISSING_DECLARATIONS
-- Performing Test HAVE_C_WMISSING_DECLARATIONS - Success
-- Performing Test HAVE_C_WWRITE_STRINGS
-- Performing Test HAVE_C_WWRITE_STRINGS - Success
-- Performing Test HAVE_C_WFORMAT_2
-- Performing Test HAVE_C_WFORMAT_2 - Success
-- Performing Test HAVE_C_WORKING_SHADOW
-- Performing Test HAVE_C_WORKING_SHADOW - Success
-- Performing Test HAVE_C_WORKING_MISSING_FIELD_INITIALIZERS
-- Performing Test HAVE_C_WORKING_MISSING_FIELD_INITIALIZERS - Failed
-- Performing Test HAVE_C_WNO_MISSING_FIELD_INITIALIZERS
-- Performing Test HAVE_C_WNO_MISSING_FIELD_INITIALIZERS - Success
-- Performing Test HAVE_NO_STRICT_ALIASING
-- Performing Test HAVE_NO_STRICT_ALIASING - Success
-- Performing Test HAS_CLOEXEC
-- Performing Test HAS_CLOEXEC - Success
-- Performing Test HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE
-- Performing Test HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE - Success
-- Performing Test SUPPORTS_AS_NEEDED
-- Performing Test SUPPORTS_AS_NEEDED - Success
-- Performing Test SUPPORTS_NO_UNDEFINED
-- Performing Test SUPPORTS_NO_UNDEFINED - Success
-- Performing Test _LDSYMVER_SUCCESS
-- Performing Test _LDSYMVER_SUCCESS - Success
-- Found LDSymVer: GNU
-- Looking for include file pthread.h
-- Looking for include file pthread.h - found
-- Looking for pthread_create
-- Looking for pthread_create - not found
-- Looking for pthread_create in pthreads
-- Looking for pthread_create in pthreads - not found
-- Looking for pthread_create in pthread
-- Looking for pthread_create in pthread - found
-- Found Threads: TRUE
-- checking for modules 'libnl-3.0;libnl-route-3.0'
--   found libnl-3.0, version 3.2.21
--   found libnl-route-3.0, version 3.2.21
-- Performing Test HAVE_WORKING_IF_H
-- Performing Test HAVE_WORKING_IF_H - Failed
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
-- Performing Test HAVE_C_WSTRICT_PROTOTYPES
-- Performing Test HAVE_C_WSTRICT_PROTOTYPES - Success
-- Performing Test HAVE_C_WOLD_STYLE_DEFINITION
-- Performing Test HAVE_C_WOLD_STYLE_DEFINITION - Success
-- Performing Test HAVE_C_WREDUNDANT_DECLS
-- Performing Test HAVE_C_WREDUNDANT_DECLS - Failed
-- c_complier: /opt/gcc-linaro-aarch64-linux-gnu-4.9-2014.09_linux/bin/aarch64-linux-gnu-gcc
-- Missing Optional Items:
--  netlink/route/link.h and net/if.h NOT co-includable (old headers)
--  rdma/rdma_user_rxe.h NOT found (old system kernel headers)
--  -Wmissing-field-initializers does NOT work
--  -Wredundant-decls does NOT work
-- Configuring done
-- Generating done
-- Build files have been written to: /home/ubuntu/rdma-core/build
[115/164] Building C object providers/hns/CMakeFiles/hns-rdmav2.dir/hns_roce_u_hw_v1.c.o
FAILED: /usr/bin/cc  -Dhns_rdmav2_EXPORTS -std=gnu99 -Wall -Wextra -Wno-sign-compare -Wno-unused-parameter -Wmissing-prototypes -Wmissing-declarations -Wwrite-strings -Wformat=2 -Wshadow -Wno-missing-field-initializers -Wstrict-prototypes -Wold-style-definition -O2 -g  -fPIC -Iinclude -I/usr/include/libnl3 -MMD -MT providers/hns/CMakeFiles/hns-rdmav2.dir/hns_roce_u_hw_v1.c.o -MF "providers/hns/CMakeFiles/hns-rdmav2.dir/hns_roce_u_hw_v1.c.o.d" -o providers/hns/CMakeFiles/hns-rdmav2.dir/hns_roce_u_hw_v1.c.o -c ../providers/hns/hns_roce_u_hw_v1.c
../providers/hns/hns_roce_u_hw_v1.c: Assembler messages:
../providers/hns/hns_roce_u_hw_v1.c:830: Error: number of operands mismatch for `ds'
../providers/hns/hns_roce_u_hw_v1.c:264: Error: number of operands mismatch for `ds'
../providers/hns/hns_roce_u_hw_v1.c:413: Error: number of operands mismatch for `ds'
../providers/hns/hns_roce_u_hw_v1.c:586: Error: number of operands mismatch for `ds'
../providers/hns/hns_roce_u_hw_v1.c:630: Error: number of operands mismatch for `ds'
[115/164] Building C object ibacm/CMakeFiles/ibacm.dir/src/acm.c.o
ninja: build stopped: subcommand failed.



.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
