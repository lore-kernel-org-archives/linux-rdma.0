From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: add rdma-ndd daemon
Date: Fri, 7 Nov 2014 17:40:29 -0700
Message-ID: <20141108004029.GB12120@obsidianresearch.com>
References: <1414713270-12710-1-git-send-email-ira.weiny@intel.com>
 <1414713270-12710-2-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1414713270-12710-2-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 30, 2014 at 07:54:30PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> rdma-ndd is a system daemon which watches the procfs hostname file for updates.
> 
> Upon detecting an update it will update the Node Descriptions of the RDMA
> devices in the system.
> 
> This deamon is intended to work with kernels which support polling of the
> procfs hostname file.  If your kernel does not support this feature the daemon
> will set the Node Descriptions to the hostname at start up and then sleep
> forever.

It seems so strange to have kernel processing of %h/etc and then to
turn around and use a user space daemon to connect one bit of the
kernel to another....

Sadly, I think the proper way to address this is the same way netdev
addresses it - do not activate the interface on module load, wait for
an explicit enablement so userspace can configure before it tries to
link up.

(Not to say that is even possible considering RDMA's history, but still..)

TBH, I'd rather see just this daemon and drop the kernel side... If
the daemon is started before the modules are loaded then it might be
able to set the description while the port is still down.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
