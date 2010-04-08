From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 38/51] IB/qib: Add qib_sysfs.c
Date: Thu, 8 Apr 2010 14:29:53 -0700
Message-ID: <1270762193.2278.25.camel@chromite.mv.qlogic.com>
References: <20091203190305.29507.58158.stgit@chromite.mv.qlogic.com>
	 <20091203190624.29507.22110.stgit@chromite.mv.qlogic.com>
	 <adaiq81wtw3.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaiq81wtw3.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This was for debugging and clearly could use a better method.
Some stats are definitely useful and having files per value
would make scripting easier too.
I could add /sys/class/infiniband/qib0/ports/1/diag_counters/*

One other place that has multiple values is dumping the QSFP
data from the IB cable.

On Thu, 2010-04-08 at 13:50 -0700, Roland Dreier wrote:
> I didn't audit everything (so there may be more problems here too), but
> certainly this violates the "one value per sysfs file" rule rather
> egregiously:
> 
>  > +static ssize_t show_stats(struct device *device, struct device_attribute *attr,
>  > +			  char *buf)
>  > +{
>  > +	struct qib_ibdev *dev =
>  > +		container_of(device, struct qib_ibdev, ibdev.dev);
>  > +	struct qib_devdata *dd = dd_from_dev(dev);
>  > +	unsigned pidx;
>  > +	unsigned i;
>  > +	int len = 0;
>  > +	unsigned long flags;
>  > +
>  > +	for (pidx = 0; pidx < dd->num_pports; ++pidx) {
>  > +		struct qib_ibport *ibp = &dd->pport[pidx].ibport_data;
>  > +
>  > +		len += sprintf(buf + len,
>  > +			       "Port %d:\n"
>  > +			       "RC timeouts %d\n"
>  > +			       "RC resends  %d\n"
>  > +			       "RC QACKs    %d\n"
>  > +			       "RC SEQ NAKs %d\n"
>  > +			       "RC RDMA seq %d\n"
>  > +			       "RC RNR NAKs %d\n"
>  > +			       "RC OTH NAKs %d\n"
>  > +			       "RC DComp    %d\n"
>  > +			       "RCr dup req %d\n"
>  > +			       "RCr SEQ NAK %d\n"
>  > +			       "wait piobuf %d\n"
>  > +			       "wait DMA    %d\n"
>  > +			       "wait TX     %d\n"
>  > +			       "unaligned   %d\n"
>  > +			       "loop pkts   %d\n"
>  > +			       "PKT drops   %d\n",
>  > +			       dd->pport[pidx].port,
>  > +			       ibp->n_timeouts, ibp->n_rc_resends,
>  > +			       ibp->n_rc_qacks, ibp->n_seq_naks,
>  > +			       ibp->n_rdma_seq, ibp->n_rnr_naks,
>  > +			       ibp->n_other_naks, ibp->n_rc_delayed_comp,
>  > +			       ibp->n_rc_dupreq, ibp->n_rc_seqnak,
>  > +			       dev->n_piowait, ibp->n_dmawait, dev->n_txwait,
>  > +			       ibp->n_unaligned, ibp->n_loop_pkts,
>  > +			       ibp->n_pkt_drops);
>  > +		for (i = 0; i < ARRAY_SIZE(ibp->opstats); i++) {
>  > +			const struct qib_opcode_stats *si = &ibp->opstats[i];
>  > +
>  > +			if (!si->n_packets && !si->n_bytes)
>  > +				continue;
>  > +			len += sprintf(buf + len, "%02x %llu/%llu\n", i,
>  > +				       (unsigned long long) si->n_packets,
>  > +				       (unsigned long long) si->n_bytes);
>  > +		}
>  > +	}
>  > +	len += sprintf(buf + len, "Ctx:npkts");
>  > +	for (i = 0; i < dd->first_user_ctxt; i++) {
>  > +		if (!dd->rcd[i])
>  > +			continue;
>  > +		len += sprintf(buf + len, " %u:%u", i,
>  > +			       dd->rcd[i]->pkt_count);
>  > +	}
>  > +	len += sprintf(buf + len, "\n");
>  > +	spin_lock_irqsave(&dev->qpt_lock, flags);
>  > +	for (i = 0; i < dev->qp_table_size; i++) {
>  > +		struct qib_qp *qp;
>  > +		for (qp = dev->qp_table[i]; qp != NULL; qp = qp->next) {
>  > +			struct qib_swqe *wqe;
>  > +
>  > +			if (qp->s_last == qp->s_acked &&
>  > +			    qp->s_acked == qp->s_cur &&
>  > +			    qp->s_cur == qp->s_tail &&
>  > +			    qp->s_tail == qp->s_head)
>  > +				continue;
>  > +			if (len + 128 >= PAGE_SIZE)
>  > +				break;
>  > +			wqe = get_swqe_ptr(qp, qp->s_last);
>  > +			len += sprintf(buf + len,
>  > +				       "QP%u %s %u %u %u f=%x %u %u %u %u %u "
>  > +				       "PSN %x %x %x %x %x "
>  > +				       "(%u %u %u %u %u %u) QP%u LID %x\n",
>  > +				       qp->ibqp.qp_num,
>  > +				       qp_type_str[qp->ibqp.qp_type],
>  > +				       qp->state,
>  > +				       wqe->wr.opcode,
>  > +				       qp->s_hdrwords,
>  > +				       qp->s_flags,
>  > +				       atomic_read(&qp->s_dma_busy),
>  > +				       !list_empty(&qp->iowait),
>  > +				       qp->timeout,
>  > +				       wqe->ssn,
>  > +				       qp->s_lsn,
>  > +				       qp->s_last_psn,
>  > +				       qp->s_psn, qp->s_next_psn,
>  > +				       qp->s_sending_psn, qp->s_sending_hpsn,
>  > +				       qp->s_last, qp->s_acked, qp->s_cur,
>  > +				       qp->s_tail, qp->s_head, qp->s_size,
>  > +				       qp->remote_qpn,
>  > +				       qp->remote_ah_attr.dlid);
>  > +		}
>  > +	}
>  > +	spin_unlock_irqrestore(&dev->qpt_lock, flags);
>  > +	return len;
>  > +}
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
