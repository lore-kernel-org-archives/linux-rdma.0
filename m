From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [RFC 0/2] IB/core: Add ESP Crypto Flow Steering support
Date: Thu, 20 Apr 2017 10:16:09 -0500
Message-ID: <040001d2b9e9$0a274530$1e75cf90$@opengridcomputing.com>
References: <cover.1492685328.git.borisp@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1492685328.git.borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Boris Pismenny' <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, aviadye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Subject: [RFC 0/2] IB/core: Add ESP Crypto Flow Steering support
> 
> From: borisp <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> The purpose of this RFC is to suggest an API for specifying
> ESP crypto offload via flow steering. This API will allow users
> to control the crypto offload functionality offered by new NICs,
> such as Mellanox Innova IPsec.
> 
> Applications can request ESP encryption offload for transmission of
> well-formed plaintext ESP packets, or decryption offload for
> well-fromed ciphertext ESP packets. Packets are encrypted/decrypted
> according to the direction of the flow.
> 
> In order to create an ESP crypto offload specification, the user has
> to add it to a flow with the Security Association selectors.
>

Hey Boris,  

Do you have any applications that utilize this and other flow steering APIs?  It
would be nice to see example usage. 

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
