From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [Bug 121501] New: [userspace rdma package] after update kernel
 to upstream, rdma service start fail
Date: Wed, 6 Jul 2016 17:58:46 -0600
Message-ID: <20160706235846.GA13310@obsidianresearch.com>
References: <bug-121501-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <bug-121501-11804-3bo0kxnWaOQUvHkbgXJLS5sdmw4N0Rt+2LY78lusg7I@public.gmane.org/>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 06, 2016 at 02:37:08AM +0000, bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org wrote:

> [root@hp-dl380pgen8-01 ~]# service rdma status
> rdma.service - Initialize the iWARP/InfiniBand/RDMA stack in the kernel
>    Loaded: loaded (/usr/lib/systemd/system/rdma.service; disabled; vendor
> preset: disabled)
>    Active: failed (Result: exit-code) since ??? 2016-07-05 02:10:09 EDT; 6min ago
>      Docs: file:/etc/rdma/rdma.conf
>   Process: 13564 ExecStart=/usr/libexec/rdma-init-kernel (code=exited,
> status=3)
>  Main PID: 13564 (code=exited, status=3)
> 
> 7??? 05 02:10:08 hp-dl380pgen8-01.khw.lab.eng.bos.redhat.com
> rdma-init-kernel[13564]: modprobe: FATAL: Module ib_mad not found.
> 7??? 05 02:10:08 hp-dl380pgen8-01.khw.lab.eng.bos.redhat.com
> rdma-init-kernel[13564]: Failed to load module ib_mad
> 7??? 05 02:10:08 hp-dl380pgen8-01.khw.lab.eng.bos.redhat.com
> rdma-init-kernel[13564]: modprobe: FATAL: Module ib_sa not found.
> 7??? 05 02:10:08 hp-dl380pgen8-01.khw.lab.eng.bos.redhat.com
> rdma-init-kernel[13564]: Failed to load module ib_sa
> 7??? 05 02:10:08 hp-dl380pgen8-01.khw.lab.eng.bos.redhat.com
> rdma-init-kernel[13564]: modprobe: FATAL: Module ib_addr not found.
> 7??? 05 02:10:08 hp-dl380pgen8-01.khw.lab.eng.bos.redhat.com
> rdma-init-kernel[13564]: Failed to load module ib_addr

These modules have been replaced with ib_core in upstream.

There is no reason to load these modules directly as they are all
brought in as dependencies from other useful modules, just remove
loading them from /usr/libexec/rdma-init-kernel and ignore failures on
removal.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
