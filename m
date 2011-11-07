From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [ANNOUNCE] infiniband-diags 1.5.12 tarball release
Date: Mon, 7 Nov 2011 09:14:52 -0800
Message-ID: <20111107091452.456ed172.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

There is a new release of infiniband-diags.
Tarball available at:

http://www.openfabrics.org/downloads/management/infiniband-diags-1.5.12.tar.gz

(listed in http://www.openfabrics.org/downloads/management/latest.txt)

7a823a3f6d9cfa3d19e1ca6889f3c122  infiniband-diags-1.5.12.tar.gz

This is a bug fix release based on the 1.5 branch.

Full list of changes is below.

Author: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

    infiniband-diags: check_lft_balance.pl add -C/-P options
    infiniband-diags: clean up build
    
    
Author: Albert L.Chu <chu11-i2BcT+NCU+M@public.gmane.org>

    check_lft_balance.pl: Add extra check when using -e heuristic flag in check_lft_balance.pl
    Add -e heuristic flag to check_lft_balance.pl to detect common scenarios where unbalanced routing will occur.
    Update check_lft_balance.pl to work with newer infiniband-diag tools
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
