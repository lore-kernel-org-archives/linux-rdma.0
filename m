From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH net-next] qed: Add srq core support for RoCE and iWARP
Date: Fri, 1 Jun 2018 11:41:22 +0800
Message-ID: <201806011135.5NKk4xI8%fengguang.wu@intel.com>
References: <20180530131137.4653-1-yuval.bason@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180530131137.4653-1-yuval.bason@cavium.com>
Sender: netdev-owner@vger.kernel.org
Cc: kbuild-all@01.org, yuval.bason@cavium.com, davem@davemloft.net, netdev@vger.kernel.org, jgg@mellanox.com, dledford@redhat.com, linux-rdma@vger.kernel.org, Michal Kalderon <michal.kalderon@cavium.com>, Ariel Elior <ariel.elior@cavium.com>
List-Id: linux-rdma@vger.kernel.org

Hi Yuval,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Yuval-Bason/qed-Add-srq-core-support-for-RoCE-and-iWARP/20180601-073407
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/net/ethernet/qlogic/qed/qed_rdma.c:137:5: sparse: symbol 'qed_rdma_get_sb_id' was not declared. Should it be static?
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:448:32: sparse: expression using sizeof(void)
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:448:32: sparse: expression using sizeof(void)
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:452:36: sparse: expression using sizeof(void)
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:452:36: sparse: expression using sizeof(void)
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:459:27: sparse: expression using sizeof(void)
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:459:27: sparse: expression using sizeof(void)
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:471:19: sparse: expression using sizeof(void)
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:471:19: sparse: expression using sizeof(void)
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:544:30: sparse: expression using sizeof(void)
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:709:5: sparse: symbol 'qed_rdma_stop' was not declared. Should it be static?
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:796:33: sparse: cast removes address space of expression
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:899:16: sparse: expression using sizeof(void)
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:899:16: sparse: expression using sizeof(void)
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:921:16: sparse: expression using sizeof(void)
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:921:16: sparse: expression using sizeof(void)
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1063:31: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] int_timeout @@    got unsignedrestricted __le16 [usertype] int_timeout @@
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1063:31:    expected restricted __le16 [usertype] int_timeout
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1063:31:    got unsigned short [unsigned] [usertype] int_timeout
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1165:21: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [short] [usertype] <noident> @@    got unsigned] [short] [usertype] <noident> @@
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1165:21:    expected unsigned short [unsigned] [short] [usertype] <noident>
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1165:21:    got restricted __le16 [usertype] <noident>
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1166:21: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [short] [usertype] <noident> @@    got unsigned] [short] [usertype] <noident> @@
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1166:21:    expected unsigned short [unsigned] [short] [usertype] <noident>
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1166:21:    got restricted __le16 [usertype] <noident>
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1167:21: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [short] [usertype] <noident> @@    got unsigned] [short] [usertype] <noident> @@
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1167:21:    expected unsigned short [unsigned] [short] [usertype] <noident>
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1167:21:    got restricted __le16 [usertype] <noident>
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1458:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1458:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1458:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1458:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1458:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1458:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1462:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1462:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1462:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1462:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1462:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1462:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1465:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1465:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1465:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1465:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1465:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1465:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1470:17: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1470:17:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1470:17:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1470:17: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1470:17:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1470:17:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1474:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1474:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1474:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1474:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1474:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1474:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1478:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1478:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1478:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1478:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1478:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1478:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1482:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1482:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1482:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1482:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1482:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1482:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1486:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1486:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1486:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1486:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1486:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1486:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1490:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1490:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1490:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1490:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1490:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1490:9:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1493:9: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1493:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1493:9:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1493:9: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1493:9:    left side has type restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1493:9:    right side has type unsigned long long
>> drivers/net/ethernet/qlogic/qed/qed_rdma.c:1679:29: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] wqe_limit @@    got restricted __le32 [usertype] wqe_limit @@
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1679:29:    expected restricted __le32 [usertype] wqe_limit
   drivers/net/ethernet/qlogic/qed/qed_rdma.c:1679:29:    got restricted __le16 [usertype] <noident>
>> drivers/net/ethernet/qlogic/qed/qed_rdma.c:1655:5: sparse: symbol 'qed_rdma_modify_srq' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_rdma.c:1691:5: sparse: symbol 'qed_rdma_destroy_srq' was not declared. Should it be static?
>> drivers/net/ethernet/qlogic/qed/qed_rdma.c:1734:5: sparse: symbol 'qed_rdma_create_srq' was not declared. Should it be static?

Please review and possibly fold the followup patch.

vim +1679 drivers/net/ethernet/qlogic/qed/qed_rdma.c

  1425	
  1426	static int
  1427	qed_rdma_register_tid(void *rdma_cxt,
  1428			      struct qed_rdma_register_tid_in_params *params)
  1429	{
  1430		struct qed_hwfn *p_hwfn = (struct qed_hwfn *)rdma_cxt;
  1431		struct rdma_register_tid_ramrod_data *p_ramrod;
  1432		struct qed_sp_init_data init_data;
  1433		struct qed_spq_entry *p_ent;
  1434		enum rdma_tid_type tid_type;
  1435		u8 fw_return_code;
  1436		int rc;
  1437	
  1438		DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "itid = %08x\n", params->itid);
  1439	
  1440		/* Get SPQ entry */
  1441		memset(&init_data, 0, sizeof(init_data));
  1442		init_data.opaque_fid = p_hwfn->hw_info.opaque_fid;
  1443		init_data.comp_mode = QED_SPQ_MODE_EBLOCK;
  1444	
  1445		rc = qed_sp_init_request(p_hwfn, &p_ent, RDMA_RAMROD_REGISTER_MR,
  1446					 p_hwfn->p_rdma_info->proto, &init_data);
  1447		if (rc) {
  1448			DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "rc = %d\n", rc);
  1449			return rc;
  1450		}
  1451	
  1452		if (p_hwfn->p_rdma_info->last_tid < params->itid)
  1453			p_hwfn->p_rdma_info->last_tid = params->itid;
  1454	
  1455		p_ramrod = &p_ent->ramrod.rdma_register_tid;
  1456	
  1457		p_ramrod->flags = 0;
  1458		SET_FIELD(p_ramrod->flags,
  1459			  RDMA_REGISTER_TID_RAMROD_DATA_TWO_LEVEL_PBL,
  1460			  params->pbl_two_level);
  1461	
  1462		SET_FIELD(p_ramrod->flags,
  1463			  RDMA_REGISTER_TID_RAMROD_DATA_ZERO_BASED, params->zbva);
  1464	
  1465		SET_FIELD(p_ramrod->flags,
  1466			  RDMA_REGISTER_TID_RAMROD_DATA_PHY_MR, params->phy_mr);
  1467	
  1468		/* Don't initialize D/C field, as it may override other bits. */
  1469		if (!(params->tid_type == QED_RDMA_TID_FMR) && !(params->dma_mr))
  1470			SET_FIELD(p_ramrod->flags,
  1471				  RDMA_REGISTER_TID_RAMROD_DATA_PAGE_SIZE_LOG,
  1472				  params->page_size_log - 12);
  1473	
  1474		SET_FIELD(p_ramrod->flags,
  1475			  RDMA_REGISTER_TID_RAMROD_DATA_REMOTE_READ,
  1476			  params->remote_read);
  1477	
  1478		SET_FIELD(p_ramrod->flags,
  1479			  RDMA_REGISTER_TID_RAMROD_DATA_REMOTE_WRITE,
  1480			  params->remote_write);
  1481	
  1482		SET_FIELD(p_ramrod->flags,
  1483			  RDMA_REGISTER_TID_RAMROD_DATA_REMOTE_ATOMIC,
  1484			  params->remote_atomic);
  1485	
  1486		SET_FIELD(p_ramrod->flags,
  1487			  RDMA_REGISTER_TID_RAMROD_DATA_LOCAL_WRITE,
  1488			  params->local_write);
  1489	
> 1490		SET_FIELD(p_ramrod->flags,
  1491			  RDMA_REGISTER_TID_RAMROD_DATA_LOCAL_READ, params->local_read);
  1492	
> 1493		SET_FIELD(p_ramrod->flags,
  1494			  RDMA_REGISTER_TID_RAMROD_DATA_ENABLE_MW_BIND,
  1495			  params->mw_bind);
  1496	
  1497		SET_FIELD(p_ramrod->flags1,
  1498			  RDMA_REGISTER_TID_RAMROD_DATA_PBL_PAGE_SIZE_LOG,
  1499			  params->pbl_page_size_log - 12);
  1500	
  1501		SET_FIELD(p_ramrod->flags2,
  1502			  RDMA_REGISTER_TID_RAMROD_DATA_DMA_MR, params->dma_mr);
  1503	
  1504		switch (params->tid_type) {
  1505		case QED_RDMA_TID_REGISTERED_MR:
  1506			tid_type = RDMA_TID_REGISTERED_MR;
  1507			break;
  1508		case QED_RDMA_TID_FMR:
  1509			tid_type = RDMA_TID_FMR;
  1510			break;
  1511		case QED_RDMA_TID_MW_TYPE1:
  1512			tid_type = RDMA_TID_MW_TYPE1;
  1513			break;
  1514		case QED_RDMA_TID_MW_TYPE2A:
  1515			tid_type = RDMA_TID_MW_TYPE2A;
  1516			break;
  1517		default:
  1518			rc = -EINVAL;
  1519			DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "rc = %d\n", rc);
  1520			return rc;
  1521		}
  1522		SET_FIELD(p_ramrod->flags1,
  1523			  RDMA_REGISTER_TID_RAMROD_DATA_TID_TYPE, tid_type);
  1524	
  1525		p_ramrod->itid = cpu_to_le32(params->itid);
  1526		p_ramrod->key = params->key;
  1527		p_ramrod->pd = cpu_to_le16(params->pd);
  1528		p_ramrod->length_hi = (u8)(params->length >> 32);
  1529		p_ramrod->length_lo = DMA_LO_LE(params->length);
  1530		if (params->zbva) {
  1531			/* Lower 32 bits of the registered MR address.
  1532			 * In case of zero based MR, will hold FBO
  1533			 */
  1534			p_ramrod->va.hi = 0;
  1535			p_ramrod->va.lo = cpu_to_le32(params->fbo);
  1536		} else {
  1537			DMA_REGPAIR_LE(p_ramrod->va, params->vaddr);
  1538		}
  1539		DMA_REGPAIR_LE(p_ramrod->pbl_base, params->pbl_ptr);
  1540	
  1541		/* DIF */
  1542		if (params->dif_enabled) {
  1543			SET_FIELD(p_ramrod->flags2,
  1544				  RDMA_REGISTER_TID_RAMROD_DATA_DIF_ON_HOST_FLG, 1);
  1545			DMA_REGPAIR_LE(p_ramrod->dif_error_addr,
  1546				       params->dif_error_addr);
  1547			DMA_REGPAIR_LE(p_ramrod->dif_runt_addr, params->dif_runt_addr);
  1548		}
  1549	
  1550		rc = qed_spq_post(p_hwfn, p_ent, &fw_return_code);
  1551		if (rc)
  1552			return rc;
  1553	
  1554		if (fw_return_code != RDMA_RETURN_OK) {
  1555			DP_NOTICE(p_hwfn, "fw_return_code = %d\n", fw_return_code);
  1556			return -EINVAL;
  1557		}
  1558	
  1559		DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "Register TID, rc = %d\n", rc);
  1560		return rc;
  1561	}
  1562	
  1563	static int qed_rdma_deregister_tid(void *rdma_cxt, u32 itid)
  1564	{
  1565		struct qed_hwfn *p_hwfn = (struct qed_hwfn *)rdma_cxt;
  1566		struct rdma_deregister_tid_ramrod_data *p_ramrod;
  1567		struct qed_sp_init_data init_data;
  1568		struct qed_spq_entry *p_ent;
  1569		struct qed_ptt *p_ptt;
  1570		u8 fw_return_code;
  1571		int rc;
  1572	
  1573		DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "itid = %08x\n", itid);
  1574	
  1575		/* Get SPQ entry */
  1576		memset(&init_data, 0, sizeof(init_data));
  1577		init_data.opaque_fid = p_hwfn->hw_info.opaque_fid;
  1578		init_data.comp_mode = QED_SPQ_MODE_EBLOCK;
  1579	
  1580		rc = qed_sp_init_request(p_hwfn, &p_ent, RDMA_RAMROD_DEREGISTER_MR,
  1581					 p_hwfn->p_rdma_info->proto, &init_data);
  1582		if (rc) {
  1583			DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "rc = %d\n", rc);
  1584			return rc;
  1585		}
  1586	
  1587		p_ramrod = &p_ent->ramrod.rdma_deregister_tid;
  1588		p_ramrod->itid = cpu_to_le32(itid);
  1589	
  1590		rc = qed_spq_post(p_hwfn, p_ent, &fw_return_code);
  1591		if (rc) {
  1592			DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "rc = %d\n", rc);
  1593			return rc;
  1594		}
  1595	
  1596		if (fw_return_code == RDMA_RETURN_DEREGISTER_MR_BAD_STATE_ERR) {
  1597			DP_NOTICE(p_hwfn, "fw_return_code = %d\n", fw_return_code);
  1598			return -EINVAL;
  1599		} else if (fw_return_code == RDMA_RETURN_NIG_DRAIN_REQ) {
  1600			/* Bit indicating that the TID is in use and a nig drain is
  1601			 * required before sending the ramrod again
  1602			 */
  1603			p_ptt = qed_ptt_acquire(p_hwfn);
  1604			if (!p_ptt) {
  1605				rc = -EBUSY;
  1606				DP_VERBOSE(p_hwfn, QED_MSG_RDMA,
  1607					   "Failed to acquire PTT\n");
  1608				return rc;
  1609			}
  1610	
  1611			rc = qed_mcp_drain(p_hwfn, p_ptt);
  1612			if (rc) {
  1613				qed_ptt_release(p_hwfn, p_ptt);
  1614				DP_VERBOSE(p_hwfn, QED_MSG_RDMA,
  1615					   "Drain failed\n");
  1616				return rc;
  1617			}
  1618	
  1619			qed_ptt_release(p_hwfn, p_ptt);
  1620	
  1621			/* Resend the ramrod */
  1622			rc = qed_sp_init_request(p_hwfn, &p_ent,
  1623						 RDMA_RAMROD_DEREGISTER_MR,
  1624						 p_hwfn->p_rdma_info->proto,
  1625						 &init_data);
  1626			if (rc) {
  1627				DP_VERBOSE(p_hwfn, QED_MSG_RDMA,
  1628					   "Failed to init sp-element\n");
  1629				return rc;
  1630			}
  1631	
  1632			rc = qed_spq_post(p_hwfn, p_ent, &fw_return_code);
  1633			if (rc) {
  1634				DP_VERBOSE(p_hwfn, QED_MSG_RDMA,
  1635					   "Ramrod failed\n");
  1636				return rc;
  1637			}
  1638	
  1639			if (fw_return_code != RDMA_RETURN_OK) {
  1640				DP_NOTICE(p_hwfn, "fw_return_code = %d\n",
  1641					  fw_return_code);
  1642				return rc;
  1643			}
  1644		}
  1645	
  1646		DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "De-registered TID, rc = %d\n", rc);
  1647		return rc;
  1648	}
  1649	
  1650	static void *qed_rdma_get_rdma_ctx(struct qed_dev *cdev)
  1651	{
  1652		return QED_LEADING_HWFN(cdev);
  1653	}
  1654	
> 1655	int qed_rdma_modify_srq(void *rdma_cxt,
  1656				struct qed_rdma_modify_srq_in_params *in_params)
  1657	{
  1658		struct rdma_srq_modify_ramrod_data *p_ramrod;
  1659		struct qed_hwfn *p_hwfn = rdma_cxt;
  1660		struct qed_sp_init_data init_data;
  1661		struct qed_spq_entry *p_ent;
  1662		u16 opaque_fid;
  1663		int rc;
  1664	
  1665		memset(&init_data, 0, sizeof(init_data));
  1666		init_data.opaque_fid = p_hwfn->hw_info.opaque_fid;
  1667		init_data.comp_mode = QED_SPQ_MODE_EBLOCK;
  1668	
  1669		rc = qed_sp_init_request(p_hwfn, &p_ent,
  1670					 RDMA_RAMROD_MODIFY_SRQ,
  1671					 p_hwfn->p_rdma_info->proto, &init_data);
  1672		if (rc)
  1673			return rc;
  1674	
  1675		p_ramrod = &p_ent->ramrod.rdma_modify_srq;
  1676		p_ramrod->srq_id.srq_idx = cpu_to_le16(in_params->srq_id);
  1677		opaque_fid = p_hwfn->hw_info.opaque_fid;
  1678		p_ramrod->srq_id.opaque_fid = cpu_to_le16(opaque_fid);
> 1679		p_ramrod->wqe_limit = cpu_to_le16(in_params->wqe_limit);
  1680	
  1681		rc = qed_spq_post(p_hwfn, p_ent, NULL);
  1682		if (rc)
  1683			return rc;
  1684	
  1685		DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "modified SRQ id = %x",
  1686			   in_params->srq_id);
  1687	
  1688		return rc;
  1689	}
  1690	
> 1691	int qed_rdma_destroy_srq(void *rdma_cxt,
  1692				 struct qed_rdma_destroy_srq_in_params *in_params)
  1693	{
  1694		struct rdma_srq_destroy_ramrod_data *p_ramrod;
  1695		struct qed_hwfn *p_hwfn = rdma_cxt;
  1696		struct qed_sp_init_data init_data;
  1697		struct qed_spq_entry *p_ent;
  1698		struct qed_bmap *bmap;
  1699		u16 opaque_fid;
  1700		int rc;
  1701	
  1702		opaque_fid = p_hwfn->hw_info.opaque_fid;
  1703	
  1704		memset(&init_data, 0, sizeof(init_data));
  1705		init_data.opaque_fid = opaque_fid;
  1706		init_data.comp_mode = QED_SPQ_MODE_EBLOCK;
  1707	
  1708		rc = qed_sp_init_request(p_hwfn, &p_ent,
  1709					 RDMA_RAMROD_DESTROY_SRQ,
  1710					 p_hwfn->p_rdma_info->proto, &init_data);
  1711		if (rc)
  1712			return rc;
  1713	
  1714		p_ramrod = &p_ent->ramrod.rdma_destroy_srq;
  1715		p_ramrod->srq_id.srq_idx = cpu_to_le16(in_params->srq_id);
  1716		p_ramrod->srq_id.opaque_fid = cpu_to_le16(opaque_fid);
  1717	
  1718		rc = qed_spq_post(p_hwfn, p_ent, NULL);
  1719		if (rc)
  1720			return rc;
  1721	
  1722		bmap = &p_hwfn->p_rdma_info->srq_map;
  1723	
  1724		spin_lock_bh(&p_hwfn->p_rdma_info->lock);
  1725		qed_bmap_release_id(p_hwfn, bmap, in_params->srq_id);
  1726		spin_unlock_bh(&p_hwfn->p_rdma_info->lock);
  1727	
  1728		DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "SRQ destroyed Id = %x",
  1729			   in_params->srq_id);
  1730	
  1731		return rc;
  1732	}
  1733	
> 1734	int qed_rdma_create_srq(void *rdma_cxt,
  1735				struct qed_rdma_create_srq_in_params *in_params,
  1736				struct qed_rdma_create_srq_out_params *out_params)
  1737	{
  1738		struct rdma_srq_create_ramrod_data *p_ramrod;
  1739		struct qed_hwfn *p_hwfn = rdma_cxt;
  1740		struct qed_sp_init_data init_data;
  1741		enum qed_cxt_elem_type elem_type;
  1742		struct qed_spq_entry *p_ent;
  1743		u16 opaque_fid, srq_id;
  1744		struct qed_bmap *bmap;
  1745		u32 returned_id;
  1746		int rc;
  1747	
  1748		bmap = &p_hwfn->p_rdma_info->srq_map;
  1749		spin_lock_bh(&p_hwfn->p_rdma_info->lock);
  1750		rc = qed_rdma_bmap_alloc_id(p_hwfn, bmap, &returned_id);
  1751		spin_unlock_bh(&p_hwfn->p_rdma_info->lock);
  1752	
  1753		if (rc) {
  1754			DP_NOTICE(p_hwfn, "failed to allocate srq id\n");
  1755			return rc;
  1756		}
  1757	
  1758		elem_type = QED_ELEM_SRQ;
  1759		rc = qed_cxt_dynamic_ilt_alloc(p_hwfn, elem_type, returned_id);
  1760		if (rc)
  1761			goto err;
  1762		/* returned id is no greater than u16 */
  1763		srq_id = (u16)returned_id;
  1764		opaque_fid = p_hwfn->hw_info.opaque_fid;
  1765	
  1766		memset(&init_data, 0, sizeof(init_data));
  1767		opaque_fid = p_hwfn->hw_info.opaque_fid;
  1768		init_data.opaque_fid = opaque_fid;
  1769		init_data.comp_mode = QED_SPQ_MODE_EBLOCK;
  1770	
  1771		rc = qed_sp_init_request(p_hwfn, &p_ent,
  1772					 RDMA_RAMROD_CREATE_SRQ,
  1773					 p_hwfn->p_rdma_info->proto, &init_data);
  1774		if (rc)
  1775			goto err;
  1776	
  1777		p_ramrod = &p_ent->ramrod.rdma_create_srq;
  1778		DMA_REGPAIR_LE(p_ramrod->pbl_base_addr, in_params->pbl_base_addr);
  1779		p_ramrod->pages_in_srq_pbl = cpu_to_le16(in_params->num_pages);
  1780		p_ramrod->pd_id = cpu_to_le16(in_params->pd_id);
  1781		p_ramrod->srq_id.srq_idx = cpu_to_le16(srq_id);
  1782		p_ramrod->srq_id.opaque_fid = cpu_to_le16(opaque_fid);
  1783		p_ramrod->page_size = cpu_to_le16(in_params->page_size);
  1784		DMA_REGPAIR_LE(p_ramrod->producers_addr, in_params->prod_pair_addr);
  1785	
  1786		rc = qed_spq_post(p_hwfn, p_ent, NULL);
  1787		if (rc)
  1788			goto err;
  1789	
  1790		out_params->srq_id = srq_id;
  1791	
  1792		DP_VERBOSE(p_hwfn, QED_MSG_RDMA,
  1793			   "SRQ created Id = %x\n", out_params->srq_id);
  1794	
  1795		return rc;
  1796	
  1797	err:
  1798		spin_lock_bh(&p_hwfn->p_rdma_info->lock);
  1799		qed_bmap_release_id(p_hwfn, bmap, returned_id);
  1800		spin_unlock_bh(&p_hwfn->p_rdma_info->lock);
  1801	
  1802		return rc;
  1803	}
  1804	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
