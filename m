From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH rdma-core] debian: Only run udevadm if the binary is
 available
Date: Thu, 28 Dec 2017 10:18:46 +0100
Message-ID: <1514452726.4412.20.camel@profitbricks.com>
References: <20171227104135.24391-1-benjamin.drung@profitbricks.com>
         <20171227202627.GH25436@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171227202627.GH25436-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Am Mittwoch, den 27.12.2017, 13:26 -0700 schrieb Jason Gunthorpe:
> On Wed, Dec 27, 2017 at 11:41:35AM +0100, Benjamin Drung wrote:
> > When udevadm is not available (e.g. in a minimal chroot
> > environment),
> > the rdma-core package installation will print these warnings:
> > 
> > /var/lib/dpkg/info/rdma-core.postinst: 33:
> > /var/lib/dpkg/info/rdma-core.postinst: udevadm: not found
> > /var/lib/dpkg/info/rdma-core.postinst: 34:
> > /var/lib/dpkg/info/rdma-core.postinst: udevadm: not found
> > /var/lib/dpkg/info/rdma-core.postinst: 35:
> > /var/lib/dpkg/info/rdma-core.postinst: udevadm: not found
> > 
> > To silence these warnings, only run udevadm if this binary is
> > available.
> > 
> > Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> >  debian/rdma-core.postinst | 8 +++++---
> >  debian/srptools.postinst  | 4 +++-
> >  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> Hurm. Some packages have this which test, others do not..
> 
> I'm confused how we get to a state where rdma-core can be installed
> without udev? Virtually the entire purpose of that package revolves
> around udev and systemd ... So are we missing a dependency?

Adding a dependency on udev is a solution too and is probably the
better solution.

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
