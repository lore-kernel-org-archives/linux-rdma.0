From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Odd build failure in el7 mock
Date: Wed, 22 Mar 2017 11:44:49 -0400
Message-ID: <16cf8400-4920-c7ae-e0e5-c77a65a71460@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm attempting to build rdma-core v13 rpms... On my el7 host, they build 
just fine. But when I try to build them in mock (using the epel-7-x86_64 
target), I hit this:

-- Removed runtime path from 
"/builddir/build/BUILDROOT/rdma-core-13-1.el7.centos.x86_64/usr/lib64/libmlx5.so.1.0.13"
CMake Error at providers/mlx5/cmake_install.cmake:98 (FILE):
   file INSTALL cannot find
   "/builddir/build/BUILD/rdma-core-13/providers/mlx5/libmlx5-rdmav2.so".
Call Stack (most recent call first):
   cmake_install.cmake:52 (INCLUDE)


make: *** [install] Error 1
error: Bad exit status from /var/tmp/rpm-tmp.MsCuJ7 (%install)


RPM build errors:
     Bad exit status from /var/tmp/rpm-tmp.MsCuJ7 (%install)
ERROR: Exception(rdma-core-13-1.el7.src.rpm) Config(epel-7-x86_64) 0 
minutes 53 seconds
INFO: Results and/or logs in: /var/lib/mock/epel-7-x86_64/result
ERROR: Command failed. See logs for output.
  # bash --login -c /usr/bin/rpmbuild -bb --target x86_64 --nodeps 
/builddir/build/SPECS/rdma-core.spec

Just starting to dig into it, but if anyone has an "aha, that's XYZ", 
that might save me some time and effort. :)

(I get this with both rdma-core.spec and redhat/rdma-core.spec, btw)

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
