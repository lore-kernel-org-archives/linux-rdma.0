From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] infiniband/mlx5: Remove superfluous include of
 io-mapping.h
Date: Tue, 23 Aug 2016 22:24:24 +0100
Message-ID: <20160823212424.GA9014@nuc-i3427.alporthouse.com>
References: <20160823201626.13926-1-chris@chris-wilson.co.uk>
 <20160823211550.GQ15065@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160823211550.GQ15065@leon.nu>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Eli Cohen <eli@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 24, 2016 at 12:15:50AM +0300, Leon Romanovsky wrote:
> On Tue, Aug 23, 2016 at 09:16:26PM +0100, Chris Wilson wrote:
> > This file does not use any structs or functions defined by io-mapping.h
> > (nor does it directly use iomap, ioremap, iounamp or friends). Remove it
> > to simplify verification of changes to io-mapping.h
> > 
> > The include existed since its inception in
> > 
> > commit e126ba97dba9edeb6fafa3665b5f8497fc9cdf8c
> > Author: Eli Cohen <eli@mellanox.com>
> > Date:   Sun Jul 7 17:25:49 2013 +0300
> > 
> >     mlx5: Add driver for Mellanox Connect-IB adapters
> > 
> > which looks like a copy across from the Mellanox ethernet driver.
> > 
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> 
> I assume that it passed 0-day builds.
> 
> Except the commit message, which doesn't follow SubmittingPatches guide,
> it looks good.

If you mean the full commit reference rather than the short form, the
long form can be preferred if it lends significance. In this case I
wanted to highlight that it was the original commit that introduced the
include.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
