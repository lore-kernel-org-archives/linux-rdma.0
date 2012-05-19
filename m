From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/3] Optimized and deadlock-free routing algorithm fixes
Date: Sat, 19 May 2012 22:39:51 +0300
Message-ID: <20120519193815.GA2110@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Domke <jens.domke-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following patches fix some issues found during the review of SSSP/DFSSSP
routing algorithms. The original patch was published by Jens Domke and Torsten
Hoefler: http://www.spinics.net/lists/linux-rdma/msg10879.html.
-- 

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
