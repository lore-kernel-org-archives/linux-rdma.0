From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: rdma-core.spec and -DIN_PLACE
Date: Mon, 27 Mar 2017 20:50:01 +0000
Message-ID: <1490647788.7897.5.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Content-ID: <14550F9DF4A30A47863B2A71558CED39-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Jason,

When I build an RPM using the top-level rdma-core.spec file I need the foll=
owing
patch to ensure that the verbs library looks into=A0/etc/libibverbs.d inste=
ad of a
path in the build directory:

diff --git a/rdma-core.spec b/rdma-core.spec
index 6a280fe1..f2419e82 100644
--- a/rdma-core.spec
+++ b/rdma-core.spec
@@ -34,7 +34,7 @@ BuildRequires: ninja,make
=A0# Tumbleweed's cmake RPM macro adds -Wl,--no-undefined to the module fla=
gs
=A0# which is totally inappropriate and breaks building 'ENABLE_EXPORTS' st=
yle
=A0# module libraries (eg ibacmp).
-%define CMAKE_FLAGS -DCMAKE_MODULE_LINKER_FLAGS=3D""
+%define CMAKE_FLAGS -DCMAKE_MODULE_LINKER_FLAGS=3D"" -DIN_PLACE=3D0
=A0%else
=A0%if 0%{?fedora} >=3D 23
=A0# Ninja was introduced in FC23

Do you think this is an issue with the spec file or with one of the CMake f=
iles?

The script I use to build an RPM is as follows:

#!/bin/sh

name=3Drdma-core
version=3D$(sed -n 's/^Version:[[:blank:]]*//p' rdma-core.spec)
rpmtopdir=3D$PWD/rpmbuilddir

rm -rf ${rpmtopdir} &&
=A0=A0=A0=A0mkdir -p ${rpmtopdir}/{BUILD,RPMS,SOURCES,SPECS,SRPMS} &&
=A0=A0=A0=A0git archive --prefix rdma-core-${version}/ --output ${rpmtopdir=
}/SOURCES/${name}-${version}.tgz HEAD &&
=A0=A0=A0=A0rpmbuild --define=3D"%_topdir ${rpmtopdir}" -ba ${name}.spec

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
