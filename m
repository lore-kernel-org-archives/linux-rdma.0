From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: RDMA/iw_cxgb4: Low resource fixes for Memory registration
Date: Sat, 25 Jun 2016 00:48:30 +0300
Message-ID: <20160624214830.GA21337@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Hariprasad S,

The patch 0f8ab0b6e91b: "RDMA/iw_cxgb4: Low resource fixes for Memory
registration" from Jun 10, 2016, leads to the following static
checker warning:

	drivers/infiniband/hw/cxgb4/mem.c:612 c4iw_alloc_mw()
	error: use kfree_skb() here instead of kfree(mhp->dereg_skb)

drivers/infiniband/hw/cxgb4/mem.c
   600          mhp = kzalloc(sizeof(*mhp), GFP_KERNEL);
   601          if (!mhp)
   602                  return ERR_PTR(-ENOMEM);
   603  
   604          mhp->dereg_skb = alloc_skb(SGE_MAX_WR_LEN, GFP_KERNEL);
   605          if (!mhp->dereg_skb) {
   606                  kfree(mhp);
   607                  return ERR_PTR(-ENOMEM);
   608          }
   609  
   610          ret = allocate_window(&rhp->rdev, &stag, php->pdid);
   611          if (ret) {
   612                  kfree(mhp->dereg_skb);

Should be kfree_skb(mhp->dereg_skb);.  This code would be slightly nicer
if it used gotos to unwind.

   613                  kfree(mhp);
   614                  return ERR_PTR(ret);
   615          }
   616          mhp->rhp = rhp;
   617          mhp->attr.pdid = php->pdid;
   618          mhp->attr.type = FW_RI_STAG_MW;
   619          mhp->attr.stag = stag;
   620          mmid = (stag) >> 8;
   621          mhp->ibmw.rkey = stag;
   622          if (insert_handle(rhp, &rhp->mmidr, mhp, mmid)) {
   623                  deallocate_window(&rhp->rdev, mhp->attr.stag, mhp->dereg_skb);
   624                  kfree(mhp->dereg_skb);


kfree_skb().

   625                  kfree(mhp);
   626                  return ERR_PTR(-ENOMEM);
   627          }
   628          PDBG("%s mmid 0x%x mhp %p stag 0x%x\n", __func__, mmid, mhp, stag);
   629          return &(mhp->ibmw);
   630  }
   631  
   632  int c4iw_dealloc_mw(struct ib_mw *mw)
   633  {
   634          struct c4iw_dev *rhp;
   635          struct c4iw_mw *mhp;
   636          u32 mmid;
   637  
   638          mhp = to_c4iw_mw(mw);
   639          rhp = mhp->rhp;
   640          mmid = (mw->rkey) >> 8;
   641          remove_handle(rhp, &rhp->mmidr, mmid);
   642          deallocate_window(&rhp->rdev, mhp->attr.stag, mhp->dereg_skb);

It looks like there should be a kfree_skb() here as well.  We're leaking
a bit of memory.

   643          kfree(mhp);
   644          PDBG("%s ib_mw %p mmid 0x%x ptr %p\n", __func__, mw, mmid, mhp);
   645          return 0;
   646  }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
