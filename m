From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2 3/4] IB/hw: cleanup of incorrect pd->uobject
 usage
Date: Thu, 18 Oct 2018 15:22:45 +0300
Message-ID: <20181018122245.isyjqkcdskyyt5ch@mwanda>
References: <20181014055345.25348-4-shamir.rabinovitch@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kbuild-bounces@lists.01.org>
Content-Disposition: inline
In-Reply-To: <20181014055345.25348-4-shamir.rabinovitch@oracle.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/kbuild/>
List-Post: <mailto:kbuild@lists.01.org>
List-Help: <mailto:kbuild-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=subscribe>
Errors-To: kbuild-bounces@lists.01.org
Sender: "kbuild" <kbuild-bounces@lists.01.org>
To: kbuild@01.org
Cc: leon@kernel.org, shamir.rabinovitch@oracle.com, linux-rdma@vger.kernel.org, santosh.shilimkar@oracle.com, jgg@ziepe.ca, dledford@redhat.com, kbuild-all@01.org
List-Id: linux-rdma@vger.kernel.org

Hi Shamir,

Thank you for the patch! Perhaps something to improve:

url:    https://github.com/0day-ci/linux/commits/Shamir-Rabinovitch/RDMA-restrack-resource-tracker-should-not-use-uobject-pointers/20181015-015654
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git for-next

New smatch warnings:
drivers/infiniband/hw/mlx5/qp.c:1865 create_qp_common() error: we previously assumed 'udata' could be null (see line 1839)

Old smatch warnings:
drivers/infiniband/hw/mlx5/qp.c:2014 create_qp_common() error: we previously assumed 'pd' could be null (see line 1845)
drivers/infiniband/hw/mlx5/qp.c:2014 create_qp_common() error: we previously assumed 'pd->uobject' could be null (see line 1846)
drivers/infiniband/hw/mlx5/qp.c:2455 mlx5_ib_create_qp() error: we previously assumed 'pd' could be null (see line 2362)

# https://github.com/0day-ci/linux/commit/f643bd9130193eabe24dd3814b42e9f364a3f39c
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout f643bd9130193eabe24dd3814b42e9f364a3f39c
vim +/udata +1865 drivers/infiniband/hw/mlx5/qp.c

28d6137008 Yishai Hadas       2016-05-23  1686  
e126ba97db Eli Cohen          2013-07-07  1687  static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
e126ba97db Eli Cohen          2013-07-07  1688  			    struct ib_qp_init_attr *init_attr,
e126ba97db Eli Cohen          2013-07-07  1689  			    struct ib_udata *udata, struct mlx5_ib_qp *qp)
e126ba97db Eli Cohen          2013-07-07  1690  {
e126ba97db Eli Cohen          2013-07-07  1691  	struct mlx5_ib_resources *devr = &dev->devr;
09a7d9eca1 Saeed Mahameed     2016-07-19  1692  	int inlen = MLX5_ST_SZ_BYTES(create_qp_in);
938fe83c8d Saeed Mahameed     2015-05-28  1693  	struct mlx5_core_dev *mdev = dev->mdev;
0625b4ba1a Jason Gunthorpe    2018-08-14  1694  	struct mlx5_ib_create_qp_resp resp = {};
89ea94a7b6 Maor Gottlieb      2016-06-17  1695  	struct mlx5_ib_cq *send_cq;
89ea94a7b6 Maor Gottlieb      2016-06-17  1696  	struct mlx5_ib_cq *recv_cq;
89ea94a7b6 Maor Gottlieb      2016-06-17  1697  	unsigned long flags;
cfb5e088e2 Haggai Abramovsky  2016-01-14  1698  	u32 uidx = MLX5_IB_DEFAULT_UIDX;
09a7d9eca1 Saeed Mahameed     2016-07-19  1699  	struct mlx5_ib_create_qp ucmd;
09a7d9eca1 Saeed Mahameed     2016-07-19  1700  	struct mlx5_ib_qp_base *base;
e7b169f344 Noa Osherovich     2018-02-25  1701  	int mlx5_st;
cfb5e088e2 Haggai Abramovsky  2016-01-14  1702  	void *qpc;
09a7d9eca1 Saeed Mahameed     2016-07-19  1703  	u32 *in;
09a7d9eca1 Saeed Mahameed     2016-07-19  1704  	int err;
e126ba97db Eli Cohen          2013-07-07  1705  
e126ba97db Eli Cohen          2013-07-07  1706  	mutex_init(&qp->mutex);
e126ba97db Eli Cohen          2013-07-07  1707  	spin_lock_init(&qp->sq.lock);
e126ba97db Eli Cohen          2013-07-07  1708  	spin_lock_init(&qp->rq.lock);
e126ba97db Eli Cohen          2013-07-07  1709  
e7b169f344 Noa Osherovich     2018-02-25  1710  	mlx5_st = to_mlx5_st(init_attr->qp_type);
e7b169f344 Noa Osherovich     2018-02-25  1711  	if (mlx5_st < 0)
e7b169f344 Noa Osherovich     2018-02-25  1712  		return -EINVAL;
e7b169f344 Noa Osherovich     2018-02-25  1713  
28d6137008 Yishai Hadas       2016-05-23  1714  	if (init_attr->rwq_ind_tbl) {
28d6137008 Yishai Hadas       2016-05-23  1715  		if (!udata)
28d6137008 Yishai Hadas       2016-05-23  1716  			return -ENOSYS;
28d6137008 Yishai Hadas       2016-05-23  1717  
28d6137008 Yishai Hadas       2016-05-23  1718  		err = create_rss_raw_qp_tir(dev, qp, pd, init_attr, udata);
28d6137008 Yishai Hadas       2016-05-23  1719  		return err;
28d6137008 Yishai Hadas       2016-05-23  1720  	}
28d6137008 Yishai Hadas       2016-05-23  1721  
f360d88a2e Eli Cohen          2014-04-02  1722  	if (init_attr->create_flags & IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK) {
938fe83c8d Saeed Mahameed     2015-05-28  1723  		if (!MLX5_CAP_GEN(mdev, block_lb_mc)) {
f360d88a2e Eli Cohen          2014-04-02  1724  			mlx5_ib_dbg(dev, "block multicast loopback isn't supported\n");
f360d88a2e Eli Cohen          2014-04-02  1725  			return -EINVAL;
f360d88a2e Eli Cohen          2014-04-02  1726  		} else {
f360d88a2e Eli Cohen          2014-04-02  1727  			qp->flags |= MLX5_IB_QP_BLOCK_MULTICAST_LOOPBACK;
f360d88a2e Eli Cohen          2014-04-02  1728  		}
f360d88a2e Eli Cohen          2014-04-02  1729  	}
f360d88a2e Eli Cohen          2014-04-02  1730  
051f263098 Leon Romanovsky    2015-12-20  1731  	if (init_attr->create_flags &
051f263098 Leon Romanovsky    2015-12-20  1732  			(IB_QP_CREATE_CROSS_CHANNEL |
051f263098 Leon Romanovsky    2015-12-20  1733  			 IB_QP_CREATE_MANAGED_SEND |
051f263098 Leon Romanovsky    2015-12-20  1734  			 IB_QP_CREATE_MANAGED_RECV)) {
051f263098 Leon Romanovsky    2015-12-20  1735  		if (!MLX5_CAP_GEN(mdev, cd)) {
051f263098 Leon Romanovsky    2015-12-20  1736  			mlx5_ib_dbg(dev, "cross-channel isn't supported\n");
051f263098 Leon Romanovsky    2015-12-20  1737  			return -EINVAL;
051f263098 Leon Romanovsky    2015-12-20  1738  		}
051f263098 Leon Romanovsky    2015-12-20  1739  		if (init_attr->create_flags & IB_QP_CREATE_CROSS_CHANNEL)
051f263098 Leon Romanovsky    2015-12-20  1740  			qp->flags |= MLX5_IB_QP_CROSS_CHANNEL;
051f263098 Leon Romanovsky    2015-12-20  1741  		if (init_attr->create_flags & IB_QP_CREATE_MANAGED_SEND)
051f263098 Leon Romanovsky    2015-12-20  1742  			qp->flags |= MLX5_IB_QP_MANAGED_SEND;
051f263098 Leon Romanovsky    2015-12-20  1743  		if (init_attr->create_flags & IB_QP_CREATE_MANAGED_RECV)
051f263098 Leon Romanovsky    2015-12-20  1744  			qp->flags |= MLX5_IB_QP_MANAGED_RECV;
051f263098 Leon Romanovsky    2015-12-20  1745  	}
f031396531 Erez Shitrit       2016-02-21  1746  
f031396531 Erez Shitrit       2016-02-21  1747  	if (init_attr->qp_type == IB_QPT_UD &&
f031396531 Erez Shitrit       2016-02-21  1748  	    (init_attr->create_flags & IB_QP_CREATE_IPOIB_UD_LSO))
f031396531 Erez Shitrit       2016-02-21  1749  		if (!MLX5_CAP_GEN(mdev, ipoib_basic_offloads)) {
f031396531 Erez Shitrit       2016-02-21  1750  			mlx5_ib_dbg(dev, "ipoib UD lso qp isn't supported\n");
f031396531 Erez Shitrit       2016-02-21  1751  			return -EOPNOTSUPP;
f031396531 Erez Shitrit       2016-02-21  1752  		}
f031396531 Erez Shitrit       2016-02-21  1753  
358e42ea66 Majd Dibbiny       2016-04-17  1754  	if (init_attr->create_flags & IB_QP_CREATE_SCATTER_FCS) {
358e42ea66 Majd Dibbiny       2016-04-17  1755  		if (init_attr->qp_type != IB_QPT_RAW_PACKET) {
358e42ea66 Majd Dibbiny       2016-04-17  1756  			mlx5_ib_dbg(dev, "Scatter FCS is supported only for Raw Packet QPs");
358e42ea66 Majd Dibbiny       2016-04-17  1757  			return -EOPNOTSUPP;
358e42ea66 Majd Dibbiny       2016-04-17  1758  		}
358e42ea66 Majd Dibbiny       2016-04-17  1759  		if (!MLX5_CAP_GEN(dev->mdev, eth_net_offloads) ||
358e42ea66 Majd Dibbiny       2016-04-17  1760  		    !MLX5_CAP_ETH(dev->mdev, scatter_fcs)) {
358e42ea66 Majd Dibbiny       2016-04-17  1761  			mlx5_ib_dbg(dev, "Scatter FCS isn't supported\n");
358e42ea66 Majd Dibbiny       2016-04-17  1762  			return -EOPNOTSUPP;
358e42ea66 Majd Dibbiny       2016-04-17  1763  		}
358e42ea66 Majd Dibbiny       2016-04-17  1764  		qp->flags |= MLX5_IB_QP_CAP_SCATTER_FCS;
358e42ea66 Majd Dibbiny       2016-04-17  1765  	}
358e42ea66 Majd Dibbiny       2016-04-17  1766  
e126ba97db Eli Cohen          2013-07-07  1767  	if (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR)
e126ba97db Eli Cohen          2013-07-07  1768  		qp->sq_signal_bits = MLX5_WQE_CTRL_CQ_UPDATE;
e126ba97db Eli Cohen          2013-07-07  1769  
e4cc4fa7cc Noa Osherovich     2017-01-18  1770  	if (init_attr->create_flags & IB_QP_CREATE_CVLAN_STRIPPING) {
e4cc4fa7cc Noa Osherovich     2017-01-18  1771  		if (!(MLX5_CAP_GEN(dev->mdev, eth_net_offloads) &&
e4cc4fa7cc Noa Osherovich     2017-01-18  1772  		      MLX5_CAP_ETH(dev->mdev, vlan_cap)) ||
e4cc4fa7cc Noa Osherovich     2017-01-18  1773  		    (init_attr->qp_type != IB_QPT_RAW_PACKET))
e4cc4fa7cc Noa Osherovich     2017-01-18  1774  			return -EOPNOTSUPP;
e4cc4fa7cc Noa Osherovich     2017-01-18  1775  		qp->flags |= MLX5_IB_QP_CVLAN_STRIPPING;
e4cc4fa7cc Noa Osherovich     2017-01-18  1776  	}
e4cc4fa7cc Noa Osherovich     2017-01-18  1777  
f643bd9130 Shamir Rabinovitch 2018-10-14  1778  	if (udata) {
e126ba97db Eli Cohen          2013-07-07  1779  		if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd))) {
e126ba97db Eli Cohen          2013-07-07  1780  			mlx5_ib_dbg(dev, "copy failed\n");
e126ba97db Eli Cohen          2013-07-07  1781  			return -EFAULT;
e126ba97db Eli Cohen          2013-07-07  1782  		}
e126ba97db Eli Cohen          2013-07-07  1783  
cfb5e088e2 Haggai Abramovsky  2016-01-14  1784  		err = get_qp_user_index(to_mucontext(pd->uobject->context),
cfb5e088e2 Haggai Abramovsky  2016-01-14  1785  					&ucmd, udata->inlen, &uidx);
cfb5e088e2 Haggai Abramovsky  2016-01-14  1786  		if (err)
cfb5e088e2 Haggai Abramovsky  2016-01-14  1787  			return err;
cfb5e088e2 Haggai Abramovsky  2016-01-14  1788  
e126ba97db Eli Cohen          2013-07-07  1789  		qp->wq_sig = !!(ucmd.flags & MLX5_QP_FLAG_SIGNATURE);
e126ba97db Eli Cohen          2013-07-07  1790  		qp->scat_cqe = !!(ucmd.flags & MLX5_QP_FLAG_SCATTER_CQE);
f95ef6cbae Maor Gottlieb      2017-10-19  1791  		if (ucmd.flags & MLX5_QP_FLAG_TUNNEL_OFFLOADS) {
f95ef6cbae Maor Gottlieb      2017-10-19  1792  			if (init_attr->qp_type != IB_QPT_RAW_PACKET ||
f95ef6cbae Maor Gottlieb      2017-10-19  1793  			    !tunnel_offload_supported(mdev)) {
f95ef6cbae Maor Gottlieb      2017-10-19  1794  				mlx5_ib_dbg(dev, "Tunnel offload isn't supported\n");
f95ef6cbae Maor Gottlieb      2017-10-19  1795  				return -EOPNOTSUPP;
f95ef6cbae Maor Gottlieb      2017-10-19  1796  			}
175edba856 Mark Bloch         2018-09-17  1797  			qp->flags_en |= MLX5_QP_FLAG_TUNNEL_OFFLOADS;
175edba856 Mark Bloch         2018-09-17  1798  		}
175edba856 Mark Bloch         2018-09-17  1799  
175edba856 Mark Bloch         2018-09-17  1800  		if (ucmd.flags & MLX5_QP_FLAG_TIR_ALLOW_SELF_LB_UC) {
175edba856 Mark Bloch         2018-09-17  1801  			if (init_attr->qp_type != IB_QPT_RAW_PACKET) {
175edba856 Mark Bloch         2018-09-17  1802  				mlx5_ib_dbg(dev, "Self-LB UC isn't supported\n");
175edba856 Mark Bloch         2018-09-17  1803  				return -EOPNOTSUPP;
175edba856 Mark Bloch         2018-09-17  1804  			}
175edba856 Mark Bloch         2018-09-17  1805  			qp->flags_en |= MLX5_QP_FLAG_TIR_ALLOW_SELF_LB_UC;
175edba856 Mark Bloch         2018-09-17  1806  		}
175edba856 Mark Bloch         2018-09-17  1807  
175edba856 Mark Bloch         2018-09-17  1808  		if (ucmd.flags & MLX5_QP_FLAG_TIR_ALLOW_SELF_LB_MC) {
175edba856 Mark Bloch         2018-09-17  1809  			if (init_attr->qp_type != IB_QPT_RAW_PACKET) {
175edba856 Mark Bloch         2018-09-17  1810  				mlx5_ib_dbg(dev, "Self-LB UM isn't supported\n");
175edba856 Mark Bloch         2018-09-17  1811  				return -EOPNOTSUPP;
175edba856 Mark Bloch         2018-09-17  1812  			}
175edba856 Mark Bloch         2018-09-17  1813  			qp->flags_en |= MLX5_QP_FLAG_TIR_ALLOW_SELF_LB_MC;
f95ef6cbae Maor Gottlieb      2017-10-19  1814  		}
c2e53b2ce1 Yishai Hadas       2017-06-08  1815  
c2e53b2ce1 Yishai Hadas       2017-06-08  1816  		if (init_attr->create_flags & IB_QP_CREATE_SOURCE_QPN) {
c2e53b2ce1 Yishai Hadas       2017-06-08  1817  			if (init_attr->qp_type != IB_QPT_UD ||
c2e53b2ce1 Yishai Hadas       2017-06-08  1818  			    (MLX5_CAP_GEN(dev->mdev, port_type) !=
c2e53b2ce1 Yishai Hadas       2017-06-08  1819  			     MLX5_CAP_PORT_TYPE_IB) ||
c2e53b2ce1 Yishai Hadas       2017-06-08  1820  			    !mlx5_get_flow_namespace(dev->mdev, MLX5_FLOW_NAMESPACE_BYPASS)) {
c2e53b2ce1 Yishai Hadas       2017-06-08  1821  				mlx5_ib_dbg(dev, "Source QP option isn't supported\n");
c2e53b2ce1 Yishai Hadas       2017-06-08  1822  				return -EOPNOTSUPP;
c2e53b2ce1 Yishai Hadas       2017-06-08  1823  			}
c2e53b2ce1 Yishai Hadas       2017-06-08  1824  
c2e53b2ce1 Yishai Hadas       2017-06-08  1825  			qp->flags |= MLX5_IB_QP_UNDERLAY;
c2e53b2ce1 Yishai Hadas       2017-06-08  1826  			qp->underlay_qpn = init_attr->source_qpn;
c2e53b2ce1 Yishai Hadas       2017-06-08  1827  		}
e126ba97db Eli Cohen          2013-07-07  1828  	} else {
e126ba97db Eli Cohen          2013-07-07  1829  		qp->wq_sig = !!wq_signature;
e126ba97db Eli Cohen          2013-07-07  1830  	}
e126ba97db Eli Cohen          2013-07-07  1831  
c2e53b2ce1 Yishai Hadas       2017-06-08  1832  	base = (init_attr->qp_type == IB_QPT_RAW_PACKET ||
c2e53b2ce1 Yishai Hadas       2017-06-08  1833  		qp->flags & MLX5_IB_QP_UNDERLAY) ?
c2e53b2ce1 Yishai Hadas       2017-06-08  1834  	       &qp->raw_packet_qp.rq.base :
c2e53b2ce1 Yishai Hadas       2017-06-08  1835  	       &qp->trans_qp.base;
c2e53b2ce1 Yishai Hadas       2017-06-08  1836  
e126ba97db Eli Cohen          2013-07-07  1837  	qp->has_rq = qp_has_rq(init_attr);
e126ba97db Eli Cohen          2013-07-07  1838  	err = set_rq_size(dev, &init_attr->cap, qp->has_rq,
f643bd9130 Shamir Rabinovitch 2018-10-14 @1839  			  qp, udata ? &ucmd : NULL);
                                                                              ^^^^^^^
The patch adds a check for NULL.

e126ba97db Eli Cohen          2013-07-07  1840  	if (err) {
e126ba97db Eli Cohen          2013-07-07  1841  		mlx5_ib_dbg(dev, "err %d\n", err);
e126ba97db Eli Cohen          2013-07-07  1842  		return err;
e126ba97db Eli Cohen          2013-07-07  1843  	}
e126ba97db Eli Cohen          2013-07-07  1844  
e126ba97db Eli Cohen          2013-07-07  1845  	if (pd) {
e126ba97db Eli Cohen          2013-07-07  1846  		if (pd->uobject) {
938fe83c8d Saeed Mahameed     2015-05-28  1847  			__u32 max_wqes =
938fe83c8d Saeed Mahameed     2015-05-28  1848  				1 << MLX5_CAP_GEN(mdev, log_max_qp_sz);
e126ba97db Eli Cohen          2013-07-07  1849  			mlx5_ib_dbg(dev, "requested sq_wqe_count (%d)\n", ucmd.sq_wqe_count);
e126ba97db Eli Cohen          2013-07-07  1850  			if (ucmd.rq_wqe_shift != qp->rq.wqe_shift ||
e126ba97db Eli Cohen          2013-07-07  1851  			    ucmd.rq_wqe_count != qp->rq.wqe_cnt) {
e126ba97db Eli Cohen          2013-07-07  1852  				mlx5_ib_dbg(dev, "invalid rq params\n");
e126ba97db Eli Cohen          2013-07-07  1853  				return -EINVAL;
e126ba97db Eli Cohen          2013-07-07  1854  			}
938fe83c8d Saeed Mahameed     2015-05-28  1855  			if (ucmd.sq_wqe_count > max_wqes) {
e126ba97db Eli Cohen          2013-07-07  1856  				mlx5_ib_dbg(dev, "requested sq_wqe_count (%d) > max allowed (%d)\n",
938fe83c8d Saeed Mahameed     2015-05-28  1857  					    ucmd.sq_wqe_count, max_wqes);
e126ba97db Eli Cohen          2013-07-07  1858  				return -EINVAL;
e126ba97db Eli Cohen          2013-07-07  1859  			}
b11a4f9cde Haggai Eran        2016-02-29  1860  			if (init_attr->create_flags &
b11a4f9cde Haggai Eran        2016-02-29  1861  			    mlx5_ib_create_qp_sqpn_qp1()) {
b11a4f9cde Haggai Eran        2016-02-29  1862  				mlx5_ib_dbg(dev, "user-space is not allowed to create UD QPs spoofing as QP1\n");
b11a4f9cde Haggai Eran        2016-02-29  1863  				return -EINVAL;
b11a4f9cde Haggai Eran        2016-02-29  1864  			}
0fb2ed66a1 majd@mellanox.com  2016-01-14 @1865  			err = create_user_qp(dev, pd, qp, udata, init_attr, &in,
                                                                                                          ^^^^^
Does this need to be checked as well?

0fb2ed66a1 majd@mellanox.com  2016-01-14  1866  					     &resp, &inlen, base);
e126ba97db Eli Cohen          2013-07-07  1867  			if (err)
e126ba97db Eli Cohen          2013-07-07  1868  				mlx5_ib_dbg(dev, "err %d\n", err);
e126ba97db Eli Cohen          2013-07-07  1869  		} else {
19098df2da majd@mellanox.com  2016-01-14  1870  			err = create_kernel_qp(dev, init_attr, qp, &in, &inlen,
19098df2da majd@mellanox.com  2016-01-14  1871  					       base);
e126ba97db Eli Cohen          2013-07-07  1872  			if (err)
e126ba97db Eli Cohen          2013-07-07  1873  				mlx5_ib_dbg(dev, "err %d\n", err);
e126ba97db Eli Cohen          2013-07-07  1874  		}
e126ba97db Eli Cohen          2013-07-07  1875  
e126ba97db Eli Cohen          2013-07-07  1876  		if (err)
e126ba97db Eli Cohen          2013-07-07  1877  			return err;
e126ba97db Eli Cohen          2013-07-07  1878  	} else {
1b9a07ee25 Leon Romanovsky    2017-05-10  1879  		in = kvzalloc(inlen, GFP_KERNEL);
e126ba97db Eli Cohen          2013-07-07  1880  		if (!in)
e126ba97db Eli Cohen          2013-07-07  1881  			return -ENOMEM;
e126ba97db Eli Cohen          2013-07-07  1882  
e126ba97db Eli Cohen          2013-07-07  1883  		qp->create_type = MLX5_QP_EMPTY;
e126ba97db Eli Cohen          2013-07-07  1884  	}
e126ba97db Eli Cohen          2013-07-07  1885  
e126ba97db Eli Cohen          2013-07-07  1886  	if (is_sqp(init_attr->qp_type))
e126ba97db Eli Cohen          2013-07-07  1887  		qp->port = init_attr->port_num;
e126ba97db Eli Cohen          2013-07-07  1888  
09a7d9eca1 Saeed Mahameed     2016-07-19  1889  	qpc = MLX5_ADDR_OF(create_qp_in, in, qpc);
09a7d9eca1 Saeed Mahameed     2016-07-19  1890  
e7b169f344 Noa Osherovich     2018-02-25  1891  	MLX5_SET(qpc, qpc, st, mlx5_st);
09a7d9eca1 Saeed Mahameed     2016-07-19  1892  	MLX5_SET(qpc, qpc, pm_state, MLX5_QP_PM_MIGRATED);
e126ba97db Eli Cohen          2013-07-07  1893  
e126ba97db Eli Cohen          2013-07-07  1894  	if (init_attr->qp_type != MLX5_IB_QPT_REG_UMR)
09a7d9eca1 Saeed Mahameed     2016-07-19  1895  		MLX5_SET(qpc, qpc, pd, to_mpd(pd ? pd : devr->p0)->pdn);
e126ba97db Eli Cohen          2013-07-07  1896  	else
09a7d9eca1 Saeed Mahameed     2016-07-19  1897  		MLX5_SET(qpc, qpc, latency_sensitive, 1);
09a7d9eca1 Saeed Mahameed     2016-07-19  1898  
e126ba97db Eli Cohen          2013-07-07  1899  
e126ba97db Eli Cohen          2013-07-07  1900  	if (qp->wq_sig)
09a7d9eca1 Saeed Mahameed     2016-07-19  1901  		MLX5_SET(qpc, qpc, wq_signature, 1);
e126ba97db Eli Cohen          2013-07-07  1902  
f360d88a2e Eli Cohen          2014-04-02  1903  	if (qp->flags & MLX5_IB_QP_BLOCK_MULTICAST_LOOPBACK)
09a7d9eca1 Saeed Mahameed     2016-07-19  1904  		MLX5_SET(qpc, qpc, block_lb_mc, 1);
f360d88a2e Eli Cohen          2014-04-02  1905  
051f263098 Leon Romanovsky    2015-12-20  1906  	if (qp->flags & MLX5_IB_QP_CROSS_CHANNEL)
09a7d9eca1 Saeed Mahameed     2016-07-19  1907  		MLX5_SET(qpc, qpc, cd_master, 1);
051f263098 Leon Romanovsky    2015-12-20  1908  	if (qp->flags & MLX5_IB_QP_MANAGED_SEND)
09a7d9eca1 Saeed Mahameed     2016-07-19  1909  		MLX5_SET(qpc, qpc, cd_slave_send, 1);
051f263098 Leon Romanovsky    2015-12-20  1910  	if (qp->flags & MLX5_IB_QP_MANAGED_RECV)
09a7d9eca1 Saeed Mahameed     2016-07-19  1911  		MLX5_SET(qpc, qpc, cd_slave_receive, 1);
051f263098 Leon Romanovsky    2015-12-20  1912  
e126ba97db Eli Cohen          2013-07-07  1913  	if (qp->scat_cqe && is_connected(init_attr->qp_type)) {
e126ba97db Eli Cohen          2013-07-07  1914  		int rcqe_sz;
e126ba97db Eli Cohen          2013-07-07  1915  		int scqe_sz;
e126ba97db Eli Cohen          2013-07-07  1916  
e126ba97db Eli Cohen          2013-07-07  1917  		rcqe_sz = mlx5_ib_get_cqe_size(dev, init_attr->recv_cq);
e126ba97db Eli Cohen          2013-07-07  1918  		scqe_sz = mlx5_ib_get_cqe_size(dev, init_attr->send_cq);
e126ba97db Eli Cohen          2013-07-07  1919  
e126ba97db Eli Cohen          2013-07-07  1920  		if (rcqe_sz == 128)
09a7d9eca1 Saeed Mahameed     2016-07-19  1921  			MLX5_SET(qpc, qpc, cs_res, MLX5_RES_SCAT_DATA64_CQE);
e126ba97db Eli Cohen          2013-07-07  1922  		else
09a7d9eca1 Saeed Mahameed     2016-07-19  1923  			MLX5_SET(qpc, qpc, cs_res, MLX5_RES_SCAT_DATA32_CQE);
e126ba97db Eli Cohen          2013-07-07  1924  
e126ba97db Eli Cohen          2013-07-07  1925  		if (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR) {
e126ba97db Eli Cohen          2013-07-07  1926  			if (scqe_sz == 128)
09a7d9eca1 Saeed Mahameed     2016-07-19  1927  				MLX5_SET(qpc, qpc, cs_req, MLX5_REQ_SCAT_DATA64_CQE);
e126ba97db Eli Cohen          2013-07-07  1928  			else
09a7d9eca1 Saeed Mahameed     2016-07-19  1929  				MLX5_SET(qpc, qpc, cs_req, MLX5_REQ_SCAT_DATA32_CQE);
e126ba97db Eli Cohen          2013-07-07  1930  		}
e126ba97db Eli Cohen          2013-07-07  1931  	}
e126ba97db Eli Cohen          2013-07-07  1932  
e126ba97db Eli Cohen          2013-07-07  1933  	if (qp->rq.wqe_cnt) {
09a7d9eca1 Saeed Mahameed     2016-07-19  1934  		MLX5_SET(qpc, qpc, log_rq_stride, qp->rq.wqe_shift - 4);
09a7d9eca1 Saeed Mahameed     2016-07-19  1935  		MLX5_SET(qpc, qpc, log_rq_size, ilog2(qp->rq.wqe_cnt));
e126ba97db Eli Cohen          2013-07-07  1936  	}
e126ba97db Eli Cohen          2013-07-07  1937  
09a7d9eca1 Saeed Mahameed     2016-07-19  1938  	MLX5_SET(qpc, qpc, rq_type, get_rx_type(qp, init_attr));
e126ba97db Eli Cohen          2013-07-07  1939  
3fd3307ef3 Artemy Kovalyov    2017-08-17  1940  	if (qp->sq.wqe_cnt) {
09a7d9eca1 Saeed Mahameed     2016-07-19  1941  		MLX5_SET(qpc, qpc, log_sq_size, ilog2(qp->sq.wqe_cnt));
3fd3307ef3 Artemy Kovalyov    2017-08-17  1942  	} else {
09a7d9eca1 Saeed Mahameed     2016-07-19  1943  		MLX5_SET(qpc, qpc, no_sq, 1);
3fd3307ef3 Artemy Kovalyov    2017-08-17  1944  		if (init_attr->srq &&
3fd3307ef3 Artemy Kovalyov    2017-08-17  1945  		    init_attr->srq->srq_type == IB_SRQT_TM)
3fd3307ef3 Artemy Kovalyov    2017-08-17  1946  			MLX5_SET(qpc, qpc, offload_type,
3fd3307ef3 Artemy Kovalyov    2017-08-17  1947  				 MLX5_QPC_OFFLOAD_TYPE_RNDV);
3fd3307ef3 Artemy Kovalyov    2017-08-17  1948  	}
e126ba97db Eli Cohen          2013-07-07  1949  
e126ba97db Eli Cohen          2013-07-07  1950  	/* Set default resources */
e126ba97db Eli Cohen          2013-07-07  1951  	switch (init_attr->qp_type) {
e126ba97db Eli Cohen          2013-07-07  1952  	case IB_QPT_XRC_TGT:
09a7d9eca1 Saeed Mahameed     2016-07-19  1953  		MLX5_SET(qpc, qpc, cqn_rcv, to_mcq(devr->c0)->mcq.cqn);
09a7d9eca1 Saeed Mahameed     2016-07-19  1954  		MLX5_SET(qpc, qpc, cqn_snd, to_mcq(devr->c0)->mcq.cqn);
09a7d9eca1 Saeed Mahameed     2016-07-19  1955  		MLX5_SET(qpc, qpc, srqn_rmpn_xrqn, to_msrq(devr->s0)->msrq.srqn);
09a7d9eca1 Saeed Mahameed     2016-07-19  1956  		MLX5_SET(qpc, qpc, xrcd, to_mxrcd(init_attr->xrcd)->xrcdn);
e126ba97db Eli Cohen          2013-07-07  1957  		break;
e126ba97db Eli Cohen          2013-07-07  1958  	case IB_QPT_XRC_INI:
09a7d9eca1 Saeed Mahameed     2016-07-19  1959  		MLX5_SET(qpc, qpc, cqn_rcv, to_mcq(devr->c0)->mcq.cqn);
09a7d9eca1 Saeed Mahameed     2016-07-19  1960  		MLX5_SET(qpc, qpc, xrcd, to_mxrcd(devr->x1)->xrcdn);
09a7d9eca1 Saeed Mahameed     2016-07-19  1961  		MLX5_SET(qpc, qpc, srqn_rmpn_xrqn, to_msrq(devr->s0)->msrq.srqn);
e126ba97db Eli Cohen          2013-07-07  1962  		break;
e126ba97db Eli Cohen          2013-07-07  1963  	default:
e126ba97db Eli Cohen          2013-07-07  1964  		if (init_attr->srq) {
09a7d9eca1 Saeed Mahameed     2016-07-19  1965  			MLX5_SET(qpc, qpc, xrcd, to_mxrcd(devr->x0)->xrcdn);
09a7d9eca1 Saeed Mahameed     2016-07-19  1966  			MLX5_SET(qpc, qpc, srqn_rmpn_xrqn, to_msrq(init_attr->srq)->msrq.srqn);
e126ba97db Eli Cohen          2013-07-07  1967  		} else {
09a7d9eca1 Saeed Mahameed     2016-07-19  1968  			MLX5_SET(qpc, qpc, xrcd, to_mxrcd(devr->x1)->xrcdn);
09a7d9eca1 Saeed Mahameed     2016-07-19  1969  			MLX5_SET(qpc, qpc, srqn_rmpn_xrqn, to_msrq(devr->s1)->msrq.srqn);
e126ba97db Eli Cohen          2013-07-07  1970  		}
e126ba97db Eli Cohen          2013-07-07  1971  	}
e126ba97db Eli Cohen          2013-07-07  1972  
e126ba97db Eli Cohen          2013-07-07  1973  	if (init_attr->send_cq)
09a7d9eca1 Saeed Mahameed     2016-07-19  1974  		MLX5_SET(qpc, qpc, cqn_snd, to_mcq(init_attr->send_cq)->mcq.cqn);
e126ba97db Eli Cohen          2013-07-07  1975  
e126ba97db Eli Cohen          2013-07-07  1976  	if (init_attr->recv_cq)
09a7d9eca1 Saeed Mahameed     2016-07-19  1977  		MLX5_SET(qpc, qpc, cqn_rcv, to_mcq(init_attr->recv_cq)->mcq.cqn);
e126ba97db Eli Cohen          2013-07-07  1978  
09a7d9eca1 Saeed Mahameed     2016-07-19  1979  	MLX5_SET64(qpc, qpc, dbr_addr, qp->db.dma);
e126ba97db Eli Cohen          2013-07-07  1980  
cfb5e088e2 Haggai Abramovsky  2016-01-14  1981  	/* 0xffffff means we ask to work with cqe version 0 */
09a7d9eca1 Saeed Mahameed     2016-07-19  1982  	if (MLX5_CAP_GEN(mdev, cqe_version) == MLX5_CQE_VERSION_V1)
cfb5e088e2 Haggai Abramovsky  2016-01-14  1983  		MLX5_SET(qpc, qpc, user_index, uidx);
09a7d9eca1 Saeed Mahameed     2016-07-19  1984  
f031396531 Erez Shitrit       2016-02-21  1985  	/* we use IB_QP_CREATE_IPOIB_UD_LSO to indicates ipoib qp */
f031396531 Erez Shitrit       2016-02-21  1986  	if (init_attr->qp_type == IB_QPT_UD &&
f031396531 Erez Shitrit       2016-02-21  1987  	    (init_attr->create_flags & IB_QP_CREATE_IPOIB_UD_LSO)) {
f031396531 Erez Shitrit       2016-02-21  1988  		MLX5_SET(qpc, qpc, ulp_stateless_offload_mode, 1);
f031396531 Erez Shitrit       2016-02-21  1989  		qp->flags |= MLX5_IB_QP_LSO;
f031396531 Erez Shitrit       2016-02-21  1990  	}
cfb5e088e2 Haggai Abramovsky  2016-01-14  1991  
b1383aa641 Noa Osherovich     2017-10-29  1992  	if (init_attr->create_flags & IB_QP_CREATE_PCI_WRITE_END_PADDING) {
b1383aa641 Noa Osherovich     2017-10-29  1993  		if (!MLX5_CAP_GEN(dev->mdev, end_pad)) {
b1383aa641 Noa Osherovich     2017-10-29  1994  			mlx5_ib_dbg(dev, "scatter end padding is not supported\n");
b1383aa641 Noa Osherovich     2017-10-29  1995  			err = -EOPNOTSUPP;
b1383aa641 Noa Osherovich     2017-10-29  1996  			goto err;
b1383aa641 Noa Osherovich     2017-10-29  1997  		} else if (init_attr->qp_type != IB_QPT_RAW_PACKET) {
b1383aa641 Noa Osherovich     2017-10-29  1998  			MLX5_SET(qpc, qpc, end_padding_mode,
b1383aa641 Noa Osherovich     2017-10-29  1999  				 MLX5_WQ_END_PAD_MODE_ALIGN);
b1383aa641 Noa Osherovich     2017-10-29  2000  		} else {
b1383aa641 Noa Osherovich     2017-10-29  2001  			qp->flags |= MLX5_IB_QP_PCI_WRITE_END_PADDING;
b1383aa641 Noa Osherovich     2017-10-29  2002  		}
b1383aa641 Noa Osherovich     2017-10-29  2003  	}
b1383aa641 Noa Osherovich     2017-10-29  2004  
2c292dbb39 Boris Pismenny     2018-03-08  2005  	if (inlen < 0) {
2c292dbb39 Boris Pismenny     2018-03-08  2006  		err = -EINVAL;
2c292dbb39 Boris Pismenny     2018-03-08  2007  		goto err;
2c292dbb39 Boris Pismenny     2018-03-08  2008  	}
2c292dbb39 Boris Pismenny     2018-03-08  2009  
c2e53b2ce1 Yishai Hadas       2017-06-08  2010  	if (init_attr->qp_type == IB_QPT_RAW_PACKET ||
c2e53b2ce1 Yishai Hadas       2017-06-08  2011  	    qp->flags & MLX5_IB_QP_UNDERLAY) {
0fb2ed66a1 majd@mellanox.com  2016-01-14  2012  		qp->raw_packet_qp.sq.ubuffer.buf_addr = ucmd.sq_buf_addr;
0fb2ed66a1 majd@mellanox.com  2016-01-14  2013  		raw_packet_qp_copy_info(qp, &qp->raw_packet_qp);
7f72052cb4 Yishai Hadas       2018-09-20  2014  		err = create_raw_packet_qp(dev, qp, in, inlen, pd, udata,
7f72052cb4 Yishai Hadas       2018-09-20  2015  					   &resp);
0fb2ed66a1 majd@mellanox.com  2016-01-14  2016  	} else {
19098df2da majd@mellanox.com  2016-01-14  2017  		err = mlx5_core_create_qp(dev->mdev, &base->mqp, in, inlen);
0fb2ed66a1 majd@mellanox.com  2016-01-14  2018  	}
0fb2ed66a1 majd@mellanox.com  2016-01-14  2019  
e126ba97db Eli Cohen          2013-07-07  2020  	if (err) {
e126ba97db Eli Cohen          2013-07-07  2021  		mlx5_ib_dbg(dev, "create qp failed\n");
e126ba97db Eli Cohen          2013-07-07  2022  		goto err_create;
e126ba97db Eli Cohen          2013-07-07  2023  	}
e126ba97db Eli Cohen          2013-07-07  2024  
479163f460 Al Viro            2014-11-20  2025  	kvfree(in);
e126ba97db Eli Cohen          2013-07-07  2026  
19098df2da majd@mellanox.com  2016-01-14  2027  	base->container_mibqp = qp;
19098df2da majd@mellanox.com  2016-01-14  2028  	base->mqp.event = mlx5_ib_qp_event;
e126ba97db Eli Cohen          2013-07-07  2029  
89ea94a7b6 Maor Gottlieb      2016-06-17  2030  	get_cqs(init_attr->qp_type, init_attr->send_cq, init_attr->recv_cq,
89ea94a7b6 Maor Gottlieb      2016-06-17  2031  		&send_cq, &recv_cq);
89ea94a7b6 Maor Gottlieb      2016-06-17  2032  	spin_lock_irqsave(&dev->reset_flow_resource_lock, flags);
89ea94a7b6 Maor Gottlieb      2016-06-17  2033  	mlx5_ib_lock_cqs(send_cq, recv_cq);
89ea94a7b6 Maor Gottlieb      2016-06-17  2034  	/* Maintain device to QPs access, needed for further handling via reset
89ea94a7b6 Maor Gottlieb      2016-06-17  2035  	 * flow
89ea94a7b6 Maor Gottlieb      2016-06-17  2036  	 */
89ea94a7b6 Maor Gottlieb      2016-06-17  2037  	list_add_tail(&qp->qps_list, &dev->qp_list);
89ea94a7b6 Maor Gottlieb      2016-06-17  2038  	/* Maintain CQ to QPs access, needed for further handling via reset flow
89ea94a7b6 Maor Gottlieb      2016-06-17  2039  	 */
89ea94a7b6 Maor Gottlieb      2016-06-17  2040  	if (send_cq)
89ea94a7b6 Maor Gottlieb      2016-06-17  2041  		list_add_tail(&qp->cq_send_list, &send_cq->list_send_qp);
89ea94a7b6 Maor Gottlieb      2016-06-17  2042  	if (recv_cq)
89ea94a7b6 Maor Gottlieb      2016-06-17  2043  		list_add_tail(&qp->cq_recv_list, &recv_cq->list_recv_qp);
89ea94a7b6 Maor Gottlieb      2016-06-17  2044  	mlx5_ib_unlock_cqs(send_cq, recv_cq);
89ea94a7b6 Maor Gottlieb      2016-06-17  2045  	spin_unlock_irqrestore(&dev->reset_flow_resource_lock, flags);
89ea94a7b6 Maor Gottlieb      2016-06-17  2046  
e126ba97db Eli Cohen          2013-07-07  2047  	return 0;
e126ba97db Eli Cohen          2013-07-07  2048  
e126ba97db Eli Cohen          2013-07-07  2049  err_create:
e126ba97db Eli Cohen          2013-07-07  2050  	if (qp->create_type == MLX5_QP_USER)
b037c29a80 Eli Cohen          2017-01-03  2051  		destroy_qp_user(dev, pd, qp, base);
e126ba97db Eli Cohen          2013-07-07  2052  	else if (qp->create_type == MLX5_QP_KERNEL)
e126ba97db Eli Cohen          2013-07-07  2053  		destroy_qp_kernel(dev, qp);
e126ba97db Eli Cohen          2013-07-07  2054  
b1383aa641 Noa Osherovich     2017-10-29  2055  err:
479163f460 Al Viro            2014-11-20  2056  	kvfree(in);
e126ba97db Eli Cohen          2013-07-07  2057  	return err;
e126ba97db Eli Cohen          2013-07-07  2058  }
e126ba97db Eli Cohen          2013-07-07  2059  
