From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/6] Make Node Description default to "<hostname> <device>"
Date: Thu, 30 Oct 2014 19:50:15 -0400
Message-ID: <1414713021-12175-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following series defines a new mad core function to support Node
Description processing which supports format specifiers.  The first 2 format
specifiers are "%h" and "%d" for hostname and device respectively.

It also changes the default Node Description of all the devices which support
Node Description in software to use "%h %d" by default which translates into
<hostname> <device>.

Note that the sysfs node_desc file for devices now reflects the format specifier
and not the actual remapped Node Description.  This allows userspace to detect
the current format used and change it as needed.

Devices which store the Node Description in FW have a translated version
written to FW while maintaining the format specifier string in memory.

This work is a continuation of the following thread and the work done by Mike
Heinz:

http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg07329.html

A follow on patch to the infiniband-diags package adds support for a "RDMA Node
Description Daemon" (rdma-ndd) which uses the new poll support of the procfs
hostname file to monitor for changes to the hostname and updates the Node
Descriptions appropriately.  Both the kernel changes and the user space daemon
are necessary to ensure that the Node Description in the SMA and SA reflect
the hostname/device in all cases if the device supports traps and the SM
either responds to those traps or polls for the Node Description periodically.
This is true for the following reasons.

	1) No matter when the drivers are loaded they will return
	   "<hostname> <device>" to the SM when initially queried.
	2) If the hostname is not set when the driver is loaded (as is
	   likely at boot) subsequent sets of hostname (from any source
	   including dhclient) will trigger the daemon to update all node
	   descriptions.  The use of dhclient hooks is not sufficient to handle
	   user invoked hostname changes.
	3) If the daemon is started after the hostname has changed it starts by
	   writing the hostname to the Node Descriptions sysfs files which will
	   trigger the devices to send a trap to the SM.

Thus the drivers, any automated set of the hostname (such as DHCP), and the
rdma-ndd daemon can be started in any order and the SMA will reflect the
hostname properly.


[PATCH 1/6] ib/mad: Add function to support format specifiers for node description
[PATCH 2/6] ib/ipath: change default node description processing
[PATCH 3/6] ib/mlx4: change default node description processing
[PATCH 4/6] ib/mthca: change default node description processing
[PATCH 5/6] ib/qib: change default node description processing
[PATCH 6/6] ib/mlx5: change default node description processing
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
