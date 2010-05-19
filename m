From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V2 1/4] ib_core: changes to support XRC RCV qp's
Date: Wed, 19 May 2010 09:30:33 +0300
Message-ID: <201005190930.33947.jackm@dev.mellanox.co.il>
References: <201005181455.02623.jackm@dev.mellanox.co.il> <21985B556C0D42658109996B406ADC15@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <21985B556C0D42658109996B406ADC15-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tuesday 18 May 2010 21:33, Sean Hefty wrote:
> >+struct ib_xrc_rcv_qp_table_entry *
> >+ib_xrc_rcv_tbl_find(struct ib_device *dev, u32 qpn)
> >+{
> >+        return radix_tree_lookup(&dev->xrc_rcv_qp_table, qpn);
> >+}
> 
> nit - but do we need a wrapper around this single call?
I prefer it this way, so that we have a complete xrc_rcv_table interface.
 
> >+	list_for_each_entry(tmp, &qp->list, list)
> >+		if (tmp->context == context) {
> >+			found = 1;
> >+			break;
> >+		}
> >+	/* add only a single entry per user context */
> >+	if (unlikely(found)) {
> >+		err = 0;
> >+		goto free_out;
> >+	}
> 
> Maybe this becomes clear later, but can a user add multiple entries?  Can't we
> just consider this a usage error?  Actually, why does it matter if the same
> context is added multiple times?

This list of entries is also used to disperse XRC RCV qp events to all registered
processes -- and we only want a single event dispatched per process.

> >+	dev->destroy_xrc_rcv_qp(qp->xrcd, qpn);
> >+	kfree(qp);
> >+	list_for_each_entry_safe(reg_entry, tmp, &xrc_local, list) {
> >+		list_del(&reg_entry->list);
> >+		kfree(reg_entry);
> >+		atomic_dec(&qp->xrcd->usecnt);
> 
> qp was just freed a few lines up
Ouch!  Thanks for the catch, Sean.  I'll fix it before resubmitting.


Regards,
Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
