From: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: ib receive completion error
Date: Wed, 10 Nov 2010 12:16:55 +0200
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB443D1BBE0CEC@MTLMAIL.mtl.com>
References: <7866DA1F8D2D4541B87FEE88E633ABAA2BBE305046@MNEXMB1.qlogic.org>
	<4CDA70C0.8050003@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CDA70C0.8050003-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Usha Srinivasan <usha.srinivasan-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 11/9/2010 9:22 PM, Usha Srinivasan wrote: 
> Hello,
> Can someone from Mellanox tell me what the vendor error 0x32 means?   I am getting this error for wc.opcode 128 (IB_WC_RECV) wc.status 4 (IB_WC_LOC_PROT_ERR).  


This error means corrupted MPT or PD violation

Tziporet



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
