From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 0/10] Performance Manager cleanups.
Date: Tue, 3 Jul 2012 16:52:19 -0700
Message-ID: <20120703165219.5db9288a.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following 10 patches fix a couple of bugs and add some console options
which make it easier to see the internal data of the performance manager.

	0001-opensm-perfmgr-Add-config-option-to-ignore-Channel-A.patch
	0002-opensm-console-protect-against-0-entered-for-the-per.patch
	0003-opensm-perfmgr-fix-dump_counters.patch
	0004-opensm-perfmgr-delete-inactive-nodes-from-the-DB.patch
	0005-opensm-perfmgr-mark-inactive-nodes-in-perfmgr-db.patch
	0006-opensm-console-add-print-all-to-print_counters-conso.patch
	0007-opensm-console-add-port-option-to-perfmgr-print_coun.patch
	0008-opensm-console-add-abreviations-for-perfmgr-commands.patch
	0009-opensm-console-Add-human-readable-output-for-perfmgr.patch
	0010-opensm-console-add-perfmgr-print_errors-pe-console-c.patch

Thanks,
Ira

-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
