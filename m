From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: [ANNOUNCE]: SCST version 2.2.1 released
Date: Tue, 15 Jan 2013 20:15:27 -0500
Message-ID: <50F5FF2F.70206@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

SCST version 2.2.1 has just been released. This release includes SCST core, target 
drivers iSCSI-SCST (iSCSI), qla2x00t (QLogic Fibre Channel), ib_srpt (InfiniBand 
SRP) and scst_local (local loopback-like access) as well as SCST management 
utility scstadmin.

SCST allows creation of sophisticated storage devices, which provide advanced 
functionality, like replication, thin provisioning, deduplication, high 
availability, automatic backup, etc. Another class of such devices are Virtual 
Tape Libraries (VTL) as well as other disk-based backup solutions. SCST created 
devices not limited by network interface only, but they can use any link 
supporting SCSI-style data exchange, like Fibre Channel or SAS. Majority of modern 
SAN appliances, especially higher end ones, are SCST based. It might well be that 
your favorite storage appliance running SCST in the firmware.

More info about SCST and its modules you can find on: http://scst.sourceforge.net

Thanks to all who made it happen, especially Bart Van Assche, who prepared the 
packages!

Vlad

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
