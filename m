From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: small svc_rdma cleanup
Date: Wed, 16 Dec 2015 16:11:03 +0100
Message-ID: <1450278664-2133-1-git-send-email-hch@lst.de>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This makes use of the now always available local_dma_lkey, and goes on top
of Chuck's "[PATCH v4 00/11] NFS/RDMA server patches for v4.5" series.

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
