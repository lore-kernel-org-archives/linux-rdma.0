From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 121501] New: [userspace rdma package] after update kernel to
 upstream, rdma service start fail
Date: Wed, 06 Jul 2016 02:37:08 +0000
Message-ID: <bug-121501-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D121501

            Bug ID: 121501
           Summary: [userspace rdma package] after update kernel to
                    upstream, rdma service start fail
           Product: Drivers
           Version: 2.5
    Kernel Version: 4.7
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Infiniband/RDMA
          Assignee: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
          Reporter: yin-jianhong-9Onoh4P/yGk@public.gmane.org
        Regression: No

OS:
   RHEL-7.2

Problem:
   After update kernel to upstream, start rdma fail: these modules (ib_=
mad
ib_sa ib_addr) not find.

Related patch:
 =20
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/d=
rivers/infiniband/core/Makefile?id=3De3f20f02864f6da1509c523bfa1e928619=
e59095


=46ail log:
'''
[root@hp-dl380pgen8-01 ~]# service rdma status
rdma.service - Initialize the iWARP/InfiniBand/RDMA stack in the kernel
   Loaded: loaded (/usr/lib/systemd/system/rdma.service; disabled; vend=
or
preset: disabled)
   Active: failed (Result: exit-code) since =E4=BA=8C 2016-07-05 02:10:=
09 EDT; 6min ago
     Docs: file:/etc/rdma/rdma.conf
  Process: 13564 ExecStart=3D/usr/libexec/rdma-init-kernel (code=3Dexit=
ed,
status=3D3)
 Main PID: 13564 (code=3Dexited, status=3D3)

7=E6=9C=88 05 02:10:08 hp-dl380pgen8-01.khw.lab.eng.bos.redhat.com
rdma-init-kernel[13564]: modprobe: FATAL: Module ib_mad not found.
7=E6=9C=88 05 02:10:08 hp-dl380pgen8-01.khw.lab.eng.bos.redhat.com
rdma-init-kernel[13564]: Failed to load module ib_mad
7=E6=9C=88 05 02:10:08 hp-dl380pgen8-01.khw.lab.eng.bos.redhat.com
rdma-init-kernel[13564]: modprobe: FATAL: Module ib_sa not found.
7=E6=9C=88 05 02:10:08 hp-dl380pgen8-01.khw.lab.eng.bos.redhat.com
rdma-init-kernel[13564]: Failed to load module ib_sa
7=E6=9C=88 05 02:10:08 hp-dl380pgen8-01.khw.lab.eng.bos.redhat.com
rdma-init-kernel[13564]: modprobe: FATAL: Module ib_addr not found.
7=E6=9C=88 05 02:10:08 hp-dl380pgen8-01.khw.lab.eng.bos.redhat.com
rdma-init-kernel[13564]: Failed to load module ib_addr


[root@hp-dl380pgen8-01 ~]# find  /lib/modules/  -name   ib_*.*
/lib/modules/3.10.0-327.el7.x86_64/kernel/drivers/infiniband/core/ib_ad=
dr.ko
/lib/modules/3.10.0-327.el7.x86_64/kernel/drivers/infiniband/core/ib_cm=
=2Eko
/lib/modules/3.10.0-327.el7.x86_64/kernel/drivers/infiniband/core/ib_co=
re.ko
/lib/modules/3.10.0-327.el7.x86_64/kernel/drivers/infiniband/core/ib_ma=
d.ko
/lib/modules/3.10.0-327.el7.x86_64/kernel/drivers/infiniband/core/ib_sa=
=2Eko
/lib/modules/3.10.0-327.el7.x86_64/kernel/drivers/infiniband/core/ib_uc=
m.ko
/lib/modules/3.10.0-327.el7.x86_64/kernel/drivers/infiniband/core/ib_um=
ad.ko
/lib/modules/3.10.0-327.el7.x86_64/kernel/drivers/infiniband/core/ib_uv=
erbs.ko
/lib/modules/3.10.0-327.el7.x86_64/kernel/drivers/infiniband/hw/ipath/i=
b_ipath.ko
/lib/modules/3.10.0-327.el7.x86_64/kernel/drivers/infiniband/hw/mthca/i=
b_mthca.ko
/lib/modules/3.10.0-327.el7.x86_64/kernel/drivers/infiniband/hw/qib/ib_=
qib.ko
/lib/modules/3.10.0-327.el7.x86_64/kernel/drivers/infiniband/ulp/ipoib/=
ib_ipoib.ko
/lib/modules/3.10.0-327.el7.x86_64/kernel/drivers/infiniband/ulp/iser/i=
b_iser.ko
/lib/modules/3.10.0-327.el7.x86_64/kernel/drivers/infiniband/ulp/isert/=
ib_isert.ko
/lib/modules/3.10.0-327.el7.x86_64/kernel/drivers/infiniband/ulp/srp/ib=
_srp.ko
/lib/modules/3.10.0-327.el7.x86_64/kernel/drivers/infiniband/ulp/srpt/i=
b_srpt.ko
/lib/modules/4.7.0-rc6/kernel/drivers/infiniband/core/ib_cm.ko
/lib/modules/4.7.0-rc6/kernel/drivers/infiniband/core/ib_core.ko
/lib/modules/4.7.0-rc6/kernel/drivers/infiniband/core/ib_ucm.ko
/lib/modules/4.7.0-rc6/kernel/drivers/infiniband/core/ib_umad.ko
/lib/modules/4.7.0-rc6/kernel/drivers/infiniband/core/ib_uverbs.ko
/lib/modules/4.7.0-rc6/kernel/drivers/infiniband/hw/mthca/ib_mthca.ko
/lib/modules/4.7.0-rc6/kernel/drivers/infiniband/hw/qib/ib_qib.ko
/lib/modules/4.7.0-rc6/kernel/drivers/infiniband/ulp/ipoib/ib_ipoib.ko
/lib/modules/4.7.0-rc6/kernel/drivers/infiniband/ulp/iser/ib_iser.ko
/lib/modules/4.7.0-rc6/kernel/drivers/infiniband/ulp/isert/ib_isert.ko
/lib/modules/4.7.0-rc6/kernel/drivers/infiniband/ulp/srp/ib_srp.ko
/lib/modules/4.7.0-rc6/kernel/drivers/infiniband/ulp/srpt/ib_srpt.ko
'''

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
