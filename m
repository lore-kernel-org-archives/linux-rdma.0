From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] IB/mlx4: Add support for WQ related verbs
Date: Wed, 2 Aug 2017 00:41:09 +0300
Message-ID: <20170801214109.5nck54mf3tyq5knn@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Guy Levi,

This is a semi-automatic email about new static checker warnings.

The patch 400b1ebcfe31: "IB/mlx4: Add support for WQ related verbs"
from Jul 4, 2017, leads to the following Smatch complaint:

    drivers/infiniband/hw/mlx4/qp.c:1203 create_qp_common()
    error: we previously assumed 'pd->uobject' could be null (see line 1033)

drivers/infiniband/hw/mlx4/qp.c
  1032	
  1033		if (pd->uobject) {
                    ^^^^^^^^^^^
New check for NULL.

  1034			union {
  1035				struct mlx4_ib_create_qp qp;
  1036				struct mlx4_ib_create_wq wq;
  1037			} ucmd;
  1038			size_t copy_len;
  1039	
  1040			copy_len = (src == MLX4_IB_QP_SRC) ?
  1041				   sizeof(struct mlx4_ib_create_qp) :
  1042				   min(sizeof(struct mlx4_ib_create_wq), udata->inlen);
  1043	
  1044			if (ib_copy_from_udata(&ucmd, udata, copy_len)) {
  1045				err = -EFAULT;
  1046				goto err;
  1047			}
  1048	
  1049			if (src == MLX4_IB_RWQ_SRC) {
  1050				if (ucmd.wq.comp_mask || ucmd.wq.reserved1 ||
  1051				    ucmd.wq.reserved[0] || ucmd.wq.reserved[1] ||
  1052				    ucmd.wq.reserved[2]) {
  1053					pr_debug("user command isn't supported\n");
  1054					err = -EOPNOTSUPP;
  1055					goto err;
  1056				}
  1057	
  1058				if (ucmd.wq.log_range_size >
  1059				    ilog2(dev->dev->caps.max_rss_tbl_sz)) {
  1060					pr_debug("WQN range size must be equal or smaller than %d\n",
  1061						 dev->dev->caps.max_rss_tbl_sz);
  1062					err = -EOPNOTSUPP;
  1063					goto err;
  1064				}
  1065				range_size = 1 << ucmd.wq.log_range_size;
  1066			} else {
  1067				qp->inl_recv_sz = ucmd.qp.inl_recv_sz;
  1068			}
  1069	
  1070			err = set_rq_size(dev, &init_attr->cap, !!pd->uobject,
                                                                  ^^^^^^^^^^^
Not necessary check for NULL.

  1071					  qp_has_rq(init_attr), qp, qp->inl_recv_sz);
  1072			if (err)
  1073				goto err;
  1074	
  1075			if (src == MLX4_IB_QP_SRC) {
  1076				qp->sq_no_prefetch = ucmd.qp.sq_no_prefetch;
  1077	
  1078				err = set_user_sq_size(dev, qp,
  1079						       (struct mlx4_ib_create_qp *)
  1080						       &ucmd);
  1081				if (err)
  1082					goto err;
  1083			} else {
  1084				qp->sq_no_prefetch = 1;
  1085				qp->sq.wqe_cnt = 1;
  1086				qp->sq.wqe_shift = MLX4_IB_MIN_SQ_STRIDE;
  1087				/* Allocated buffer expects to have at least that SQ
  1088				 * size.
  1089				 */
  1090				qp->buf_size = (qp->rq.wqe_cnt << qp->rq.wqe_shift) +
  1091					(qp->sq.wqe_cnt << qp->sq.wqe_shift);
  1092			}
  1093	
  1094			qp->umem = ib_umem_get(pd->uobject->context,
  1095					(src == MLX4_IB_QP_SRC) ? ucmd.qp.buf_addr :
  1096					ucmd.wq.buf_addr, qp->buf_size, 0, 0);
  1097			if (IS_ERR(qp->umem)) {
  1098				err = PTR_ERR(qp->umem);
  1099				goto err;
  1100			}
  1101	
  1102			err = mlx4_mtt_init(dev->dev, ib_umem_page_count(qp->umem),
  1103					    qp->umem->page_shift, &qp->mtt);
  1104			if (err)
  1105				goto err_buf;
  1106	
  1107			err = mlx4_ib_umem_write_mtt(dev, &qp->mtt, qp->umem);
  1108			if (err)
  1109				goto err_mtt;
  1110	
  1111			if (qp_has_rq(init_attr)) {
  1112				err = mlx4_ib_db_map_user(to_mucontext(pd->uobject->context),
  1113					(src == MLX4_IB_QP_SRC) ? ucmd.qp.db_addr :
  1114					ucmd.wq.db_addr, &qp->db);
  1115				if (err)
  1116					goto err_mtt;
  1117			}
  1118			qp->mqp.usage = MLX4_RES_USAGE_USER_VERBS;
  1119		} else {
  1120			err = set_rq_size(dev, &init_attr->cap, !!pd->uobject,
                                                                ^^^^^^^^^^^^^
Always NULL now.

  1121					  qp_has_rq(init_attr), qp, 0);
  1122			if (err)
  1123				goto err;
  1124	
  1125			qp->sq_no_prefetch = 0;
  1126	
  1127			if (init_attr->create_flags & IB_QP_CREATE_IPOIB_UD_LSO)
  1128				qp->flags |= MLX4_IB_QP_LSO;
  1129	
  1130			if (init_attr->create_flags & IB_QP_CREATE_NETIF_QP) {
  1131				if (dev->steering_support ==
  1132				    MLX4_STEERING_MODE_DEVICE_MANAGED)
  1133					qp->flags |= MLX4_IB_QP_NETIF;
  1134				else
  1135					goto err;
  1136			}
  1137	
  1138			memcpy(&backup_cap, &init_attr->cap, sizeof(backup_cap));
  1139			err = set_kernel_sq_size(dev, &init_attr->cap,
  1140						 qp_type, qp, true);
  1141			if (err)
  1142				goto err;
  1143	
  1144			if (qp_has_rq(init_attr)) {
  1145				err = mlx4_db_alloc(dev->dev, &qp->db, 0);
  1146				if (err)
  1147					goto err;
  1148	
  1149				*qp->db.db = 0;
  1150			}
  1151	
  1152			if (mlx4_buf_alloc(dev->dev, qp->buf_size, qp->buf_size,
  1153					   &qp->buf)) {
  1154				memcpy(&init_attr->cap, &backup_cap,
  1155				       sizeof(backup_cap));
  1156				err = set_kernel_sq_size(dev, &init_attr->cap, qp_type,
  1157							 qp, false);
  1158				if (err)
  1159					goto err_db;
  1160	
  1161				if (mlx4_buf_alloc(dev->dev, qp->buf_size,
  1162						   PAGE_SIZE * 2, &qp->buf)) {
  1163					err = -ENOMEM;
  1164					goto err_db;
  1165				}
  1166			}
  1167	
  1168			err = mlx4_mtt_init(dev->dev, qp->buf.npages, qp->buf.page_shift,
  1169					    &qp->mtt);
  1170			if (err)
  1171				goto err_buf;
  1172	
  1173			err = mlx4_buf_write_mtt(dev->dev, &qp->mtt, &qp->buf);
  1174			if (err)
  1175				goto err_mtt;
  1176	
  1177			qp->sq.wrid = kmalloc_array(qp->sq.wqe_cnt, sizeof(u64),
  1178						GFP_KERNEL | __GFP_NOWARN);
  1179			if (!qp->sq.wrid)
  1180				qp->sq.wrid = __vmalloc(qp->sq.wqe_cnt * sizeof(u64),
  1181							GFP_KERNEL, PAGE_KERNEL);
  1182			qp->rq.wrid = kmalloc_array(qp->rq.wqe_cnt, sizeof(u64),
  1183						GFP_KERNEL | __GFP_NOWARN);
  1184			if (!qp->rq.wrid)
  1185				qp->rq.wrid = __vmalloc(qp->rq.wqe_cnt * sizeof(u64),
  1186							GFP_KERNEL, PAGE_KERNEL);
  1187			if (!qp->sq.wrid || !qp->rq.wrid) {
  1188				err = -ENOMEM;
  1189				goto err_wrid;
  1190			}
  1191			qp->mqp.usage = MLX4_RES_USAGE_DRIVER;
  1192		}
  1193	
  1194		if (sqpn) {
  1195			if (qp->mlx4_ib_qp_type & (MLX4_IB_QPT_PROXY_SMI_OWNER |
  1196			    MLX4_IB_QPT_PROXY_SMI | MLX4_IB_QPT_PROXY_GSI)) {
  1197				if (alloc_proxy_bufs(pd->device, qp)) {
  1198					err = -ENOMEM;
  1199					goto err_wrid;
  1200				}
  1201			}
  1202		} else if (src == MLX4_IB_RWQ_SRC) {
  1203			err = mlx4_ib_alloc_wqn(to_mucontext(pd->uobject->context), qp,
                                                             ^^^^^^^^^^^^^^^^^^^^
Unchecked dereference.

  1204						range_size, &qpn);
  1205			if (err)

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
