From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 00/15 ibacm] ACM Cache Preloading (and some cosmetic
 cleanups)
Date: Fri, 28 Jun 2013 17:39:18 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736FD378A1@ORSMSX109.amr.corp.intel.com>
References: <51C43267.1030301@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A823736FD375AE@ORSMSX109.amr.corp.intel.com>
 <51CDA942.9070505@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51CDA942.9070505-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I looked them over and retested this. I have a few minor fixups to
> follow shortly.

I've incorporated your changes into the patch set and updated the preload branch.
 
> The one thing I noticed is that the check for using this (address)
> preload option without the previous (route) preload option was
> eliminated. This is probably the case in the long run but it is not the
> case with these current options. Should it be added back in ?

The check is there, but no error is generated.  It may not be that difficult to avoid this dependency, but I'll respond more directly to affected patch.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
