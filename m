From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Is ib_mtu iboe_get_mtu() slightly off?
Date: Mon, 09 Oct 2017 09:34:33 -0400
Message-ID: <1507556073.46071.27.camel@redhat.com>
References: <CAL1RGDX33tBR=x2sOp_F1605SY5nu_6YALr-XYE_LiuvsHQ1ng@mail.gmail.com>
         <VI1PR0502MB300886CB47BB3DFDE098A26AD1660@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB300886CB47BB3DFDE098A26AD1660-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-09-21 at 02:20 +0000, Parav Pandit wrote:
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Roland Dreier
> > Sent: Wednesday, September 20, 2017 7:39 PM
> > To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Is ib_mtu iboe_get_mtu() slightly off?
> > 
> > We have:
> > 
> > static inline enum ib_mtu iboe_get_mtu(int mtu) {
> >         /*
> >          * reduce IB headers from effective IBoE MTU. 28 stands for
> >          * atomic header which is the biggest possible header after
> > BTH
> >          */
> >         mtu = mtu - IB_GRH_BYTES - IB_BTH_BYTES - 28;
> >        ...
> > 
> > 28 bytes is the size of the AtomicETH header.  But couldn't we have
> > a packet
> > with both AtomicETH and XRCETH (4 more bytes)?
> 
> XRCETH + AtomicETH is possible.
> Additionally I guess 4 bytes of ICRC is missing too in calculation.

Since no one rolled a patch for this, I did.

commit 7107ee2ea38fb52ffe81be054657e90863ebe8ab (HEAD -> k.o/for-next)
Author: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Mon Oct 9 09:26:47 2017 -0400

    RDMA/core: Fix iboe_get_mtu size calculation
    
    We mistakenly used the size of the largest header possible after
    BTH_BYTES without considering that this largest header might actually be
    in combination with a few select other headers.  So, increase the size
    of the largest header number to be the size of the largest possible
    combination of headers instead of just the single largest header.
    
    Fixes: 3c86aa70bf67 (RDMA/cm: Add RDMA CM support for IBoE devices)
    Reported-by: Roland Drier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
    Reported-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index ec5008cf5d51..45a03c514437 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -245,10 +245,11 @@ static inline void rdma_addr_set_dgid(struct rdma_dev_addr *dev_addr, union ib_g
 static inline enum ib_mtu iboe_get_mtu(int mtu)
 {
        /*
-        * reduce IB headers from effective IBoE MTU. 28 stands for
-        * atomic header which is the biggest possible header after BTH
+        * reduce IB headers from effective IBoE MTU. 36 stands for
+        * AtomicETH + XRCETH + ICRC, which is the biggest header
+        * combination possible after BTH
         */
-       mtu = mtu - IB_GRH_BYTES - IB_BTH_BYTES - 28;
+       mtu = mtu - IB_GRH_BYTES - IB_BTH_BYTES - 36;
 
        if (mtu >= ib_mtu_enum_to_int(IB_MTU_4096))
                return IB_MTU_4096;


-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
