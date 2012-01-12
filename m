From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: endian question about struct srp_direct_buf
Date: Thu, 12 Jan 2012 14:41:22 +0300
Message-ID: <20120112114122.GA29021@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sparse complains because len in struct srp_direct_buf is declared as
big endian but it's used throughout as CPU endian.  struct
srp_indirect_buf has the same thing.  It's declared one way but used the
other way.

$ grep -w len drivers/scsi -R | grep -w md
drivers/scsi/ibmvscsi/ibmvfc.c:         md[i].len = sg_dma_len(sg);
drivers/scsi/ibmvscsi/ibmvstgt.c:               mlen = min(rest, md[i].len);
drivers/scsi/libsrp.c:                  md->len, scsi_sg_count(sc));
drivers/scsi/libsrp.c:          len = min(scsi_bufflen(sc), md->len);
drivers/scsi/libsrp.c:          len = md->len;
drivers/scsi/libsrp.c:  err = rdma_io(sc, sg, nsg, md, 1, dir, len);
drivers/scsi/libsrp.c:          md = dma_alloc_coherent(iue->target->dev, id->table_desc.len,
drivers/scsi/libsrp.c:          sg_init_one(&dummy, md, id->table_desc.len);
drivers/scsi/libsrp.c:  err = rdma_io(sc, sg, nsg, md, nmd, dir, len);
drivers/scsi/libsrp.c:          dma_free_coherent(iue->target->dev, id->table_desc.len, md, token);
drivers/scsi/libsrp.c:          len = md->len;

Probably we should just change the declaration to u32?

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
