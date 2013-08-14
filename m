From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IB/iser: Generalize rdma memory registration
Date: Wed, 14 Aug 2013 22:52:01 +0300
Message-ID: <20130814195201.GB16390@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Sagi Grimberg,

This is a semi-automatic email about new static checker warnings.

The patch b4e155ffbbd6: "IB/iser: Generalize rdma memory 
registration" from Jul 28, 2013, leads to the following Smatch 
complaint:

drivers/infiniband/ulp/iser/iser_initiator.c:318 iser_free_rx_descriptors()
	 error: we previously assumed 'device' could be null (see line 313)

drivers/infiniband/ulp/iser/iser_initiator.c
   312	
   313		if (device && device->iser_free_rdma_reg_res)
                    ^^^^^^
New check.

   314			device->iser_free_rdma_reg_res(ib_conn);
   315	
   316		rx_desc = ib_conn->rx_descs;
   317		for (i = 0; i < ib_conn->qp_max_recv_dtos; i++, rx_desc++)
   318			ib_dma_unmap_single(device->ib_device, rx_desc->dma_addr,
                                            ^^^^^^^^^^^^^^^^^
Old dererference.

   319					    ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
   320		kfree(ib_conn->rx_descs);

Has the code changed so that we need to check now?

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
