From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] librdmacm/mckey: enforce local binding for unmapped	multicast
 addresses
Date: Thu, 05 Nov 2009 13:38:22 +0200
Message-ID: <4AF2B92E.2030807@Voltaire.com>
References: <Pine.LNX.4.64.0911011130140.6591@zuben.voltaire.com>	<AB1AB5E171B44E1AA5FAFB87901C69C7@amr.corp.intel.com>	<4AF037F7.9080100@voltaire.com> <72E827020C9E497DB3CAA3DD720E9604@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <72E827020C9E497DB3CAA3DD720E9604-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
> This is basically correct, but the MGIDs must be of the format 0xFF1-scope-A01B.
> The kernel keys off this in the address to determine if the mapping should be made.

okay

> From 15.2.5.17.2:
> "MGID undefined" means either the MGID bit in the component mask is not set, or
> if the MGID bit in the component mask is set, the MGID component of MCMemberRecord:MGID is 0

okay, I was confused between generating an SA assigned MGID to using it as unmapped multicast address with mckey, lets document how to do the generation

Or.


document how SA assigned MGIDs can be created via mckey

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

Index: librdmacm/man/mckey.1
===================================================================
--- librdmacm.orig/man/mckey.1
+++ librdmacm/man/mckey.1
@@ -47,6 +47,9 @@ UDP (0x0111) or IPoIB (0x0002) port spac
 Basic usage is to start mckey -m multicast_address on a server system,
 then run mckey -m multicast_address -s on a client system.
 .P
+Unique SA assigned multicast GIDs can be retreived by invoking mckey
+with a zero MGID using the unmapped option, i.e  -M ::0
+.P
 Because this test maps RDMA resources to userspace, users must ensure
 that they have available system resources and permissions.  See the
 libibverbs README file for additional details.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
