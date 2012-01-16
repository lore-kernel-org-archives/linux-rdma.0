From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: infiniband-diags v1.5.13 bug fix release
Date: Mon, 16 Jan 2012 11:55:20 -0800
Message-ID: <20120116115520.898d816a.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

There is a new release of infiniband-diags.

http://www.openfabrics.org/downloads/management/infiniband-diags-1.5.13.tar.gz

(listed in http://www.openfabrics.org/downloads/management/latest.txt)

367affa587f346f9ddc064bcce4206cf  infiniband-diags-1.5.13.tar.gz


This is a bug fix release based on the 1.5 branch.

List of changes from v1.5.12:

Author: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>

    support --switches-only and --cas-only options in iblinkinfo

Author: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

    ibswitches: fix output when switch names have "base" or "enhanced" in them
    infiniband-diags: add config file option for Mellanox ExtPortInfo queries
    infiniband-diags: add a general config file
    infiniband-diags: move is_mlnx_ext_port_info_supported to common code
    infiniband-diags: fix printing of extended speeds when port is down

Author: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

    infiniband-diags/configure.in: Fix typo
    infiniband-diags/perfquery.c: Fix reset for PortExtendedSpeedsCounters
    infiniband-diags/perfquery.c: Fix display of PortExtendedSpeedsCounters


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
