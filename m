From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: RDMA/cm: Add RDMA CM support for IBoE devices
Date: Wed, 28 Nov 2012 11:06:38 +0300
Message-ID: <20121128080637.GA845@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Eli Cohen,

The patch 3c86aa70bf67: "RDMA/cm: Add RDMA CM support for IBoE 
devices" from Oct 13, 2010, leads to the following warning:
net/sunrpc/xprtrdma/svc_rdma_transport.c:722 svc_rdma_create()
	 error: passing non neg 1 to ERR_PTR

This bug would result in a NULL dereference.  svc_rdma_create() is
supposed to return ERR_PTRs or valid pointers, but instead it returns
ERR_PTRs, valid pointers and 1.

The call tree is:

svc_rdma_create()
   => rdma_bind_addr()
      => cma_acquire_dev()
         => find_gid_port()

This is a static checker thing and I don't know what the code is
supposed to be doing.

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
