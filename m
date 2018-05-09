From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH IB/core 2/2] IB/cm: Send authentic pkey in REQ msg and
 check eligibility of the pkeys
Date: Thu, 10 May 2018 02:11:07 +0800
Message-ID: <201805100003.S3e3lOUG%fengguang.wu@intel.com>
References: <20180509093020.24503-3-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180509093020.24503-3-Haakon.Bugge@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?Q?H=E5kon?= Bugge <Haakon.Bugge@oracle.com>
Cc: kbuild-all@01.org, Doug Ledford <dledford@redhat.com>, Don Hiatt <don.hiatt@intel.com>, Ira Weiny <ira.weiny@intel.com>, Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>
List-Id: linux-rdma@vger.kernel.org

Hi Håkon,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v4.17-rc4 next-20180509]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/H-kon-Bugge/Do-not-form-IB-connections-between-limited-partition-members/20180509-224727
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/infiniband/core/cm.c:880:16: sparse: expression using sizeof(void)
   drivers/infiniband/core/cm.c:861:21: sparse: expression using sizeof(void)
>> drivers/infiniband/core/cm.c:1246:25: sparse: cast from restricted __be16
>> drivers/infiniband/core/cm.c:1246:25: sparse: incorrect type in argument 1 (different base types) @@    expected unsigned short [unsigned] [usertype] val @@    got  short [unsigned] [usertype] val @@
   drivers/infiniband/core/cm.c:1246:25:    expected unsigned short [unsigned] [usertype] val
   drivers/infiniband/core/cm.c:1246:25:    got restricted __be16 [usertype] pkey
>> drivers/infiniband/core/cm.c:1246:25: sparse: cast from restricted __be16
>> drivers/infiniband/core/cm.c:1246:25: sparse: cast from restricted __be16
   drivers/infiniband/core/cm.c:861:21: sparse: expression using sizeof(void)
   drivers/infiniband/core/cm.c:861:21: sparse: expression using sizeof(void)
>> drivers/infiniband/core/cm.c:1414:35: sparse: incorrect type in argument 4 (different base types) @@    expected unsigned short [usertype] *pkey @@    got  short [usertype] *pkey @@
   drivers/infiniband/core/cm.c:1414:35:    expected unsigned short [usertype] *pkey
   drivers/infiniband/core/cm.c:1414:35:    got restricted __be16 *<noident>
   drivers/infiniband/core/cm.c:861:21: sparse: expression using sizeof(void)
   drivers/infiniband/core/cm.c:861:21: sparse: expression using sizeof(void)
   drivers/infiniband/core/cm.c:861:21: sparse: expression using sizeof(void)

vim +1246 drivers/infiniband/core/cm.c

  1218	
  1219	static void cm_format_req(struct cm_req_msg *req_msg,
  1220				  struct cm_id_private *cm_id_priv,
  1221				  struct ib_cm_req_param *param)
  1222	{
  1223		struct sa_path_rec *pri_path = param->primary_path;
  1224		struct sa_path_rec *alt_path = param->alternate_path;
  1225		bool pri_ext = false;
  1226	
  1227		if (pri_path->rec_type == SA_PATH_REC_TYPE_OPA)
  1228			pri_ext = opa_is_extended_lid(pri_path->opa.dlid,
  1229						      pri_path->opa.slid);
  1230	
  1231		cm_format_mad_hdr(&req_msg->hdr, CM_REQ_ATTR_ID,
  1232				  cm_form_tid(cm_id_priv, CM_MSG_SEQUENCE_REQ));
  1233	
  1234		req_msg->local_comm_id = cm_id_priv->id.local_id;
  1235		req_msg->service_id = param->service_id;
  1236		req_msg->local_ca_guid = cm_id_priv->id.device->node_guid;
  1237		cm_req_set_local_qpn(req_msg, cpu_to_be32(param->qp_num));
  1238		cm_req_set_init_depth(req_msg, param->initiator_depth);
  1239		cm_req_set_remote_resp_timeout(req_msg,
  1240					       param->remote_cm_response_timeout);
  1241		cm_req_set_qp_type(req_msg, param->qp_type);
  1242		cm_req_set_flow_ctrl(req_msg, param->flow_control);
  1243		cm_req_set_starting_psn(req_msg, cpu_to_be32(param->starting_psn));
  1244		cm_req_set_local_resp_timeout(req_msg,
  1245					      param->local_cm_response_timeout);
> 1246		req_msg->pkey = cpu_to_be16(cm_id_priv->pkey);
  1247		cm_req_set_path_mtu(req_msg, param->primary_path->mtu);
  1248		cm_req_set_max_cm_retries(req_msg, param->max_cm_retries);
  1249	
  1250		if (param->qp_type != IB_QPT_XRC_INI) {
  1251			cm_req_set_resp_res(req_msg, param->responder_resources);
  1252			cm_req_set_retry_count(req_msg, param->retry_count);
  1253			cm_req_set_rnr_retry_count(req_msg, param->rnr_retry_count);
  1254			cm_req_set_srq(req_msg, param->srq);
  1255		}
  1256	
  1257		req_msg->primary_local_gid = pri_path->sgid;
  1258		req_msg->primary_remote_gid = pri_path->dgid;
  1259		if (pri_ext) {
  1260			req_msg->primary_local_gid.global.interface_id
  1261				= OPA_MAKE_ID(be32_to_cpu(pri_path->opa.slid));
  1262			req_msg->primary_remote_gid.global.interface_id
  1263				= OPA_MAKE_ID(be32_to_cpu(pri_path->opa.dlid));
  1264		}
  1265		if (pri_path->hop_limit <= 1) {
  1266			req_msg->primary_local_lid = pri_ext ? 0 :
  1267				htons(ntohl(sa_path_get_slid(pri_path)));
  1268			req_msg->primary_remote_lid = pri_ext ? 0 :
  1269				htons(ntohl(sa_path_get_dlid(pri_path)));
  1270		} else {
  1271			/* Work-around until there's a way to obtain remote LID info */
  1272			req_msg->primary_local_lid = IB_LID_PERMISSIVE;
  1273			req_msg->primary_remote_lid = IB_LID_PERMISSIVE;
  1274		}
  1275		cm_req_set_primary_flow_label(req_msg, pri_path->flow_label);
  1276		cm_req_set_primary_packet_rate(req_msg, pri_path->rate);
  1277		req_msg->primary_traffic_class = pri_path->traffic_class;
  1278		req_msg->primary_hop_limit = pri_path->hop_limit;
  1279		cm_req_set_primary_sl(req_msg, pri_path->sl);
  1280		cm_req_set_primary_subnet_local(req_msg, (pri_path->hop_limit <= 1));
  1281		cm_req_set_primary_local_ack_timeout(req_msg,
  1282			cm_ack_timeout(cm_id_priv->av.port->cm_dev->ack_delay,
  1283				       pri_path->packet_life_time));
  1284	
  1285		if (alt_path) {
  1286			bool alt_ext = false;
  1287	
  1288			if (alt_path->rec_type == SA_PATH_REC_TYPE_OPA)
  1289				alt_ext = opa_is_extended_lid(alt_path->opa.dlid,
  1290							      alt_path->opa.slid);
  1291	
  1292			req_msg->alt_local_gid = alt_path->sgid;
  1293			req_msg->alt_remote_gid = alt_path->dgid;
  1294			if (alt_ext) {
  1295				req_msg->alt_local_gid.global.interface_id
  1296					= OPA_MAKE_ID(be32_to_cpu(alt_path->opa.slid));
  1297				req_msg->alt_remote_gid.global.interface_id
  1298					= OPA_MAKE_ID(be32_to_cpu(alt_path->opa.dlid));
  1299			}
  1300			if (alt_path->hop_limit <= 1) {
  1301				req_msg->alt_local_lid = alt_ext ? 0 :
  1302					htons(ntohl(sa_path_get_slid(alt_path)));
  1303				req_msg->alt_remote_lid = alt_ext ? 0 :
  1304					htons(ntohl(sa_path_get_dlid(alt_path)));
  1305			} else {
  1306				req_msg->alt_local_lid = IB_LID_PERMISSIVE;
  1307				req_msg->alt_remote_lid = IB_LID_PERMISSIVE;
  1308			}
  1309			cm_req_set_alt_flow_label(req_msg,
  1310						  alt_path->flow_label);
  1311			cm_req_set_alt_packet_rate(req_msg, alt_path->rate);
  1312			req_msg->alt_traffic_class = alt_path->traffic_class;
  1313			req_msg->alt_hop_limit = alt_path->hop_limit;
  1314			cm_req_set_alt_sl(req_msg, alt_path->sl);
  1315			cm_req_set_alt_subnet_local(req_msg, (alt_path->hop_limit <= 1));
  1316			cm_req_set_alt_local_ack_timeout(req_msg,
  1317				cm_ack_timeout(cm_id_priv->av.port->cm_dev->ack_delay,
  1318					       alt_path->packet_life_time));
  1319		}
  1320	
  1321		if (param->private_data && param->private_data_len)
  1322			memcpy(req_msg->private_data, param->private_data,
  1323			       param->private_data_len);
  1324	}
  1325	
  1326	static int cm_validate_req_param(struct ib_cm_req_param *param)
  1327	{
  1328		/* peer-to-peer not supported */
  1329		if (param->peer_to_peer)
  1330			return -EINVAL;
  1331	
  1332		if (!param->primary_path)
  1333			return -EINVAL;
  1334	
  1335		if (param->qp_type != IB_QPT_RC && param->qp_type != IB_QPT_UC &&
  1336		    param->qp_type != IB_QPT_XRC_INI)
  1337			return -EINVAL;
  1338	
  1339		if (param->private_data &&
  1340		    param->private_data_len > IB_CM_REQ_PRIVATE_DATA_SIZE)
  1341			return -EINVAL;
  1342	
  1343		if (param->alternate_path &&
  1344		    (param->alternate_path->pkey != param->primary_path->pkey ||
  1345		     param->alternate_path->mtu != param->primary_path->mtu))
  1346			return -EINVAL;
  1347	
  1348		return 0;
  1349	}
  1350	
  1351	int ib_send_cm_req(struct ib_cm_id *cm_id,
  1352			   struct ib_cm_req_param *param)
  1353	{
  1354		struct cm_id_private *cm_id_priv;
  1355		struct cm_req_msg *req_msg;
  1356		unsigned long flags;
  1357		int ret;
  1358	
  1359		ret = cm_validate_req_param(param);
  1360		if (ret)
  1361			return ret;
  1362	
  1363		/* Verify that we're not in timewait. */
  1364		cm_id_priv = container_of(cm_id, struct cm_id_private, id);
  1365		spin_lock_irqsave(&cm_id_priv->lock, flags);
  1366		if (cm_id->state != IB_CM_IDLE) {
  1367			spin_unlock_irqrestore(&cm_id_priv->lock, flags);
  1368			ret = -EINVAL;
  1369			goto out;
  1370		}
  1371		spin_unlock_irqrestore(&cm_id_priv->lock, flags);
  1372	
  1373		cm_id_priv->timewait_info = cm_create_timewait_info(cm_id_priv->
  1374								    id.local_id);
  1375		if (IS_ERR(cm_id_priv->timewait_info)) {
  1376			ret = PTR_ERR(cm_id_priv->timewait_info);
  1377			goto out;
  1378		}
  1379	
  1380		ret = cm_init_av_by_path(param->primary_path, &cm_id_priv->av,
  1381					 cm_id_priv);
  1382		if (ret)
  1383			goto error1;
  1384		if (param->alternate_path) {
  1385			ret = cm_init_av_by_path(param->alternate_path,
  1386						 &cm_id_priv->alt_av, cm_id_priv);
  1387			if (ret)
  1388				goto error1;
  1389		}
  1390		cm_id->service_id = param->service_id;
  1391		cm_id->service_mask = ~cpu_to_be64(0);
  1392		cm_id_priv->timeout_ms = cm_convert_to_ms(
  1393					    param->primary_path->packet_life_time) * 2 +
  1394					 cm_convert_to_ms(
  1395					    param->remote_cm_response_timeout);
  1396		cm_id_priv->max_cm_retries = param->max_cm_retries;
  1397		cm_id_priv->initiator_depth = param->initiator_depth;
  1398		cm_id_priv->responder_resources = param->responder_resources;
  1399		cm_id_priv->retry_count = param->retry_count;
  1400		cm_id_priv->path_mtu = param->primary_path->mtu;
  1401	
  1402		/*
  1403		 * We want to send the pkey used in the BTH in packets
  1404		 * sent. This, in order for the passive side to determine if
  1405		 * communication is permitted by the respective pkeys.
  1406		 *
  1407		 * The pkey in the paths are derived from the MGID, which has
  1408		 * the full membership bit set. Hence, we retrieve the pkey by
  1409		 * using the address vector's pkey_index.
  1410		 */
  1411		ret = ib_get_cached_pkey(cm_id_priv->id.device,
  1412					 cm_id_priv->av.port->port_num,
  1413					 cm_id_priv->av.pkey_index,
> 1414					 &cm_id_priv->pkey);
  1415		if (ret)
  1416			goto error1;
  1417	
  1418		cm_id_priv->qp_type = param->qp_type;
  1419	
  1420		ret = cm_alloc_msg(cm_id_priv, &cm_id_priv->msg);
  1421		if (ret)
  1422			goto error1;
  1423	
  1424		req_msg = (struct cm_req_msg *) cm_id_priv->msg->mad;
  1425		cm_format_req(req_msg, cm_id_priv, param);
  1426		cm_id_priv->tid = req_msg->hdr.tid;
  1427		cm_id_priv->msg->timeout_ms = cm_id_priv->timeout_ms;
  1428		cm_id_priv->msg->context[1] = (void *) (unsigned long) IB_CM_REQ_SENT;
  1429	
  1430		cm_id_priv->local_qpn = cm_req_get_local_qpn(req_msg);
  1431		cm_id_priv->rq_psn = cm_req_get_starting_psn(req_msg);
  1432	
  1433		spin_lock_irqsave(&cm_id_priv->lock, flags);
  1434		ret = ib_post_send_mad(cm_id_priv->msg, NULL);
  1435		if (ret) {
  1436			spin_unlock_irqrestore(&cm_id_priv->lock, flags);
  1437			goto error2;
  1438		}
  1439		BUG_ON(cm_id->state != IB_CM_IDLE);
  1440		cm_id->state = IB_CM_REQ_SENT;
  1441		spin_unlock_irqrestore(&cm_id_priv->lock, flags);
  1442		return 0;
  1443	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
