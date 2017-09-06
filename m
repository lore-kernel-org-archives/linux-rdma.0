From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] libmlx5: add support for the s390x platform
Date: Wed, 6 Sep 2017 09:22:08 -0600
Message-ID: <20170906152208.GB6262@obsidianresearch.com>
References: <20170906133620.58716-1-kmeesomp@linux.vnet.ibm.com>
 <20170906141500.GJ18084@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170906141500.GJ18084-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kittipon Meesompop <kmeesomp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 06, 2017 at 05:15:00PM +0300, Leon Romanovsky wrote:
> On Wed, Sep 06, 2017 at 03:36:20PM +0200, Kittipon Meesompop wrote:
> > Since s390x platform requires execution of privileged CPU instructions
> > to work with PCI I/O memory, the PCI I/O memory cannot be directly
> > accessed from the userspace programs via the mapped memory areas.
> >
> > This patch is created against libmlx5-1.2.1 and contains the changes to
> > the libmlx5 userspace Mellanox device driver library required to provide
> > support for the DAPL API on the s390x platform. The original code that
> > directly used mapped memory areas to access the PCI I/O memory of the
> > Mellanox networking device is replaced with the new system call
> > invocation for writing the data to mapped memory areas. The functions
> > for reading and writing are added analogously to libmlx4.
> >
> > libmlx4 comparison to:
> >         commit f5c26f8762135f629c8cbe73d808e3029f07b176
> >         Author: Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> >         Date:   Wed Nov 19 11:17:19 2014 +0100
> >
> > Signed-off-by: Kittipon Meesompop <kmeesomp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> >
> 
> Thank you for doing it. I afraid that you sent this patch to a wrong
> mailing list. I don't know exactly where you should sent it, but all
> new development for last ~12 months of RDMA user space stack is done
> against rdma-core [1].

.. and I already did s390 support for mlx5 drivers in rdma-core, you
should test it.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
