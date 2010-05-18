From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V2 2/4] ib_uverbs: XRC RCV qp implementation.
Date: Tue, 18 May 2010 12:40:37 -0700
Message-ID: <7D8F38E8D6ED4BEE901EAA44260BA384@amr.corp.intel.com>
References: <201005181455.34522.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201005181455.34522.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jack Morgenstein' <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>Thus, usage is:
>Either: create/modify/query/destroy_xrc_rcv_qp
>Or: create/modify/query/reg/unreg_xrc_rcv_qp

I think the latter usage explains why you added checks to prevent duplicate
registration.  Was there a reason not to use Roland's suggestion of dropping
create/destroy and having only reg/unreg?  (I must have missed this.)

>+ssize_t ib_uverbs_modify_xrc_rcv_qp(struct ib_uverbs_file *file,
>+				    const char __user *buf, int in_len,
>+				    int out_len)
>+{
>+	struct ib_uverbs_modify_xrc_rcv_qp      cmd;
>+	struct ib_qp_attr	       *attr;
>+	struct ib_xrcd		       *xrcd;
>+	struct ib_uobject	       *xrcd_uobj;
>+	int				err;
>+
>+	if (copy_from_user(&cmd, buf, sizeof cmd))
>+		return -EFAULT;
>+
>+	attr = kzalloc(sizeof *attr, GFP_KERNEL);
>+	if (!attr)
>+		return -ENOMEM;
>+
>+	xrcd = idr_read_xrcd(cmd.xrc_domain_handle, file->ucontext, &xrcd_uobj);
>+	if (!xrcd) {
>+		kfree(attr);
>+		return -EINVAL;
>+	}
>+
>+	attr->qp_state		  = cmd.qp_state;
>+	attr->cur_qp_state	  = cmd.cur_qp_state;
>+	attr->qp_access_flags	  = cmd.qp_access_flags;
>+	attr->pkey_index	  = cmd.pkey_index;
>+	attr->port_num		  = cmd.port_num;
>+	attr->path_mtu		  = cmd.path_mtu;
>+	attr->path_mig_state	  = cmd.path_mig_state;
>+	attr->qkey		  = cmd.qkey;
>+	attr->rq_psn		  = cmd.rq_psn;
>+	attr->sq_psn		  = cmd.sq_psn;
>+	attr->dest_qp_num	  = cmd.dest_qp_num;
>+	attr->alt_pkey_index	  = cmd.alt_pkey_index;
>+	attr->en_sqd_async_notify = cmd.en_sqd_async_notify;
>+	attr->max_rd_atomic	  = cmd.max_rd_atomic;
>+	attr->max_dest_rd_atomic  = cmd.max_dest_rd_atomic;
>+	attr->min_rnr_timer	  = cmd.min_rnr_timer;
>+	attr->port_num		  = cmd.port_num;
>+	attr->timeout		  = cmd.timeout;
>+	attr->retry_cnt		  = cmd.retry_cnt;
>+	attr->rnr_retry		  = cmd.rnr_retry;
>+	attr->alt_port_num	  = cmd.alt_port_num;
>+	attr->alt_timeout	  = cmd.alt_timeout;
>+
>+	memcpy(attr->ah_attr.grh.dgid.raw, cmd.dest.dgid, 16);
>+	attr->ah_attr.grh.flow_label	    = cmd.dest.flow_label;
>+	attr->ah_attr.grh.sgid_index	    = cmd.dest.sgid_index;
>+	attr->ah_attr.grh.hop_limit	    = cmd.dest.hop_limit;
>+	attr->ah_attr.grh.traffic_class	    = cmd.dest.traffic_class;
>+	attr->ah_attr.dlid		    = cmd.dest.dlid;
>+	attr->ah_attr.sl		    = cmd.dest.sl;
>+	attr->ah_attr.src_path_bits	    = cmd.dest.src_path_bits;
>+	attr->ah_attr.static_rate	    = cmd.dest.static_rate;
>+	attr->ah_attr.ah_flags		    = cmd.dest.is_global ? IB_AH_GRH :
0;
>+	attr->ah_attr.port_num		    = cmd.dest.port_num;
>+
>+	memcpy(attr->alt_ah_attr.grh.dgid.raw, cmd.alt_dest.dgid, 16);
>+	attr->alt_ah_attr.grh.flow_label    = cmd.alt_dest.flow_label;
>+	attr->alt_ah_attr.grh.sgid_index    = cmd.alt_dest.sgid_index;
>+	attr->alt_ah_attr.grh.hop_limit     = cmd.alt_dest.hop_limit;
>+	attr->alt_ah_attr.grh.traffic_class = cmd.alt_dest.traffic_class;
>+	attr->alt_ah_attr.dlid		    = cmd.alt_dest.dlid;
>+	attr->alt_ah_attr.sl		    = cmd.alt_dest.sl;
>+	attr->alt_ah_attr.src_path_bits	    = cmd.alt_dest.src_path_bits;
>+	attr->alt_ah_attr.static_rate	    = cmd.alt_dest.static_rate;
>+	attr->alt_ah_attr.ah_flags	    = cmd.alt_dest.is_global ? IB_AH_GRH
:
>0;
>+	attr->alt_ah_attr.port_num	    = cmd.alt_dest.port_num;

see comment below

>+
>+	err = xrcd->device->modify_xrc_rcv_qp(xrcd, cmd.qp_num, attr,
>cmd.attr_mask);
>+	put_uobj_read(xrcd_uobj);
>+	kfree(attr);
>+	return err ? err : in_len;
>+}
>+
>+ssize_t ib_uverbs_query_xrc_rcv_qp(struct ib_uverbs_file *file,
>+				   const char __user *buf, int in_len,
>+				   int out_len)
>+{
>+	struct ib_uverbs_query_xrc_rcv_qp cmd;
>+	struct ib_uverbs_query_qp_resp	 resp;
>+	struct ib_qp_attr		*attr;
>+	struct ib_qp_init_attr		*init_attr;
>+	struct ib_xrcd			*xrcd;
>+	struct ib_uobject		*xrcd_uobj;
>+	int				 ret;
>+
>+	if (copy_from_user(&cmd, buf, sizeof cmd))
>+		return -EFAULT;
>+
>+	attr      = kmalloc(sizeof *attr, GFP_KERNEL);
>+	init_attr = kmalloc(sizeof *init_attr, GFP_KERNEL);
>+	if (!attr || !init_attr) {
>+		ret = -ENOMEM;
>+		goto out;
>+	}
>+
>+	xrcd = idr_read_xrcd(cmd.xrc_domain_handle, file->ucontext, &xrcd_uobj);
>+	if (!xrcd) {
>+		ret = -EINVAL;
>+		goto out;
>+	}
>+
>+	ret = xrcd->device->query_xrc_rcv_qp(xrcd, cmd.qp_num, attr,
>+					     cmd.attr_mask, init_attr);
>+
>+	put_uobj_read(xrcd_uobj);
>+
>+	if (ret)
>+		goto out;
>+
>+	memset(&resp, 0, sizeof resp);
>+	resp.qp_state		    = attr->qp_state;
>+	resp.cur_qp_state	    = attr->cur_qp_state;
>+	resp.path_mtu		    = attr->path_mtu;
>+	resp.path_mig_state	    = attr->path_mig_state;
>+	resp.qkey		    = attr->qkey;
>+	resp.rq_psn		    = attr->rq_psn;
>+	resp.sq_psn		    = attr->sq_psn;
>+	resp.dest_qp_num	    = attr->dest_qp_num;
>+	resp.qp_access_flags	    = attr->qp_access_flags;
>+	resp.pkey_index		    = attr->pkey_index;
>+	resp.alt_pkey_index	    = attr->alt_pkey_index;
>+	resp.sq_draining	    = attr->sq_draining;
>+	resp.max_rd_atomic	    = attr->max_rd_atomic;
>+	resp.max_dest_rd_atomic	    = attr->max_dest_rd_atomic;
>+	resp.min_rnr_timer	    = attr->min_rnr_timer;
>+	resp.port_num		    = attr->port_num;
>+	resp.timeout		    = attr->timeout;
>+	resp.retry_cnt		    = attr->retry_cnt;
>+	resp.rnr_retry		    = attr->rnr_retry;
>+	resp.alt_port_num	    = attr->alt_port_num;
>+	resp.alt_timeout	    = attr->alt_timeout;
>+
>+	memcpy(resp.dest.dgid, attr->ah_attr.grh.dgid.raw, 16);
>+	resp.dest.flow_label	    = attr->ah_attr.grh.flow_label;
>+	resp.dest.sgid_index	    = attr->ah_attr.grh.sgid_index;
>+	resp.dest.hop_limit	    = attr->ah_attr.grh.hop_limit;
>+	resp.dest.traffic_class	    = attr->ah_attr.grh.traffic_class;
>+	resp.dest.dlid		    = attr->ah_attr.dlid;
>+	resp.dest.sl		    = attr->ah_attr.sl;
>+	resp.dest.src_path_bits	    = attr->ah_attr.src_path_bits;
>+	resp.dest.static_rate	    = attr->ah_attr.static_rate;
>+	resp.dest.is_global	    = !!(attr->ah_attr.ah_flags & IB_AH_GRH);
>+	resp.dest.port_num	    = attr->ah_attr.port_num;
>+
>+	memcpy(resp.alt_dest.dgid, attr->alt_ah_attr.grh.dgid.raw, 16);
>+	resp.alt_dest.flow_label    = attr->alt_ah_attr.grh.flow_label;
>+	resp.alt_dest.sgid_index    = attr->alt_ah_attr.grh.sgid_index;
>+	resp.alt_dest.hop_limit     = attr->alt_ah_attr.grh.hop_limit;
>+	resp.alt_dest.traffic_class = attr->alt_ah_attr.grh.traffic_class;
>+	resp.alt_dest.dlid	    = attr->alt_ah_attr.dlid;
>+	resp.alt_dest.sl	    = attr->alt_ah_attr.sl;
>+	resp.alt_dest.src_path_bits = attr->alt_ah_attr.src_path_bits;
>+	resp.alt_dest.static_rate   = attr->alt_ah_attr.static_rate;
>+	resp.alt_dest.is_global	    = !!(attr->alt_ah_attr.ah_flags &
IB_AH_GRH);
>+	resp.alt_dest.port_num	    = attr->alt_ah_attr.port_num;
>+
>+	resp.max_send_wr	    = init_attr->cap.max_send_wr;
>+	resp.max_recv_wr	    = init_attr->cap.max_recv_wr;
>+	resp.max_send_sge	    = init_attr->cap.max_send_sge;
>+	resp.max_recv_sge	    = init_attr->cap.max_recv_sge;
>+	resp.max_inline_data	    = init_attr->cap.max_inline_data;
>+	resp.sq_sig_all		    = init_attr->sq_sig_type ==
IB_SIGNAL_ALL_WR;

see comment below

>+
>+	if (copy_to_user((void __user *) (unsigned long) cmd.response,
>+			 &resp, sizeof resp))
>+		ret = -EFAULT;
>+
>+out:
>+	kfree(attr);
>+	kfree(init_attr);
>+
>+	return ret ? ret : in_len;
>+}
>+

>+struct ib_uverbs_create_xrc_rcv_qp {
>+	__u64 response;
>+	__u64 user_handle;
>+	__u32 xrcd_handle;
>+	__u8  reserved1[28];
>+	__u64 driver_data[0];
>+};
>+
>+struct ib_uverbs_create_xrc_rcv_qp_resp {
>+	__u32 qpn;
>+	__u32 reserved;
>+};
>+
>+struct ib_uverbs_modify_xrc_rcv_qp {
>+	__u32 xrc_domain_handle;
>+	__u32 qp_num;
>+	struct ib_uverbs_qp_dest dest;
>+	struct ib_uverbs_qp_dest alt_dest;
>+	__u32 attr_mask;
>+	__u32 qkey;
>+	__u32 rq_psn;
>+	__u32 sq_psn;
>+	__u32 dest_qp_num;
>+	__u32 qp_access_flags;
>+	__u16 pkey_index;
>+	__u16 alt_pkey_index;
>+	__u8  qp_state;
>+	__u8  cur_qp_state;
>+	__u8  path_mtu;
>+	__u8  path_mig_state;
>+	__u8  en_sqd_async_notify;
>+	__u8  max_rd_atomic;
>+	__u8  max_dest_rd_atomic;
>+	__u8  min_rnr_timer;
>+	__u8  port_num;
>+	__u8  timeout;
>+	__u8  retry_cnt;
>+	__u8  rnr_retry;
>+	__u8  alt_port_num;
>+	__u8  alt_timeout;
>+	__u8  reserved[6];
>+	__u64 driver_data[0];
>+};

This structure is almost identical to ib_uverbs_modify_qp.  It replaces
qp_handle with qp_num and adds xrc_domain_handle.  (Passing the qpn in as the
qp_handle makes sense.)  We should be able to extract out common code with
ib_uverbs_modify_qp and ib_uverbs_query_qp.
 
>+
>+struct ib_uverbs_query_xrc_rcv_qp {
>+	__u64 response;
>+	__u32 xrc_domain_handle;
>+	__u32 qp_num;
>+	__u32 attr_mask;
>+	__u32 reserved;
>+	__u64 driver_data[0];
>+};
>+
>+struct ib_uverbs_destroy_xrc_rcv_qp {
>+	__u32 xrc_domain_handle;
>+	__u32 qp_num;
>+	__u64 driver_data[0];
>+};
>+
>+struct ib_uverbs_reg_xrc_rcv_qp {
>+	__u32 xrc_domain_handle;
>+	__u32 qp_num;
>+	__u64 driver_data[0];
>+};
>+
>+struct ib_uverbs_unreg_xrc_rcv_qp {
>+	__u32 xrc_domain_handle;
>+	__u32 qp_num;
>+	__u64 driver_data[0];
>+};

It's a little odd to see the same structure layout defined 3 times.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
