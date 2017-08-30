From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] suse: Add spec file for SUSE
Date: Tue, 29 Aug 2017 19:24:51 -0600
Message-ID: <20170830012451.GA27687@obsidianresearch.com>
References: <20170827214704.GC14542@obsidianresearch.com>
 <ecddc225-0dc5-c51f-535b-c2bee252d5ed@suse.de>
 <20170828060758.GD12880@mtr-leonro.local>
 <86a21008-c993-de29-2cb9-845af14c4cd5@suse.de>
 <20170828090537.GG12880@mtr-leonro.local>
 <0754696d-42d5-5083-8ed0-435ab3f189de@suse.de>
 <20170828152254.GB7867@obsidianresearch.com>
 <ea729fa9-6f6e-9834-ff77-377b1e843f79@vmware.com>
 <20170828172954.GA21341@obsidianresearch.com>
 <32d85325-7aa0-edfe-eaca-213102ea14bd@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32d85325-7aa0-edfe-eaca-213102ea14bd-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 29, 2017 at 05:31:47PM -0700, Adit Ranadive wrote:
> > For best results, yes.. You have to disable the rdma.service that still comes in
> > the rpms.
> > 
> > After booting run
> > 
> > udevadm info /sys/class/infiniband/XX
> > 
> > where XX is the rdma name of a vmw_pvrdma device, and confirm the
> > ID_RDMA_ROCE is setup. Check the rest of the modules loaded and so forth.
> 
> Hmm, so I added that line to rdma-description.rules, generated and installed
> the rpms. udevadm shows me this:
> 
> $> udevadm info /sys/class/infiniband/vmw_pvrdma0 | grep -i id_rdma
> E: ID_RDMA_ROCE=1
> 
> I'm guessing thats the output you're looking for?

Yes, that is good

> Sorry I'm not an expert on the udev stuff but what does the RDMA_ROCE environment
> correspond to here - just the various modules to be loaded and/or something else?

These variables inside udev are used by other rules inside udev. If
anything sets ID_RDMA_ROCE it triggers other udev rules to tell
systemd to activate all the roce related rules.

I'll send a patch for adding the vmw_pvrdma

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
