From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch v2] IB/ipath: silence a static checker warning
Date: Mon, 18 Mar 2013 23:25:26 +0300
Message-ID: <20130318202526.GA11268@longonot.mountain>
References: <32E1700B9017364D9B60AED9960492BC0D5C9939@FMSMSX108.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC0D5C9939-AtyAts71sc88Ug9VwtkbtrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I have a static checker which complains that 0x255 is too high for
the "dev->opstats[opcode]" array.  It turns out that the hardware
has already validated the opcode at this point so it can't actually
overflow.

However, silencing the warning is good and this matches how the
opcode is treated in qib_ib_rcv() as well.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
v2: new changelog.  Just mask the value instead of adding an if
statement.

diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index 439c35d..ea93870 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -620,7 +620,7 @@ void ipath_ib_rcv(struct ipath_ibdev *dev, void *rhdr, void *data,
 		goto bail;
 	}
 
-	opcode = be32_to_cpu(ohdr->bth[0]) >> 24;
+	opcode = (be32_to_cpu(ohdr->bth[0]) >> 24) & 0x7f;
 	dev->opstats[opcode].n_bytes += tlen;
 	dev->opstats[opcode].n_packets++;
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
