From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] rdma-ndd: add systemd support
Date: Mon, 16 May 2016 17:07:36 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E22ED8815@CRSMSX101.amr.corp.intel.com>
References: <1463297385-28459-1-git-send-email-ira.weiny@intel.com>
 <20160516164148.GA18795@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160516164148.GA18795-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On Sun, May 15, 2016 at 03:29:45AM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > Also clean up pre/post install scripts for spec files.
> 
> Why do all this and not include a unit file too?

diff --git a/etc/rdma-ndd.service.in b/etc/rdma-ndd.service.in new file mode 100644 index 0000000..ef0962b
--- /dev/null
+++ b/etc/rdma-ndd.service.in

This is a *.in to adjust for where the binary and config file are installed...

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
