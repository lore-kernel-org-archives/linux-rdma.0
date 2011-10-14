From: Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Subject: rdma: 3.1.0-rc9 breaks UD
Date: Fri, 14 Oct 2011 09:02:20 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1110140852210.6411@router.home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Running ibv_ud_pingpong and ibc_uc_pingpong between two hosts. One with
OFED 1.5.3.1 (Ubuntu LTS 10.04) and another on linux 3.1.0-rc9 (Same
ubuntu version uderlying) with the upstream libraries.

ibv_uc_pingpong

OFED:

# ibv_uc_pingpong
  local address:  LID 0x000a, QPN 0x54004d, PSN 0x00637e, GID ::
  remote address: LID 0x000b, QPN 0x04004c, PSN 0x7fdc0a, GID ::
8192000 bytes in 0.01 seconds = 7526.82 Mbit/sec
1000 iters in 0.01 seconds = 8.71 usec/iter


3.1.0-rc9:

ibv_uc_pingpong 10.2.35.21
  local address:  LID 0x000b, QPN 0x04004c, PSN 0x7fdc0a, GID ::
  remote address: LID 0x000a, QPN 0x54004d, PSN 0x00637e, GID ::
8192000 bytes in 0.01 seconds = 7634.67 Mbit/sec
1000 iters in 0.01 seconds = 8.58 usec/iter


ibv_ud_pingpong

OFED:

# ibv_ud_pingpong
  local address:  LID 0x000a, QPN 0x50004d, PSN 0x8b572b: GID ::
  remote address: LID 0x000b, QPN 0x02004c, PSN 0x2117ef, GID ::

3.1.0-rc9:

# ibv_ud_pingpong 10.2.35.21
  local address:  LID 0x000b, QPN 0x02004c, PSN 0x2117ef: GID ::
  remote address: LID 0x000a, QPN 0x50004d, PSN 0x8b572b, GID ::


No traffic flows.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
