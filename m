From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: rdma-core make install failing
Date: Thu, 23 Feb 2017 18:00:09 -0500
Message-ID: <20170223230008.GA546@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'm not sure what I'm doing wrong but make install seems to be deleting a
library and then complaining that it can't find it for installation...  :-/

After running build.sh I ran make install and get this error:

-- Up-to-date:
/nfs/site/home/iweiny/rdma-core/build/etc/libibverbs.d/cxgb3.driver
CMake Error at providers/cxgb3/cmake_install.cmake:62 (FILE):
  file INSTALL cannot find
    "/nfs/site/home/iweiny/rdma-core/build/lib/libcxgb3-rdmav2.so".
Call Stack (most recent call first):
  cmake_install.cmake:47 (INCLUDE)

make: *** [install] Error 1


While trying to figure out why cxgb3 was not building I noticed that actually
build.sh _is_ building the library.  And more importantly rebuilds it after
running make install as per below...


17:51:49 > ./build.sh 
-- Missing Optional Items:
--  C11 stdatomic.h NOT available (old compiler)
--  netlink/route/link.h and net/if.h NOT co-includable (old headers)
--  rdma/rdma_netlink.h NOT found (old system kernel headers)
--  rdma/rdma_user_cm.h NOT found (old system kernel headers)
--  rdma/rdma_user_rxe.h NOT found (old system kernel headers)
--  rdma/vmw_pvrdma-abi.h NOT found (old system kernel headers)
--  -Wmissing-field-initializers does NOT work
--  -Wredundant-decls does NOT work
-- Configuring done
-- Generating done
-- Build files have been written to: /nfs/site/home/iweiny/rdma-core/build
[  1%] Built target ccan
[  3%] Built target ccan_pic
[  6%] Built target ibumad
[ 14%] Built target ibverbs
[ 18%] Built target rdmacm
[ 20%] Built target rspreload
[ 21%] Built target ibcm
Linking C shared module ../../lib/libcxgb3-rdmav2.so
[ 24%] Built target cxgb3-rdmav2
[ 27%] Built target cxgb4-rdmav2
...



So checking for it...  yea there it is...

17:51:54 > ll build/lib/*cx*
-rwxr-x--- 1 iweiny intelall 138157 Feb 23 17:51 build/lib/libcxgb3-rdmav2.so*
-rwxr-x--- 1 iweiny intelall 184172 Feb 23 16:22 build/lib/libcxgb4-rdmav2.so*


Then I run make install again...

It fails as above and I look for the library and it is gone...

17:54:19 > ll lib/*cx*
-rwxr-x--- 1 iweiny intelall 184172 Feb 23 16:22 lib/libcxgb4-rdmav2.so*


What is going on here?

I'm really not familiar enough with cmake to see what majic softlink vs real
library installation is supposed to be going on here.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
