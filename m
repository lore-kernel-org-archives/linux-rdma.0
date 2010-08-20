From: Bernd Schubert <bs_lists-ivAEE9vf7JuUmYeGgvxl9AC/G2K4zDHf@public.gmane.org>
Subject: srp sg_tablesize
Date: Fri, 20 Aug 2010 09:49:54 +0200
Message-ID: <201008200949.54595.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bernd Schubert <bschubert-LfVdkaOWEx8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In ib_srp.c sg_tablesize is defined as 255. With that value we see lots of IO 
requests of size 1020. As I already wrote on linux-scsi, that is really sub-
optimal for DDN storage, as lots of IO requests of size 1020 come up.

Now the question is if we can safely increase it. Is there somewhere a 
definition what is the real hardware supported size? And shouldn't we increase 
sg_tablesize, but also set the .dma_boundary value?


Thanks in advance,
Bernd


-- 
Bernd Schubert
DataDirect Networks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
