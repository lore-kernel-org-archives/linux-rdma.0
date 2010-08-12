From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2] rdma/ib_pack.h: add new bth opcodes
Date: Thu, 12 Aug 2010 09:35:33 +0300
Message-ID: <4C639635.4090704@voltaire.com>
References: <4C62F86C.6060504@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C62F86C.6060504-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bob Pearson wrote:
> I was wondering if I could use this to cause ConnectX RDMAoE senders to slow down 
> in response to these packets. There is a challenge managing fast ROCE senders 
> in networks that may not fully implement per priority pause.
>   
Hi Bob,

QCN (IEEE 802.1 based Ethernet congestion control mechanism) can apply 
for IBoE traffic, in the same manner it would for FCoE, IP etc. Is there 
a specific reason you wanted to apply the IB mechanism and not use the 
Ethernet one? Yep, PFC is helpful.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
