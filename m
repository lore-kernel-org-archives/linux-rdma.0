From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [RFC v1 15/19] RDMA/irdma: Add miscellaneous utility definitions
Date: Wed, 20 Feb 2019 09:51:27 +0200
Message-ID: <20190220075127.GY16218@mtr-leonro.mtl.com>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-16-shiraz.saleem@intel.com>
 <20190215174714.GE30706@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/d7X7C0hV/blnKmH"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190215174714.GE30706@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Shiraz Saleem <shiraz.saleem@intel.com>, dledford@redhat.com, davem@davemloft.net, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com
List-Id: linux-rdma@vger.kernel.org


--/d7X7C0hV/blnKmH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 15, 2019 at 10:47:14AM -0700, Jason Gunthorpe wrote:
> On Fri, Feb 15, 2019 at 11:11:02AM -0600, Shiraz Saleem wrote:
> > From: Mustafa Ismail <mustafa.ismail@intel.com>
> >
> > Add miscellaneous utility functions and headers.
> >
> > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> >  drivers/infiniband/hw/irdma/osdep.h  |  153 ++
> >  drivers/infiniband/hw/irdma/protos.h |  118 ++
> >  drivers/infiniband/hw/irdma/status.h |   70 +
> >  drivers/infiniband/hw/irdma/utils.c  | 2565 ++++++++++++++++++++++++++++++++++
> >  4 files changed, 2906 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/irdma/osdep.h
> >  create mode 100644 drivers/infiniband/hw/irdma/protos.h
> >  create mode 100644 drivers/infiniband/hw/irdma/status.h
> >  create mode 100644 drivers/infiniband/hw/irdma/utils.c
> >
> > diff --git a/drivers/infiniband/hw/irdma/osdep.h b/drivers/infiniband/hw/irdma/osdep.h
> > new file mode 100644
> > index 0000000..ade5536
> > +++ b/drivers/infiniband/hw/irdma/osdep.h
> > @@ -0,0 +1,153 @@
> > +/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
> > +/* Copyright (c) 2019, Intel Corporation. */
> > +
> > +#ifndef IRDMA_OSDEP_H
> > +#define IRDMA_OSDEP_H
> > +
> > +#include <linux/version.h>
> > +#include <linux/kernel.h>
> > +#include <linux/vmalloc.h>
> > +#include <linux/string.h>
> > +#include <linux/bitops.h>
> > +#include <linux/pci.h>
> > +#include <net/tcp.h>
> > +#include <crypto/hash.h>
> > +/* get readq/writeq support for 32 bit kernels, use the low-first version */
> > +#include <linux/io-64-nonatomic-lo-hi.h>
> > +
> > +#define STATS_TIMER_DELAY	60000
> > +#define MAKEMASK(m, s)		((m) << (s))

Really? Abstraction for "<<"?

> > +
> > +#define irdma_pr_err(fmt, args ...)				\
> > +	pr_err("%s: "fmt, __func__, ## args)
> > +
> > +#define irdma_pr_info(fmt, args ...)				\
> > +	pr_info("%s: " fmt, __func__, ## args)
> > +
> > +#define irdma_pr_warn(fmt, args ...)				\
> > +	pr_warn("%s: " fmt, __func__, ## args)
> > +
> > +#define irdma_dev_err(dev, fmt, args ...)			\
> > +	dev_err(to_device(dev), "%s: "fmt, __func__, ## args)
> > +
> > +#define irdma_dev_info(dev, fmt, args ...)			\
> > +	dev_info(to_device(dev), "%s: "fmt, __func__, ## args)
> > +
> > +#define irdma_dev_warn(dev, fmt, args ...)			\
> > +	dev_warn(to_device(dev), "%s: "fmt, __func__, ## args)
>
> Does every driver really have to define these macros?

Every time when I see it, I'm asking myself the same question.

Thanks

--/d7X7C0hV/blnKmH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcbQb/AAoJEORje4g2clinvYkP/1Ltkwf4uLALGLUHGx8oH72u
/ev9VNy2v+l1snAAtxkBvpOdHk39aTXLybsZ5t1JDExMXC/y14zcjrS0LwXc1//z
qvUqtDADxHMIyRowZRdzYlhqe55RUbqdD6hgWAkk9+q/5NOUiI9E9FpF23dYIXQf
r3TtR0Wgj9TKd8Wj1OHubfTOH3MDj0Q89oI1bEYsq0mUweP22YR+KfKf9QfehSIP
LR9WIc7dTYw+gHXu3SwfCEQfVTyHxgOsTCylI4MkMS6LX/4TrnMYjGR5585tVwc3
PbyFXTREvlV1zOitg2UrjDb5Gc41II/6lmxfumLrVTPM4M4j+YuMvc/cg0zHhFvj
CpfAbL/f4nYKs6MKkO/aEyWYSMDocR28SqOFPrLhf6BBo0NRIDw3hL7iXfiKZSLw
cGcYg0J98jJUiKU2ZYcv9rvpBgfm3kG9QOf0duTpVU6lQd4ysBx78WmaxRmJ6mPv
3ZcOcooeqdvTeGHCuv1ha8XJi0pkEb6TcJPq7jzNguPAsbsXn2JF1Q1BuBnEQlfN
vIiovRU21sHA52iXBhWjzAM0NzG7u0i/4Q7PjH2PJcOU0nwRkemNYwDDS9nCGMw7
HRknDOnDCYHKShQ35A2udlZFulStAGJQvqyhgBCUxqKjZW0C5qmeFQEJYbpABnvp
jTVGgw6sIzYfLCjGBhPh
=tag8
-----END PGP SIGNATURE-----

--/d7X7C0hV/blnKmH--
