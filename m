From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] IB/mlx5: add checking for "vf" from do_setvfinfo()
Date: Wed, 24 Apr 2019 17:08:20 +0300
Message-ID: <20190424140820.GB14798@kadam>
References: <20190412175504.GA20857@kadam>
 <VI1PR0501MB22714D465D6CD60511FDFFD5D1280@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190415094610.GO6095@kadam>
 <VI1PR0501MB22713CCB1141529CCB6934B1D12B0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190416082112.GA27670@kadam>
 <AM4PR0501MB22609E4C9D126A096DD7F614D1240@AM4PR0501MB2260.eurprd05.prod.outlook.com>
 <20190420095102.GA14798@kadam>
 <VI1PR0501MB22713B232B3CF42B849F959BD1220@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190423154943.GC14820@kadam>
 <AM4PR0501MB2260ADC1DA37E87D01979969D1230@AM4PR0501MB2260.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AM4PR0501MB2260ADC1DA37E87D01979969D1230@AM4PR0501MB2260.eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Parav Pandit <parav@mellanox.com>, netdev@vger.kernel.org
Cc: Leon Romanovsky <leon@kernel.org>, Eli Cohen <eli@mellanox.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

I think I'm just going to ask netdev for an opinion on this.  It could
be that we're just reading the code wrong...

I'm getting a lot of Smatch warning about buffer underflows.  The
problem is that Smatch marks everything from nla_data() as unknown and
untrusted user data.  In do_setvfinfo() we get the "->vf" values from
nla_data().  It starts as u32, but all the function pointers in
net_device_ops use it as a signed integer.  Most of the functions return
-EINVAL if "vf" is negative but there are at least 48 which potentially
use negative values as an offset into an array.

To me making "vf" a u32 throughout seems like a good idea but it's an
extensive patch and I'm not really able to test it at all.  But maybe
there is a better place to check for negatives.  Or maybe we are already
checking for negatives and I haven't seen it.  (I don't know this code
very well at all).

regards,
dan carpenter

drivers/net/ethernet/emulex/benet/be_main.c:1955 be_clear_vf_tvt() error: buffer underflow 'adapter->vf_cfg' 's32min-65534'
drivers/net/ethernet/emulex/benet/be_main.c:1904 be_get_vf_config() error: buffer underflow 'adapter->vf_cfg' 's32min-s32max'
drivers/net/ethernet/emulex/benet/be_main.c:2095 be_set_vf_link_state() error: buffer underflow 'adapter->vf_cfg' 's32min-65534'
drivers/net/ethernet/emulex/benet/be_main.c:1863 be_set_vf_mac() error: buffer underflow 'adapter->vf_cfg' 's32min-s32max'
drivers/net/ethernet/emulex/benet/be_main.c:2103 be_set_vf_spoofchk() error: buffer underflow 'adapter->vf_cfg' 's32min-s32max'
drivers/net/ethernet/emulex/benet/be_main.c:1926 be_set_vf_tvt() error: buffer underflow 'adapter->vf_cfg' 's32min-65534'
drivers/net/ethernet/emulex/benet/be_main.c:2067 be_set_vf_tx_rate() error: buffer underflow 'adapter->vf_cfg' 's32min-65534'
drivers/net/ethernet/emulex/benet/be_main.c:1984 be_set_vf_vlan() error: buffer underflow 'adapter->vf_cfg' 's32min-s32max'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c:2281 bnx2x_post_vf_bulletin() error: buffer underflow 'bp->vfdb->vfs' 's32min-63'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c:1523 bnx2x_set_vf_link_state() error: buffer underflow 'bp->vfdb->vfs' 's32min-s32max'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c:2963 bnx2x_set_vf_spoofchk() error: buffer underflow 'bp->vfdb->vfs' 's32min-s32max'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c:2589 bnx2x_vf_op_prep() error: buffer underflow 'bp->vfdb->vfs' 's32min-65534'
drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c:202 bnxt_get_vf_config() error: buffer underflow 'bp->pf.vf' 's32min-65534'
drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c:309 bnxt_set_vf_bw() error: buffer underflow 'bp->pf.vf' 's32min-65534'
drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c:349 bnxt_set_vf_link_state() error: buffer underflow 'bp->pf.vf' 's32min-65534'
drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c:244 bnxt_set_vf_mac() error: buffer underflow 'bp->pf.vf' 's32min-65534'
drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c:96 bnxt_set_vf_spoofchk() error: buffer underflow 'bp->pf.vf' 's32min-65534'
drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c:180 bnxt_set_vf_trust() error: buffer underflow 'bp->pf.vf' 's32min-65534'
drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c:280 bnxt_set_vf_vlan() error: buffer underflow 'bp->pf.vf' 's32min-65534'
drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:2736 cxgb4_mgmt_get_vf_config() error: buffer underflow 'adap->vfinfo' 's32min-254'
drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:2923 cxgb4_mgmt_set_vf_link_state() error: buffer underflow 'adap->vfinfo' 's32min-254'
drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:2723 cxgb4_mgmt_set_vf_mac() error: buffer underflow 'adap->vfinfo' 's32min-s32max'
drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:2797 cxgb4_mgmt_set_vf_rate() error: buffer underflow 'adap->vfinfo' 's32min-254'
drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:2875 cxgb4_mgmt_set_vf_vlan() error: buffer underflow 'adap->vfinfo' 's32min-254'
drivers/net/ethernet/freescale/enetc/enetc_pf.c:377 enetc_pf_set_vf_mac() error: buffer underflow 'pf->vf_state' 's32min-2147483646'
drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c:7069 hclge_set_vf_vlan_filter() error: buffer underflow 'hdev->vport' 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:4223 i40e_ndo_get_vf_config() error: buffer underflow 'pf->vf' 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:4177 i40e_ndo_set_vf_bw() error: buffer underflow 'pf->vf' 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:4287 i40e_ndo_set_vf_link_state() error: buffer underflow 'pf->vf' 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:3895 i40e_ndo_set_vf_mac() error: buffer underflow 'pf->vf' 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:4041 i40e_ndo_set_vf_port_vlan() error: buffer underflow 'pf->vf' 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:4357 i40e_ndo_set_vf_spoofchk() error: buffer underflow 'pf->vf' 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:4420 i40e_ndo_set_vf_trust() error: buffer underflow 'pf->vf' 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:3862 i40e_validate_vf() error: buffer underflow 'pf->vf' 's32min-2147483646'
drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c:2678 ice_get_vf_cfg() error: buffer underflow 'pf->vf' 's32min-2147483646'
drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c:2879 ice_set_vf_link_state() error: buffer underflow 'pf->vf' 's32min-2147483646'
drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c:2792 ice_set_vf_mac() error: buffer underflow 'pf->vf' 's32min-2147483646'
drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c:2246 ice_set_vf_port_vlan() error: buffer underflow 'pf->vf' 's32min-2147483646'
drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c:2731 ice_set_vf_spoofchk() error: buffer underflow 'pf->vf' 's32min-2147483646'
drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c:2839 ice_set_vf_trust() error: buffer underflow 'pf->vf' 's32min-2147483646'
drivers/infiniband/hw/mlx5/ib_virt.c:114 mlx5_ib_set_vf_link_state() error: buffer underflow 'vfs_ctx' 's32min-s32max'
drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c:2005 qlcnic_sriov_get_vf_config() error: buffer underflow 'sriov->vf_info' 's32min-254'
drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c:1832 qlcnic_sriov_set_vf_mac() error: buffer underflow 'sriov->vf_info' 's32min-254'
drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c:2036 qlcnic_sriov_set_vf_spoofchk() error: buffer underflow 'sriov->vf_info' 's32min-254'
drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c:1864 qlcnic_sriov_set_vf_tx_rate() error: buffer underflow 'sriov->vf_info' 's32min-254'
drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c:1937 qlcnic_sriov_set_vf_vlan() error: buffer underflow 'sriov->vf_info' 's32min-254'
