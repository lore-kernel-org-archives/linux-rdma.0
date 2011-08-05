From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: ib-diags and ib_get_err_str
Date: Fri, 5 Aug 2011 23:31:17 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237313702643@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ira Weiny (weiny2-i2BcT+NCU+M@public.gmane.org)" <weiny2-i2BcT+NCU+M@public.gmane.org>, "Hal Rosenstock (hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)" <hal.rosenstock>
List-Id: linux-rdma@vger.kernel.org

Can anyone tell me how ib_get_err_str() gets pulled in on Linux?  I see it is ib_types.h in opensm, which references ib_error_str array.  When are the diags depending on to pick this up?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
