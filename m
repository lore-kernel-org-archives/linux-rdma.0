From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] ibacm: Fixes to ACM package to support distros
Date: Fri, 6 Apr 2012 04:35:28 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823734519B2EC@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A823734519A805@ORSMSX101.amr.corp.intel.com>
 <4F7DC3F8.2030406@redhat.com>
 <1828884A29C6694DAF28B7E6B8A823734519B048@ORSMSX101.amr.corp.intel.com>
 <20120405204038.GA6575@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120405204038.GA6575-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> In this instance you need to have configure variable substitute your
> init script as well. You should not manipulate PATH from an init.d
> script, and you should use an absolute path to the daemon to avoid
> contamination from the invoking user's environment.

This is exactly what I wanted to do...

> So you want:
> 
> %prefix$/bin/IBACM_BIN -foo

In other places, I used sbindir.  But when I try to use that in the init script, I end up with something like this

${exec_prefix}/sbin/ibacm

in the final init script, which doesn't actually work.  I can get @prefix@/sbin to work, but that seems less flexible.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
