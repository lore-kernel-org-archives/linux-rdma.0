From: Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Subject: Building 3.1-rc9 in kernel infiniband support with OFED libraries
Date: Tue, 11 Oct 2011 09:02:41 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1110110900290.3388@router.home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Seems to work mostly but some userspace libraries (mlx4) complain about
kernel version mismatch and missing XRC support.

Has XRC support not been merged? How can I build the OFED libraries
against Linux 3.1? I'd really like to get rid of the OFED kernel tree
nightmare.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
