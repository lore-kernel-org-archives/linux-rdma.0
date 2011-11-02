From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [ANNOUNCE] infiniband-diags 1.5.11 tarball release
Date: Tue, 1 Nov 2011 21:48:32 -0700
Message-ID: <20111101214832.4c5b74fa.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

There is a new release of infiniband-diags.
Tarball available at:

http://www.openfabrics.org/downloads/management/infiniband-diags-1.5.11.tar.gz

(listed in http://www.openfabrics.org/downloads/management/latest.txt)

md5sum: 815b3550e906fa3452355fa619b073e0  infiniband-diags-1.5.11.tar.gz

This is a bug fix release based on the 1.5 branch.

Full list of changes is below.

Author: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

    infiniband-diags: ibqueryerrors: don't exit on reset error
    infiniband-diags: iblinkinfo flag ports which were not scanned
    infiniband-diags: saquery: use ib-node-name-map file
    infiniband-diags: iblinkinfo: fix error message
    infiniband-diags: fix installation of error_thresholds file

Author: Marcus R Epperson <marcus.r.epperson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

    infiniband-diags/src/ibqueryerrors.c: don't increment bad_ports for port ALL
    infiniband-diags/src/ibqueryerrors.c: fix segv due to CA port 0 reference

Author: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

    infiniband-diags/scripts/ibcheckport.in: ignore lid/sm lid checks on non zero port switches

Author: Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

    RE: [PATCH v2] ib-diags: Add cast to fix build on windows


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
