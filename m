From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] Add rdma service for kernel boot support
Date: Thu, 13 Jul 2017 16:51:27 -0600
Message-ID: <20170713225127.GA25543@obsidianresearch.com>
References: <20170713172057.25411-1-benjamin.drung@profitbricks.com>
 <1499968101.2740.10.camel@wdc.com>
 <20170713182018.GE11069@obsidianresearch.com>
 <1499970786.2740.17.camel@wdc.com>
 <20170713221520.GA10088@obsidianresearch.com>
 <1499985409.2740.24.camel@wdc.com>
 <20170713224137.GA24689@obsidianresearch.com>
 <1499985913.2740.26.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1499985913.2740.26.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 13, 2017 at 10:45:14PM +0000, Bart Van Assche wrote:

> Users who want to enable RDMA target functionality probably will know the
> names of the kernel modules that provide such functionality. On Debian
> systems the names of these kernel modules can e.g. be added to /etc/modules.
> However, I'm not sure all distro's have an equivalent of the /etc/modules
> file.

systemd supports /etc/modules-load.d/ as a built in, some distros will
symlink ../modules.conf to that directory, but these days dropping a
file in /etc/modules-load.d/ is pretty safe.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
