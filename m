From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] qedr: Add GSI support
Date: Wed, 26 Oct 2016 16:25:01 +0300
Message-ID: <20161026132501.GA3628@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Ram Amrani,

This is a semi-automatic email about new static checker warnings.

The patch 048867793046: "qedr: Add GSI support" from Oct 10, 2016, 
leads to the following Smatch complaint:

drivers/infiniband/hw/qedr/qedr_cm.c:284 qedr_gsi_build_header()
	 warn: variable dereferenced before check 'sgid_attr.ndev' (see line 281)

drivers/infiniband/hw/qedr/qedr_cm.c
   280	
   281		vlan_id = rdma_vlan_dev_vlan_id(sgid_attr.ndev);
                                                ^^^^^^^^^^^^^^
Dereference inside function.

   282		if (vlan_id < VLAN_CFI_MASK)
   283			has_vlan = true;
   284		if (sgid_attr.ndev)
                    ^^^^^^^^^^^^^^
Check too late.

   285			dev_put(sgid_attr.ndev);
   286	

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
