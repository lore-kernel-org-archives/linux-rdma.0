From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: infiniband-diags/perfquery.c: Use ib_types.h defines for
 CapabilityMask
Date: Thu, 28 Apr 2011 09:36:49 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF261A1F3AB8@orsmsx501.amr.corp.intel.com>
References: <4DB97DF4.3020004@dev.mellanox.co.il>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF261A1F3A02@orsmsx501.amr.corp.intel.com>
 <4DB995CE.8070203@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DB995CE.8070203-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Also, there are other infiniband-diags (and library) including
> ib_types.h (e.g. saquery and libibnetdisc).

I have a set of patches that I created as part of trying to support AF_IB and ACM that move a lot of the MAD definitions into libibumad include files.  I don't remember if I ever submitted these, since I was waiting on the acceptance of the kernel patches.  It would take me a while to pull them back out and update them, but I can submit those.  They would help eliminate some of the duplicate definitions that exist between the different libraries (such as libibverbs, librdmacm, and ibacm), and should remove ib-diags from depending on opensm.

I know we've discussed this sort of change before, but would these be acceptable to everyone?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
