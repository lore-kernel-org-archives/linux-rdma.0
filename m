From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/3] IB core: 64 bit counter support V3
Date: Mon, 21 Dec 2015 08:20:26 -0600
Message-ID: <20151221142026.238104419@linux.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

V2->V3
  - Also add support for NOIETF counter mode where we have 64 bit
  	counters but not the multicast/unicast counters.
  - Add Reviewed-by's from Hal.

V1->V2
  - Add detection of the capability for 64 bit counter support
  - Lots of improvements as a result of suggestions by Hal Rosenstock.

Currently we only use 32 bits for the packet and byte counters. There have
been extended countes available for some time but we have no support for
those yet upstream. We keep having issues with 32 bit counters wrapping.
Especially the byte counter can wrap frequently (as in multiple times per
minute)

This patch adds 4 new counters (for full extended mode) and updates 4 32
bit counters to use the 64 bit sizes (for NOIETF and full extended mode)
so that they no longer wrap.

Should the device not support 64 bit counters then only the original 32
bit counters will be visible.

This patchset can be pulled from my git repo on kernel.org

git pull git://git.kernel.org/pub/scm/linux/kernle/git/christoph/rdma.git counter_64bit

Thanks to Hal Rosenstock and Ira Weiny for reviewing this patchset.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
