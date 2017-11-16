From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Bug#881814: Processed: libibverbs-dev no longer ships infiniband/driver.h
Date: Thu, 16 Nov 2017 13:42:36 +0100
Message-ID: <1510836156.4026.96.camel@profitbricks.com>
References: <151075140461.17370.2844187627354872362.reportbug@localhost>  <151075140461.17370.2844187627354872362.reportbug@localhost>  <handler.s.B.15107514116787.transcript@bugs.debian.org>  <20171115171657.GQ25894@ziepe.ca> <151075140461.17370.2844187627354872362.reportbug@localhost>
Reply-To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>,
          881814-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171115171657.GQ25894-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, 881814-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
Cc: Adrian Bunk <bunk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

reassign 881814 src:libfabric 1.4.0-1
thanks

Am Mittwoch, den 15.11.2017, 10:16 -0700 schrieb Jason Gunthorpe:
> > libibverbs-dev
> > src:librdmacm
> > src:libcxgb3
> > src:libmlx4
> > src:libipathverbs
> > src:libmlx5
> > src:libibcm
> > src:libmthca
> > src:libnes
> 
> These are now all part of rdma-core. These packages should be removed
> from unstable and all other release suites that have rdma-core.
> 
> It is an error to attempt to build them against rdma-core.
> 
> > src:libfabric
> 
> This is has been fixed in libfabric upstream, look for patches from
> me.

This is commit 2a3f5b0bd56296e41729b56bb70eaa94439848cc which is part
of release 1.5.0. So either upgrade libfabric to >= 1.5.0 or cherry-
pick that patch. I recommend to update to 1.5.2.

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL: https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Geschäftsführer: Achim Weiss, Matthias Steinberg
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
