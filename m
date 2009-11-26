From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Thu, 26 Nov 2009 13:16:04 +0200
Message-ID: <4B0E6374.9070809@Voltaire.com>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com>	<4B0CDBEC.1030203@voltaire.com>	<10904370-1D66-4013-BB3F-0F4B5EE581EE@cisco.com>	<4B0D4660.5060701@voltaire.com> <4B0D8FD2.9000702@dev.mellanox.co.il>	<4B0E2DA7.7060809@voltaire.com> <4B0E43BA.6070700@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B0E43BA.6070700-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: pasha-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Pavel Shamis (Pasha) wrote:
> The only reason for this changes is the fact that for IB devices we
> prefer to use our own open mpi connection managers. In case if we will
> decide to use RDMA-CM for all devices the number of changes will be zero...

whatever, currently, this change is still there, and best if you remove it 
and find another way to set this predicate.

> So we decided to use the current ompi code as is, in future maybe we will
> implement own ompi rdmacm code that will not have all this work around flows.

just to make sure I am with you, all in all, only one patch is proposed to ompi for 
rdmaoe support and is the patch which we discuss above, this patch does three things:

1. changes BTL_OPENIB_CONNECT_BASE_CHECK_IF_NOT_IB to look on the port transport type
2. if the port transport is rdmaoe don't run loopback connections on IB
3. some change in the qp destroy logic
4. that's it...

correct? can you comment on #2? why loopback connections aren't supported?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
