From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ewg] rdma/cm: disallow loopback address for iwarp devices
Date: Mon, 8 Feb 2010 15:48:16 -0800
Message-ID: <1966FBDAD40C4EAC8611372D2B15AE84@amr.corp.intel.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com> <0D5487526204477AA2ABED06E46768E2@amr.corp.intel.com> <4B6C498F.3060708@opengridcomputing.com> <38B735478FE94F40BBA3E8BFD794B10F@amr.corp.intel.com> <4B6D9948.6040007@opengridcomputing.com> <B41CA82E76BB439B892B4874D38EA652@amr.corp.intel.com> <79BAA34231304F1E84C5A5A53C50A207@amr.corp.intel.com> <4B6FFB1B.40905@mellanox.co.il> <4B701FE6.60302@opengridcomputing.com> <adawrynwtz9.fsf@roland-alpha.cisco.com> <20100208191927.GU16490@obsidianresearch.com> <4B706DED.9080403@opengridcomputing.com> <C8A2C57AD5FA4141860DBFF60BFDE2DC@amr.corp.intel.com> <4B707F2D.3030508@opengridcomputing.com> <41CC15C4-0200-4C9E-9E10-3D2A9B76D16B@cisco.com> <7CC17592BE414EFCA00A1CB6033D047A@amr.corp.intel.com> <44864D85-03D1-412E-906C-D6FF9
 04157C8@cisco.com> <F533284C543140B0994C54C83C4AFF2B@amr.corp.intel.com> <4B709008.9020902@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B709008.9020902-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Steve Wise' <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Jeff Squyres' <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Tziporet Koren <tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux RDMA List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>Sean, can you try openmpi?  It fails for me, and yet ucmatose succeeds.
>I don't understand the difference yet...

I believe the issue is that rdma_bind_addr succeeds (returns 0), but no device
is assigned to the rdma_cm_id (verbs field is NULL).

This was a change from commit 6f8372b69c3198e06cecb1df2cb9682d0c55e657:

  The defined behavior of rdma_bind_addr is to associate an RDMA
  device with an rdma_cm_id, as long as the user specified a non-
  zero address.  (ie they weren't just trying to reserve a port)
  Currently, if the loopback address is passed to rdma_bind_addr,
  no device is associated with the rdma_cm_id.  Fix this.

There are two places where rdma_bind_addr() is called in the openmpi source code
(based on a tarball download of the trunk).  One is btl_openib_iwarp.c:

  rc = rdma_bind_addr(cm_id, ipaddr);
  if (rc || !cm_id->verbs) {
      rc = OMPI_SUCCESS;
      goto out3;
  }

The other is btl_openib_connect_rdmacm.c, but that deals with listening.  I
can't quickly determine if btl_openib_iwarp.c is usually used for IB or not.

So, to fully keep the behavior of 2.6.32, rdma_bind_addr for 127.0.0.1 should
succeed, but not assign a device.  I think this was the change from commit
..c55e657 that changed the behavior:

@@ -2089,7 +2096,9 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr
*addr)
        if (!cma_comp_exch(id_priv, CMA_IDLE, CMA_ADDR_BOUND))
                return -EINVAL;

-       if (!cma_any_addr(addr)) {
+       if (cma_loopback_addr(addr)) {
+               ret = cma_bind_loopback(id_priv);
+       } else if (!cma_zero_addr(addr)) {
                ret = rdma_translate_ip(addr, &id->route.addr.dev_addr);
                if (ret)
                        goto err1;

I'll see if reverting this gives the desired(?) behavior.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
