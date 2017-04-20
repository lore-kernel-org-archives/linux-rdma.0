From: Boris Pismenny <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 0/2] IB/core: Add ESP Crypto Flow Steering support
Date: Thu, 20 Apr 2017 14:00:08 +0300
Message-ID: <cover.1492685328.git.borisp@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, aviadye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: borisp <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The purpose of this RFC is to suggest an API for specifying
ESP crypto offload via flow steering. This API will allow users
to control the crypto offload functionality offered by new NICs,
such as Mellanox Innova IPsec.

Applications can request ESP encryption offload for transmission of
well-formed plaintext ESP packets, or decryption offload for
well-fromed ciphertext ESP packets. Packets are encrypted/decrypted
according to the direction of the flow.

In order to create an ESP crypto offload specification, the user has
to add it to a flow with the Security Association selectors.

borisp (2):
  Introduce egress IB flow steering flag
  IB/core: ESP AES-GCM crypto offload action

 include/rdma/ib_verbs.h | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
