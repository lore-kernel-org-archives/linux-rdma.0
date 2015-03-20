From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.1.4-1 release
Date: Fri, 20 Mar 2015 17:16:23 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F977D40215@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Vladimir Sokolovsky (vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Rupert Dance (rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org)" <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New release for uDAPL (2.1.4) is available at http://www.openfabrics.org/downloads/dapl

Vlad, please pull into OFED 3.18 RC2

md5sum: d20bd85bc71c2f3391fb4c8d61e4e62d dapl-2.1.4.tar.gz

For v2.1 package install RPM packages as follow:

dapl-2.1.4-1
dapl-utils-2.1.4-1
dapl-devel-2.1.4-1
dapl-debuginfo-2.1.4-1

Summary of changes:

Release 2.1.4 (targeting OFED 3.18)
mpxyd: fix typo in configuration file
cma: RR attributes moved to common ib_cm struct
mpxyd: tx thread incorrectly sleeps with negative pi_rw_cnt value
dat.conf: add entries for True Scale qib device
mpxyd: add support for devices without inline data support
ucm: long disconnect times with many-to-one applications
openib: add inline data support check during device open
cleanup ib/cm attribute management across openib providers
dapltest: fix -Werror=format-security issue with printf

Release commit:  http://git.openfabrics.org/?p=~ardavis/dapl.git;a=commit;h=3d0f53bd26db0c2c5261740d8fefc6e03209996a

Regards,

Arlin

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
