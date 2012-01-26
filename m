From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: [ANNOUNCE]: Released version 2.2 of SCST core, target drivers iSCSI-SCST,
 qla2x00t (QLogic FC), ib_srpt (InfiniBand SRP) and scst_local with scstadmin
 utility and fileio_tgt user space backend handler
Date: Thu, 26 Jan 2012 00:52:16 -0500
Message-ID: <4F20EA10.9070607@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm glad to announce a stable release 2.2 of SCST, alternative SCSI target
stack for Linux with target drivers for iSCSI (iSCSI-SCST), QLogic Fibre Channel
22xx/23xx/24xx/25xx (qla2x00t), InfiniBand SRP (ib_srpt), scst_local as well as
user space scstadmin management utility and fileio_tgt user space backend handler.

SCST allows creation of sophisticated storage devices, which provide advanced
functionality, like replication, thin provisioning, deduplication, high
availability, automatic backup, etc. Another class of such devices are Virtual
Tape Libraries (VTL) as well as other disk-based backup solutions. SCST created
devices not limited by IP network interface only, but they can use any link
supporting SCSI-style data exchange, including Fibre Channel, SAS and parallel
SCSI. It might well be that your favorite storage appliance running SCST in the
firmware.

More info about SCST core and modules you can find on:

   - SCST core: http://scst.sourceforge.net

   - iSCSI target driver iSCSI-SCST: http://iscsi-scst.sourceforge.net/index.html

   - QLogic 22xx/23xx/24xx/25xx Fibre Channel target driver:
http://scst.sourceforge.net/target_qla2x00t.html

   - InfiniBand SRP: http://scst.sourceforge.net/target_srp.html

   - scst_local: http://scst.sourceforge.net/target_local.html

   - fileio_tgt backend handler:
http://scst.sourceforge.net/handler_fileio_tgt.html.

You can download SCST core and modules from
http://scst.sourceforge.net/downloads.html.

Thanks to all who made it happen!

Vlad

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
