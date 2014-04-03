From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: debug sometimes slow performance
Date: Thu, 3 Apr 2014 18:20:01 +0400
Message-ID: <CACaajQsRgCN_09_yfFq2Z3ahC1G=+K__1E1gFq1VwVE9jbE9_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all. I'm very happy with using srpt disk via ib_srp (linux 3.10).
Storage used by virtual machines (xen), target side (2 servers):
Software raid 10 with lvm on top of it.
scst.conf:
HANDLER vdisk_fileio {
        DEVICE sas00_md127 {
                filename /dev/md127
                nv_cache 1
        }
}

TARGET_DRIVER ib_srpt {
        TARGET ib_srpt_target_0 {
                enabled 1
                io_grouping_type this_group_only
                rel_tgt_id 1

                LUN 0 sas00_md127
        }
}

LVM (pv /dev/md127) exported to initiator node (xen).

On initiator node from both servers disks are goes to multipath.
On this pv i have many lv for each virtual machine.
For each vps i'm assemble raid1 from 2 lv (lv from different target nodes).

Sometimes all works fine, sometimes not. Which sysfs/procfs entries i
can check on initiator and target side to determine bottleneck? I'm
try to run blktrace to md device provide for vps, but not get needed
info.

Linux 3.10
SCST v3.0.0-pre2 (svn 4973)
Debian 7

Can somebody helps me?

-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
