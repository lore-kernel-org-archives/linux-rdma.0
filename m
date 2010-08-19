From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2] rdma/ib_pack.h: add new bth opcodes
Date: Thu, 19 Aug 2010 11:54:17 +0300
Message-ID: <4C6CF139.1020405@Voltaire.com>
References: <4C62F86C.6060504@systemfabricworks.com>	<4C639635.4090704@voltaire.com> <4C6965EA.2050208@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C6965EA.2050208-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bob Pearson wrote:
> I was curious to see if I could force a ConnectX device to slow down from a remote application.
> But since the MADs have been crippled for IBOE there is no way to configure it.

QP1 MADs are working for ConnectX, e.g the IB CM is fully functional for IBoE, and I don't think the 
mad layer was modified to emulate MADs for the CM over regular UD QP, UDP or their such, Eli, 
am I correct in that? For some reason the PMA (QP1 performance counters) service isn't exposed, but
it should be working (and helpful) as well.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
