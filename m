From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/1] infiniband-diags: add rdma-ndd daemon
Date: Thu, 30 Oct 2014 19:54:29 -0400
Message-ID: <1414713270-12710-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is the follow on patch to the kernel series which changes the default Node
Description to be "<hostname> <device>"

This patch adds support for a "RDMA Node Description Daemon" (rdma-ndd) which
uses the new poll support of the procfs hostname file to monitor for changes to
the hostname and updates the Node Descriptions appropriately.  Both the kernel
changes and the user space daemon are necessary to ensure that the Node
Description in the SMA and SA reflect the hostname/device in all cases if the
device supports traps and the SM either responds to those traps or polls for
the Node Description periodically.  This is true for the following reasons.

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


[PATCH] infiniband-diags: add rdma-ndd daemon
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
