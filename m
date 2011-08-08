From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ib-diags and ib_get_err_str
Date: Mon, 8 Aug 2011 14:41:44 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823731370283D@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237313702643@ORSMSX101.amr.corp.intel.com>
	<20110805165122.1b508a84.weiny2@llnl.gov>
	<1828884A29C6694DAF28B7E6B8A8237313702677@ORSMSX101.amr.corp.intel.com>
 <20110805171700.df2f3080.weiny2@llnl.gov>
 <4E3F7D9F.9050101@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E3F7D9F.9050101-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hal Rosenstock (hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> It's not new. It's built as part of the OpenSM. Mainly osm_helper and
> maybe a few other things (common code for perhaps more than OpenSM).

I see that it has been there for a while.  It looks like the diags were picking it up from ibal.dll on windows.  I'm not sure why updating the diags created a problem with it now.  (No big deal, I just need to figure it out.)  I just don't understand why the diags need those error codes.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
