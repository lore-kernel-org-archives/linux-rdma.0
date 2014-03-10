From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 0/7] SRP initiator patches for kernel 3.15
Date: Mon, 10 Mar 2014 12:39:47 +0100
Message-ID: <531DA483.3010400@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Roland,

Please consider this patch series for kernel 3.15.

Changes compared to v1:
- Added a patch from Sagi Grimberg ("Check ib_query_gid() return
  value").
- Left out a patch to give Dave Dillow a chance to rework it as a SCSI
  core patch ("IB/srp: Fail SCSI commands silently").

These patches are also available at
https://github.com/bvanassche/linux.git; branch srp-initiator. That git
tree is based on
git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git;
branch for-next.

This patch series includes the following seven patches:
0001-scsi_transport_srp-Fix-two-kernel-doc-warnings.patch
0002-IB-srp-Check-ib_query_gid-return-value.patch
0003-IB-srp-Add-more-logging.patch
0004-IB-srp-Avoid-duplicate-connections.patch
0005-IB-srp-Make-writing-into-the-add_target-sysfs-attrib.patch
0006-IB-srp-Avoid-that-writing-into-add_target-hangs-due-.patch
0007-IB-srp-Fix-a-race-condition-between-failing-I-O-and-.patch

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
