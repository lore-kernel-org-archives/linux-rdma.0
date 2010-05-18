From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V2 1/4] ib_core: changes to support XRC RCV qp's
Date: Tue, 18 May 2010 11:33:23 -0700
Message-ID: <21985B556C0D42658109996B406ADC15@amr.corp.intel.com>
References: <201005181455.02623.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201005181455.02623.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jack Morgenstein' <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>+struct ib_xrc_rcv_qp_table_entry *
>+ib_xrc_rcv_tbl_find(struct ib_device *dev, u32 qpn)
>+{
>+        return radix_tree_lookup(&dev->xrc_rcv_qp_table, qpn);
>+}

nit - but do we need a wrapper around this single call?

>+int ib_xrc_rcv_qp_table_add_reg_entry(struct ib_device *dev, u32 qpn,
>+				      void *context)
>+{
>+	struct ib_xrc_rcv_reg_entry *reg_entry, *tmp;
>+	struct ib_xrc_rcv_qp_table_entry *qp;
>+	unsigned long flags;
>+	int err = -EINVAL, found = 0;
>+
>+	reg_entry = kzalloc(sizeof *reg_entry, GFP_KERNEL);
>+	if (!reg_entry)
>+		return -ENOMEM;
>+	reg_entry->context = context;
>+
>+	spin_lock_irqsave(&dev->xrc_rcv_qp_table_lock, flags);
>+	qp = ib_xrc_rcv_tbl_find(dev, qpn);
>+	if (unlikely(!qp))
>+		goto free_out;
>+	list_for_each_entry(tmp, &qp->list, list)
>+		if (tmp->context == context) {
>+			found = 1;
>+			break;
>+		}
>+	/* add only a single entry per user context */
>+	if (unlikely(found)) {
>+		err = 0;
>+		goto free_out;
>+	}

Maybe this becomes clear later, but can a user add multiple entries?  Can't we
just consider this a usage error?  Actually, why does it matter if the same
context is added multiple times?

>+	atomic_inc(&qp->xrcd->usecnt);
>+	list_add_tail(&reg_entry->list, &qp->list);
>+	spin_unlock_irqrestore(&dev->xrc_rcv_qp_table_lock, flags);
>+	return 0;
>+
>+free_out:
>+	spin_unlock_irqrestore(&dev->xrc_rcv_qp_table_lock, flags);
>+	kfree(reg_entry);
>+	return err;
>+}
>+EXPORT_SYMBOL(ib_xrc_rcv_qp_table_add_reg_entry);

>+int ib_xrc_rcv_qp_table_remove(struct ib_device *dev, u32 qpn)
>+{
>+	struct ib_xrc_rcv_reg_entry *reg_entry, *tmp;
>+	struct ib_xrc_rcv_qp_table_entry *qp;
>+	struct list_head xrc_local;
>+	unsigned long flags;
>+
>+	INIT_LIST_HEAD(&xrc_local);
>+
>+	spin_lock_irqsave(&dev->xrc_rcv_qp_table_lock, flags);
>+
>+	qp = ib_xrc_rcv_tbl_find(dev, qpn);
>+	if (unlikely(!qp))
>+		goto out;
>+	/* ASSERT(!list_empty(&qp->list)); */
>+	list_replace_init(&qp->list, &xrc_local);
>+	radix_tree_delete(&dev->xrc_rcv_qp_table, qpn);
>+	spin_unlock_irqrestore(&dev->xrc_rcv_qp_table_lock, flags);
>+
>+	dev->destroy_xrc_rcv_qp(qp->xrcd, qpn);
>+	kfree(qp);
>+	list_for_each_entry_safe(reg_entry, tmp, &xrc_local, list) {
>+		list_del(&reg_entry->list);
>+		kfree(reg_entry);
>+		atomic_dec(&qp->xrcd->usecnt);

qp was just freed a few lines up

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
