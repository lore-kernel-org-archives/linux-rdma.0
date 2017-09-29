From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] i40iw: delete some stray tabs
Date: Fri, 29 Sep 2017 13:40:04 +0300
Message-ID: <20170929104004.svcnntqmgdxnzgnn@mwanda>
References: <20170929074943.cs2jea5xttk2r6vm@mwanda>
 <20170929102929.GA2723@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170929102929.GA2723@mtr-leonro.local>
Sender: kernel-janitors-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 29, 2017 at 01:29:29PM +0300, Leon Romanovsky wrote:
> On Fri, Sep 29, 2017 at 10:49:43AM +0300, Dan Carpenter wrote:
> > These lines were indented too far by mistake.
> >
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> >
> > diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> 
> Dan,,
> 
> I saw in your patches and don't know if it important. There is no
> diffstat after your Signed-off-by and there is no "---" trailing line
> too.

Yeah.  I leave those out.  I normally write two line patches like this
one so the diffstat is normally -2+2 and I figure people will see that
they're tiny just from glancing at the email.  When I create patches
that touch multiple files, what I do is just merge the diffs together in
my email client.  If I tried to create diffstats for those, I'd just end
up messing up a lot.

regards,
dan carpenter

