From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: ib-diags: compatability issue with ibstat
Date: Wed, 21 Sep 2011 19:06:12 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E66F5B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Ira Weiny (weiny2-i2BcT+NCU+M@public.gmane.org)" <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

commit 1344cb3feacafc462440dabfa5997c5205486d83 added support for FDR10 in a way that is not compatible with Windows support.  Windows does not use files to read attribute information.

I will probably need to obtain the necessary information using ibverbs on windows by reading port attributes.  I don't think FDR10 support is available through ibverbs on linux yet, but would this be acceptable?  Is there some other way that you'd like to handle this?  The other option I can think of is moving is_fdr10() and sys_read_string() out of ibstat.c and into a linux specific file, so that windows can provide its own implementation.  Thoughts?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
