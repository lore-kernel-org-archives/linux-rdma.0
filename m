From: "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH v2] Return EPROTONOSUPPORT when an RDMA device lacks QP0
Date: Sun, 22 May 2011 21:45:06 -0700
Message-ID: <2F48A0B5-1D6D-4DAC-8192-F4F17DF791B3@llnl.gov>
References: <E280C3CC-BD50-4383-BE33-FCC31C72D3F0@llnl.gov> <1828884A29C6694DAF28B7E6B8A82373010745@ORSMSX101.amr.corp.intel.com> <8D19CC19-B4FD-4338-9267-9C1BC32A6BAE@llnl.gov> <1828884A29C6694DAF28B7E6B8A8237301085B@ORSMSX101.amr.corp.intel.com> <B4F482DA-6C66-4AC9-A583-D2091E8F32C4@llnl.gov> <BANLkTinoKxr5A6Qm7JXV=7qvgaLwoKJt+A@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: multipart/mixed; boundary=Apple-Mail-26--746291057
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTinoKxr5A6Qm7JXV=7qvgaLwoKJt+A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail-26--746291057
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii


On May 22, 2011, at 9:05 PM, Roland Dreier wrote:

>> @@ -2738,6 +2745,7 @@ static void init_mad_qp(struct
> ib_mad_port_private *port_priv,
>> 	spin_lock_init(&qp_info->snoop_lock);
>> 	qp_info->snoop_table = NULL;
>> 	qp_info->snoop_table_size = 0;
>> +	qp_info->qp = NULL;
>> 	atomic_set(&qp_info->snoop_count, 0);
>> }
> 
> This bit isn't needed, is it?  qp_info is in memory allocated with kzalloc.
> (We could get rid of the other = 0 / = NULL lines too)
> 

Yes, sorry, revised attached,
Ira



--Apple-Mail-26--746291057
Content-Disposition: attachment;
	filename=0001-Return-EPROTONOSUPPORT-when-an-RDMA-device-lacks-the.patch
Content-Type: application/octet-stream;
	name="0001-Return-EPROTONOSUPPORT-when-an-RDMA-device-lacks-the.patch"
Content-Transfer-Encoding: 7bit

From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Thu, 19 May 2011 18:19:28 -0700
Subject: [PATCH] Return EPROTONOSUPPORT when an RDMA device lacks the QP required.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 drivers/infiniband/core/mad.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index b2dba21..25ba485 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -275,6 +275,13 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 		goto error1;
 	}
 
+	/* Verify the QP requested is supported.  For example, Ethernet devices
+	 * will not have QP0 */
+	if (!port_priv->qp_info[qpn].qp) {
+		ret = ERR_PTR(-EPROTONOSUPPORT);
+		goto error1;
+	}
+
 	/* Allocate structures */
 	mad_agent_priv = kzalloc(sizeof *mad_agent_priv, GFP_KERNEL);
 	if (!mad_agent_priv) {
-- 
1.7.1


--Apple-Mail-26--746291057--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
