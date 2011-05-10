From: bhavinkumar thumar <bhawinkumar.thumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Building and Installing SDP on existing OFED 1.5.2 install
Date: Tue, 10 May 2011 15:27:19 +0530
Message-ID: <BANLkTikPnWHUzu0QvicW3wQwej+Qy3rrsw@mail.gmail.com>
References: <BANLkTimvikSV-B5503wNBBumB2D274m=vQ@mail.gmail.com>
	<BANLkTimdZUhQwnCa75ph7_czbunYCUuF2g@mail.gmail.com>
	<BANLkTinBMiinjMiFj20xYzprFWnaft5zgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTinBMiinjMiFj20xYzprFWnaft5zgA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey,

Now it's working! I just cleaned up everything and started with fresh
installation. Thanks a lot for pointing me /etc/infiniband/info file.

Thanks,
Bhavin

On Tue, May 10, 2011 at 10:55 AM, bhavinkumar thumar
<bhawinkumar.thumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Thanks a lot for replying.
>
> I followed your suggestion and issued configure command as follows:
>
> #./configure --with-core-mod --with-user_mad-mod
> --with-user_access-mod --with-addr_trans-mod --with-mthca-mod
> --with-mlx4-mod --with-mlx4_en-mod --with-mlx4_ib-mod
> --with-mlx4_vnic-mod --with-mlx4_fc-mod --with-qib-mod
> --with-cxgb3-mod --with-nes-mod --with-ipoib-mod --with-sdp-mod
> --with-srp-mod --with-rds-mod
>
> /etc/infiniband/info:-
> #!/bin/bash
>
> echo prefix=3D/usr
> echo Kernel=3D2.6.18-194.el5
> echo
> echo "Configure options: --with-core-mod --with-user_mad-mod
> --with-user_access-mod --with-addr_trans-mod --with-mthca-mod
> --with-mlx4-mod --with-mlx4_en-mod --with-mlx4_ib-mod
> --with-mlx4_vnic-mod --with-mlx4_fc-mod --with-qib-mod
> --with-cxgb3-mod --with-nes-mod --with-ipoib-mod --with-sdp-mod
> --with-srp-mod --with-rds-mod"
> echo
>
>
> #make
> =A0- Succeed (make[1]: Leaving directory `/usr/src/kernels/2.6.18-194=
=2Eel5-x86_64')
>
> #make install
>
> Installing kernel modules
> make -C /lib/modules/2.6.18-194.el5/build
> SUBDIRS=3D"/usr/src/redhat/SOURCES/ofa_kernel-1.5.2" \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0INSTALL_MOD_PATH=3D/usr/src/redhat/SOU=
RCES/ofa_kernel-1.5.2 \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 modules_install;
> make[1]: Entering directory `/usr/src/kernels/2.6.18-194.el5-x86_64'
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniban=
d/core/ib_addr.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniban=
d/core/ib_cm.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniban=
d/core/ib_core.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniban=
d/core/ib_mad.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniban=
d/core/ib_sa.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniban=
d/core/ib_ucm.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniban=
d/core/ib_umad.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniban=
d/core/ib_uverbs.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniban=
d/core/iw_cm.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniban=
d/core/rdma_cm.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniban=
d/core/rdma_ucm.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniban=
d/hw/cxgb3/iw_cxgb3.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniban=
d/hw/cxgb3/rdma_krping.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniban=
d/hw/mlx4/mlx4_ib.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniban=
d/hw/mthca/ib_mthca.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniban=
d/hw/nes/iw_nes.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniban=
d/hw/qib/ib_qib.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniban=
d/ulp/ipoib/ib_ipoib.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniban=
d/ulp/ipoib/ipoib_helper.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniban=
d/ulp/sdp/ib_sdp.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniban=
d/ulp/srp/ib_srp.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/net/cxgb3=
/cxgb3.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/net/mlx4/=
mlx4_core.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/net/mlx4/=
mlx4_en.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/net/rds/rds.ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/net/rds/rds_rdma.=
ko
> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/net/rds/rds_tcp.k=
o
> =A0DEPMOD =A02.6.18-194.el5
> make[1]: Leaving directory `/usr/src/kernels/2.6.18-194.el5-x86_64'
> # Copy new cxgb3 kernel module to
> //lib/modules/2.6.18-194.el5/updates/kernel/drivers/net/cxgb3
> if [ -d /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/lib/modules/2.6.18-1=
94.el5/drivers/net/cxgb3
> ]; then \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mkdir -p //lib/modules/2.6.18-194.el5/=
updates/kernel/drivers/net/cxgb3; \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv /usr/src/redhat/SOURCES/ofa_kernel-=
1.5.2/lib/modules/2.6.18-194.el5/drivers/net/cxgb3/cxgb3.ko
> //lib/modules/2.6.18-194.el5/updates/kernel/drivers/net/cxgb3; \
> =A0 =A0 =A0 =A0fi; \
> =A0 =A0 =A0 =A0if [ -d /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/lib/m=
odules/2.6.18-194.el5/extra/drivers/net/cxgb3
> ]; then \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mkdir -p //lib/modules/2.6.18-194.el5/=
updates/kernel/drivers/net/cxgb3; \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv /usr/src/redhat/SOURCES/ofa_kernel-=
1.5.2/lib/modules/2.6.18-194.el5/extra/drivers/net/cxgb3/cxgb3.ko
> //lib/modules/2.6.18-194.el5/updates/kernel/drivers/net/cxgb3/ ; \
> =A0 =A0 =A0 =A0elif [ -d /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/lib=
/modules/2.6.18-194.el5/extra
> ]; then \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mkdir -p //lib/modules/2.6.18-194.el5/=
updates/kernel/drivers/net/cxgb3; \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv /usr/src/redhat/SOURCES/ofa_kernel-=
1.5.2/lib/modules/2.6.18-194.el5/extra/cxgb3.ko
> //lib/modules/2.6.18-194.el5/updates/kernel/drivers/net/cxgb3/ ; \
> =A0 =A0 =A0 =A0fi;
> if [ ! -n "" ]; then /sbin/depmod -r -ae 2.6.18-194.el5;fi;
> WARNING: Can't read module
> /lib/modules/2.6.18-194.el5/weak-updates/kmod-kvm/kvm.ko: No such fil=
e
> or directory
> WARNING: Can't read module
> /lib/modules/2.6.18-194.el5/weak-updates/kmod-kvm/kvm-amd.ko: No such
> file or directory
> WARNING: Can't read module
> /lib/modules/2.6.18-194.el5/weak-updates/kmod-kvm/ksm.ko: No such fil=
e
> or directory
> WARNING: Can't read module
> /lib/modules/2.6.18-194.el5/weak-updates/kmod-kvm/kvm-intel.ko: No
> such file or directory
> # Copy new rds kernel module to
> //lib/modules/2.6.18-194.el5/updates/kernel/drivers/net/rds
> if [ -d /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/lib/modules/2.6.18-1=
94.el5/kernel/net/rds
> ]; then \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mkdir -p //lib/modules/2.6.18-194.el5/=
updates/kernel/net/rds; \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv /usr/src/redhat/SOURCES/ofa_kernel-=
1.5.2/lib/modules/2.6.18-194.el5/kernel/net/rds/rds*.ko
> //lib/modules/2.6.18-194.el5/updates/kernel/net/rds; \
> =A0 =A0 =A0 =A0fi; \
> =A0 =A0 =A0 =A0if [ -d /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/lib/m=
odules/2.6.18-194.el5/extra/net/rds
> ]; then \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mkdir -p //lib/modules/2.6.18-194.el5/=
updates/kernel/net/rds; \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv /usr/src/redhat/SOURCES/ofa_kernel-=
1.5.2/lib/modules/2.6.18-194.el5/extra/net/rds/rds*.ko
> //lib/modules/2.6.18-194.el5/updates/kernel/net/rds/ ; \
> =A0 =A0 =A0 =A0elif [ -d /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/lib=
/modules/2.6.18-194.el5/extra
> ]; then \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mkdir -p //lib/modules/2.6.18-194.el5/=
updates/kernel/net/rds; \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv /usr/src/redhat/SOURCES/ofa_kernel-=
1.5.2/lib/modules/2.6.18-194.el5/extra/rds*.ko
> //lib/modules/2.6.18-194.el5/updates/kernel/net/rds/ ; \
> =A0 =A0 =A0 =A0fi;
> if [ ! -n "" ]; then /sbin/depmod -r -ae 2.6.18-194.el5;fi;
> WARNING: Can't read module
> /lib/modules/2.6.18-194.el5/weak-updates/kmod-kvm/kvm.ko: No such fil=
e
> or directory
> WARNING: Can't read module
> /lib/modules/2.6.18-194.el5/weak-updates/kmod-kvm/kvm-amd.ko: No such
> file or directory
> WARNING: Can't read module
> /lib/modules/2.6.18-194.el5/weak-updates/kmod-kvm/ksm.ko: No such fil=
e
> or directory
> WARNING: Can't read module
> /lib/modules/2.6.18-194.el5/weak-updates/kmod-kvm/kvm-intel.ko: No
> such file or directory
> # Copy new mlx4 kernel module to
> //lib/modules/2.6.18-194.el5/updates/kernel/drivers/net/mlx4
> if [ -d /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/lib/modules/2.6.18-1=
94.el5/drivers/net/mlx4
> ]; then \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mkdir -p //lib/modules/2.6.18-194.el5/=
updates/kernel/drivers/net/mlx4; \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv /usr/src/redhat/SOURCES/ofa_kernel-=
1.5.2/lib/modules/2.6.18-194.el5/drivers/net/mlx4/mlx4*.ko
> //lib/modules/2.6.18-194.el5/updates/kernel/drivers/net/mlx4; \
> =A0 =A0 =A0 =A0fi; \
> =A0 =A0 =A0 =A0if [ -d /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/lib/m=
odules/2.6.18-194.el5/extra/drivers/net/mlx4
> ]; then \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mkdir -p //lib/modules/2.6.18-194.el5/=
updates/kernel/drivers/net/mlx4; \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv /usr/src/redhat/SOURCES/ofa_kernel-=
1.5.2/lib/modules/2.6.18-194.el5/extra/drivers/net/mlx4/mlx4*.ko
> //lib/modules/2.6.18-194.el5/updates/kernel/drivers/net/mlx4/ ; \
> =A0 =A0 =A0 =A0elif [ -d /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/lib=
/modules/2.6.18-194.el5/extra
> ]; then \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mkdir -p //lib/modules/2.6.18-194.el5/=
updates/kernel/drivers/net/mlx4; \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv /usr/src/redhat/SOURCES/ofa_kernel-=
1.5.2/lib/modules/2.6.18-194.el5/extra/mlx4*.ko
> //lib/modules/2.6.18-194.el5/updates/kernel/drivers/net/mlx4/ ; \
> =A0 =A0 =A0 =A0fi;
> if [ ! -n "" ]; then /sbin/depmod -r -ae 2.6.18-194.el5;fi;
> WARNING: Can't read module
> /lib/modules/2.6.18-194.el5/weak-updates/kmod-kvm/kvm.ko: No such fil=
e
> or directory
> WARNING: Can't read module
> /lib/modules/2.6.18-194.el5/weak-updates/kmod-kvm/kvm-amd.ko: No such
> file or directory
> WARNING: Can't read module
> /lib/modules/2.6.18-194.el5/weak-updates/kmod-kvm/ksm.ko: No such fil=
e
> or directory
> WARNING: Can't read module
> /lib/modules/2.6.18-194.el5/weak-updates/kmod-kvm/kvm-intel.ko: No
> such file or directory
> # Copy new infiniband kernel modules to
> //lib/modules/2.6.18-194.el5/updates/kernel/drivers/infiniband
> if [ -d /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/lib/modules/2.6.18-1=
94.el5/infiniband
> ]; then \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/bin/rm -rf //lib/modules/2.6.18-194.e=
l5/updates/kernel/drivers/infiniband; \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mkdir -p //lib/modules/2.6.18-194.el5/=
updates/kernel/drivers; \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv /usr/src/redhat/SOURCES/ofa_kernel-=
1.5.2/lib/modules/2.6.18-194.el5/infiniband
> //lib/modules/2.6.18-194.el5/updates/kernel/drivers/; \
> =A0 =A0 =A0 =A0fi;
> if [ -d /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/lib/modules/2.6.18-1=
94.el5/extra/drivers/infiniband
> ]; then \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/bin/rm -rf //lib/modules/2.6.18-194.e=
l5/updates/kernel/drivers/infiniband; \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mkdir -p //lib/modules/2.6.18-194.el5/=
updates/kernel/drivers; \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv /usr/src/redhat/SOURCES/ofa_kernel-=
1.5.2/lib/modules/2.6.18-194.el5/extra/drivers/infiniband
> //lib/modules/2.6.18-194.el5/updates/kernel/drivers/; \
> =A0 =A0 =A0 =A0elif [ -d /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/lib=
/modules/2.6.18-194.el5/extra
> ]; then \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/bin/rm -rf //lib/modules/2.6.18-194.e=
l5/updates/kernel/drivers/infiniband; \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mkdir -p //lib/modules/2.6.18-194.el5/=
updates/kernel/drivers; \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv /usr/src/redhat/SOURCES/ofa_kernel-=
1.5.2/lib/modules/2.6.18-194.el5/extra
> //lib/modules/2.6.18-194.el5/updates/kernel/drivers/infiniband; \
> =A0 =A0 =A0 =A0fi;
> if [ ! -n "" ]; then /sbin/depmod -r -ae 2.6.18-194.el5;fi;
> WARNING: Can't read module
> /lib/modules/2.6.18-194.el5/weak-updates/kmod-kvm/kvm.ko: No such fil=
e
> or directory
> WARNING: Can't read module
> /lib/modules/2.6.18-194.el5/weak-updates/kmod-kvm/kvm-amd.ko: No such
> file or directory
> WARNING: Can't read module
> /lib/modules/2.6.18-194.el5/weak-updates/kmod-kvm/ksm.ko: No such fil=
e
> or directory
> WARNING: Can't read module
> /lib/modules/2.6.18-194.el5/weak-updates/kmod-kvm/kvm-intel.ko: No
> such file or directory
>
>
> #modprobe ib_sdp
> FATAL: Error inserting ib_sdp
> (/lib/modules/2.6.18-194.el5/updates/kernel/drivers/infiniband/ulp/sd=
p/ib_sdp.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
>
>
> #dmesg
> .........................................
>
> mtrr: no more MTRRs available
> mtrr: no more MTRRs available
> mtrr: no more MTRRs available
> mtrr: no more MTRRs available
> mtrr: no more MTRRs available
> mtrr: no more MTRRs available
> mtrr: no more MTRRs available
> mtrr: no more MTRRs available
> ib_sdp: Unknown symbol ib_umem_release
> ib_sdp: Unknown symbol rdma_resolve_addr
> ib_sdp: Unknown symbol rdma_reject
> ib_sdp: Unknown symbol rdma_disconnect
> ib_sdp: Unknown symbol rdma_resolve_route
> ib_sdp: Unknown symbol rdma_bind_addr
> ib_sdp: Unknown symbol rdma_create_qp
> ib_sdp: Unknown symbol rdma_create_id
> ib_sdp: Unknown symbol ib_umem_get
> ib_sdp: Unknown symbol rdma_notify
> ib_sdp: Unknown symbol rdma_listen
> ib_sdp: Unknown symbol rdma_connect
> ib_sdp: Unknown symbol rdma_destroy_id
> ib_sdp: Unknown symbol rdma_accept
> ib_sdp: Unknown symbol ib_umem_release
> ib_sdp: Unknown symbol rdma_resolve_addr
> ib_sdp: Unknown symbol rdma_reject
> ib_sdp: Unknown symbol rdma_disconnect
> ib_sdp: Unknown symbol rdma_resolve_route
> ib_sdp: Unknown symbol rdma_bind_addr
> ib_sdp: Unknown symbol rdma_create_qp
> ib_sdp: Unknown symbol rdma_create_id
> ib_sdp: Unknown symbol ib_umem_get
> ib_sdp: Unknown symbol rdma_notify
> ib_sdp: Unknown symbol rdma_listen
> ib_sdp: Unknown symbol rdma_connect
> ib_sdp: Unknown symbol rdma_destroy_id
> ib_sdp: Unknown symbol rdma_accept
> ib_sdp: Unknown symbol ib_umem_release
> ib_sdp: Unknown symbol ib_umem_get
> ib_sdp: Unknown symbol ib_umem_release
> ib_sdp: Unknown symbol ib_umem_get
>
>
>
> Please provide me further inputs.
>
>
> Thanks,
> Bhavin
>
> On Tue, May 10, 2011 at 10:30 AM, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8@public.gmane.org=
m> wrote:
>> Not sure whether anyone replied ... Look like at least one of the
>> kernel modules is missing (from the new install) - implying the
>> "configure" command issued did not have a complete list of the
>> required module names. Did you check . =A0/etc/infiniband/info ? You=
r
>> "configure" should match with what is displayed by the info file. .
>>
>> .. Wendy
>>
>>
>> On Mon, May 9, 2011 at 1:22 AM, bhavinkumar thumar
>> <bhawinkumar.thumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> Hi,
>>>
>>> I have downloaded the OFED 1.5.2 tar file and then installed RPM
>>> source files to /usr/src/redhat/SOURCES. Now I changed some portion=
 of
>>> sdp_main.c and then I performed following steps.
>>>
>>> #cd /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/
>>>
>>> #./configure --with-core-mod --with-ipoib-mod --with-mthca-mod
>>> --with-mlx4_core-mod --with-mlx4_inf-mod --with-sdp-mod
>>> --with-sdp_debug-mod
>>> - Succeed
>>>
>>> #make
>>> - Succeed
>>>
>>> #make install
>>> - Succeed
>>>
>>> make[1]: Entering directory `/usr/src/kernels/2.6.18-194.el5-x86_64=
'
>>> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infinib=
and/core/ib_cm.ko
>>> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infinib=
and/core/ib_core.ko
>>> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infinib=
and/core/ib_mad.ko
>>> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infinib=
and/core/ib_sa.ko
>>> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infinib=
and/core/iw_cm.ko
>>> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infinib=
and/hw/mlx4/mlx4_ib.ko
>>> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infinib=
and/hw/mthca/ib_mthca.ko
>>> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infinib=
and/ulp/ipoib/ib_ipoib.ko
>>> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infinib=
and/ulp/ipoib/ipoib_helper.ko
>>> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infinib=
and/ulp/sdp/ib_sdp.ko
>>> =A0INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/net/mlx=
4/mlx4_core.ko
>>> =A0DEPMOD =A02.6.18-194.el5
>>>
>>> #modprobe ib_sdp
>>> - FATAL: Error inserting ib_sdp
>>> (/lib/modules/2.6.18-194.el5/updates/kernel/drivers/infiniband/ulp/=
sdp/ib_sdp.ko):
>>> Unknown symbol in module, or unknown parameter (see dmesg)
>>>
>>> #dmesg
>>> mtrr: no more MTRRs available
>>> mtrr: no more MTRRs available
>>> mtrr: no more MTRRs available
>>> mtrr: no more MTRRs available
>>> mtrr: no more MTRRs available
>>> mtrr: no more MTRRs available
>>> mtrr: no more MTRRs available
>>> mtrr: no more MTRRs available
>>> rdma_cm: disagrees about version of symbol ib_send_cm_sidr_req
>>> rdma_cm: Unknown symbol ib_send_cm_sidr_req
>>> rdma_cm: disagrees about version of symbol iw_create_cm_id
>>> rdma_cm: Unknown symbol iw_create_cm_id
>>> rdma_cm: disagrees about version of symbol ib_unregister_client
>>> rdma_cm: Unknown symbol ib_unregister_client
>>> rdma_cm: disagrees about version of symbol ib_send_cm_sidr_rep
>>> rdma_cm: Unknown symbol ib_send_cm_sidr_rep
>>> rdma_cm: disagrees about version of symbol ib_cm_listen
>>> rdma_cm: Unknown symbol ib_cm_listen
>>> rdma_cm: disagrees about version of symbol ib_destroy_cm_id
>>> rdma_cm: Unknown symbol ib_destroy_cm_id
>>> rdma_cm: disagrees about version of symbol ib_find_cached_pkey
>>> rdma_cm: Unknown symbol ib_find_cached_pkey
>>> rdma_cm: disagrees about version of symbol iw_cm_connect
>>> rdma_cm: Unknown symbol iw_cm_connect
>>> rdma_cm: disagrees about version of symbol ib_cm_notify
>>> rdma_cm: Unknown symbol ib_cm_notify
>>> rdma_cm: disagrees about version of symbol ib_detach_mcast
>>> rdma_cm: Unknown symbol ib_detach_mcast
>>> rdma_cm: disagrees about version of symbol ib_sa_get_mcmember_rec
>>> rdma_cm: Unknown symbol ib_sa_get_mcmember_rec
>>> rdma_cm: disagrees about version of symbol ib_sa_cancel_query
>>> rdma_cm: Unknown symbol ib_sa_cancel_query
>>> rdma_cm: disagrees about version of symbol ib_register_client
>>> rdma_cm: Unknown symbol ib_register_client
>>> rdma_cm: disagrees about version of symbol ib_sa_path_rec_get
>>> rdma_cm: Unknown symbol ib_sa_path_rec_get
>>> rdma_cm: disagrees about version of symbol ib_create_cm_id
>>> rdma_cm: Unknown symbol ib_create_cm_id
>>>
>>> ................................................
>>>
>>> rdma_cm: disagrees about version of symbol ib_init_ah_from_path
>>> rdma_cm: Unknown symbol ib_init_ah_from_path
>>> rdma_cm: disagrees about version of symbol ib_destroy_qp
>>> rdma_cm: Unknown symbol ib_destroy_qp
>>> rdma_cm: disagrees about version of symbol iw_cm_init_qp_attr
>>> rdma_cm: Unknown symbol iw_cm_init_qp_attr
>>> rdma_cm: disagrees about version of symbol ib_send_cm_rtu
>>> rdma_cm: Unknown symbol ib_send_cm_rtu
>>> rdma_cm: disagrees about version of symbol ib_send_cm_dreq
>>> rdma_cm: Unknown symbol ib_send_cm_dreq
>>> rdma_cm: disagrees about version of symbol ib_send_cm_req
>>> rdma_cm: Unknown symbol ib_send_cm_req
>>> rdma_cm: disagrees about version of symbol ib_sa_join_multicast
>>> rdma_cm: Unknown symbol ib_sa_join_multicast
>>> rdma_cm: disagrees about version of symbol ib_attach_mcast
>>> rdma_cm: Unknown symbol ib_attach_mcast
>>> rdma_cm: disagrees about version of symbol ib_find_cached_gid
>>> rdma_cm: Unknown symbol ib_find_cached_gid
>>> rdma_cm: disagrees about version of symbol iw_cm_listen
>>> rdma_cm: Unknown symbol iw_cm_listen
>>> rdma_cm: disagrees about version of symbol ib_send_cm_rej
>>> rdma_cm: Unknown symbol ib_send_cm_rej
>>>
>>>
>>> can anyone tell me what's wrong? Please help me.
>>>
>>>
>>> Thanking You,
>>> Bhavin
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdm=
a" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
