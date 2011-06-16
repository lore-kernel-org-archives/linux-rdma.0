From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 7/9] ib/pma: add include file for IBA performance
	counters definitions
Date: Thu, 16 Jun 2011 16:19:38 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237302184A@ORSMSX101.amr.corp.intel.com>
References: <alpine.LRH.2.00.1106151733410.15844@ogerlitz.voltaire.com>
	<alpine.LRH.2.00.1106151747390.15844@ogerlitz.voltaire.com>
 <1828884A29C6694DAF28B7E6B8A8237302148F@ORSMSX101.amr.corp.intel.com>
 <4DF9B319.6070100@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DF9B319.6070100-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Rather than having IB_PMA_SEL_* and IB_PMA_SELX_*, we could follow
> what's done in ib_sa.h:
> > IB_PM_<structure>_<field>
> 
> I would need some guidance here...  maybe you can elaborate a little
> further with the V1 posting which will follow soon

Here's part of a comment from ib_sa.h:

 * Structures for SA records are named "struct ib_sa_xxx_rec."
 * For a record with structure ib_sa_xxx_rec, the naming convention
 * for the component mask value for field yyy is IB_SA_XXX_REC_YYY (we
 * never use different abbreviations or otherwise change the spelling
 * of xxx/yyy between ib_sa_xxx_rec.yyy and IB_SA_XXX_REC_YYY).

>From V1, we have:

+struct ib_pma_portcounters_ext {
..
+	__be64 port_unicast_xmit_packets;
..
+#define IB_PMA_SELX_PORT_UNI_XMIT_PACKETS       cpu_to_be16(0x0010)

at this point, you're patches look good to me and are an improvement over what's there now.  So, I'd file this comment as a future nice to have.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
