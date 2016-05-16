From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] rdma-ndd: add systemd support
Date: Mon, 16 May 2016 11:27:07 -0600
Message-ID: <20160516172707.GB6563@obsidianresearch.com>
References: <1463297385-28459-1-git-send-email-ira.weiny@intel.com>
 <20160516164148.GA18795@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E22ED8815@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E22ED8815-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 16, 2016 at 05:07:36PM +0000, Weiny, Ira wrote:
> > 
> > On Sun, May 15, 2016 at 03:29:45AM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >
> > > Also clean up pre/post install scripts for spec files.
> > 
> > Why do all this and not include a unit file too?
> 
> diff --git a/etc/rdma-ndd.service.in b/etc/rdma-ndd.service.in new file mode 100644 index 0000000..ef0962b
> +++ b/etc/rdma-ndd.service.in
> 
> This is a *.in to adjust for where the binary and config file are
> installed...

Right, never mind then

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
