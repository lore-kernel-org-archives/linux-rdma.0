From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/6] SRP initiator related bug fixes
Date: Tue, 1 Dec 2015 10:16:12 -0800
Message-ID: <565DE3EC.2070002@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series contains six bug fixes either for the SRP initiator 
itself or for IB core functionality used by the SRP initiator. The order 
of these patches matches the order in which the corresponding bugs have 
been introduced. The patches in this series are:

0001-IB-srp-Fix-a-memory-leak.patch
0002-IB-srp-Fix-possible-send-queue-overflow.patch
0003-IB-srp-Initialize-dma_length-in-srp_map_idb.patch
0004-IB-srp-Fix-indirect-data-buffer-rkey-endianness.patch
0005-IB-core-Fix-ib_sg_to_pages.patch
0006-IB-srp-Fix-srp_map_sg_fr.patch
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
