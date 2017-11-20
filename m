From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH] rdma: Add Jason as a co-maintainer
Date: Mon, 20 Nov 2017 11:06:31 -0700
Message-ID: <20171120180631.GE626@mellanox.com>
References: <20171116204400.GA28216@mellanox.com>
 <20171120161016.GL18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171120161016.GL18825@mtr-leonro.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 20, 2017 at 06:10:16PM +0200, Leon Romanovsky wrote:
> On Thu, Nov 16, 2017 at 01:44:00PM -0700, Jason Gunthorpe wrote:
> > As was discussed in September and October, add Jason along with
> > Doug to have a team maintainership model for the RDMA subystem.
> >
> > Mellanox Technologies will be funding Jason's independent work on
> > the maintainership.
> >
> > Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> >  .mailmap    | 2 ++
> >  MAINTAINERS | 1 +
> >  2 files changed, 3 insertions(+)
> >
> 
> Doug and Jason,
> 
> Can you forward the current fixes to Linus?
> 
> I have more fixes from Parav and fix to iWARP from Daniel, but I prefer
> to have proper RDMA branches before I'm posting them.

I belive Doug has already sent the pull request for this merge window,
and the new shared tree location is fully up to date, and there are
no accepted but unset patches at this time?

Do you see otherwise?

We are now doing patches for rc.

The iWarp security fix from Daniel is definitely rc material.

Can you split that 33 patch series into things you think are rc
material?

Jason
