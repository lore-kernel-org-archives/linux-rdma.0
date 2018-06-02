From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next v3 05/14] IB/uverbs: Add create/destroy
 counters support
Date: Sat, 2 Jun 2018 08:05:56 +0300
Message-ID: <20180602050556.GI2843@mtr-leonro.mtl.com>
References: <20180531134341.18441-1-leon@kernel.org>
 <20180531134341.18441-6-leon@kernel.org>
 <20180601205436.GA20377@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1Ow488MNN9B9o/ov"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180601205436.GA20377@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, "Michael J . Ruhl" <michael.j.ruhl@intel.com>, Or Gerlitz <ogerlitz@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--1Ow488MNN9B9o/ov
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 01, 2018 at 02:54:36PM -0600, Jason Gunthorpe wrote:
> > diff --git a/drivers/infiniband/core/uverbs_std_types_counters.c b/drivers/infiniband/core/uverbs_std_types_counters.c
> > new file mode 100644
> > index 000000000000..a5bc50ceee13
> > +++ b/drivers/infiniband/core/uverbs_std_types_counters.c
> > @@ -0,0 +1,100 @@
> > +/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
>
> Check patch tells me this is malformed should be:
>
> // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
>
> Apparently the WITH Linux-syscall-note is only used in uapi header
> files.
>
> > +/*
> > + * Copyright (c) 2018, Mellanox Technologies inc.  All rights reserved.
> > + *
> > + * This software is available to you under a choice of one of two
> > + * licenses.  You may choose to be licensed under the terms of the GNU
> > + * General Public License (GPL) Version 2, available from the file
> > + * COPYING in the main directory of this source tree, or the
> > + * OpenIB.org BSD license below:
> > + *
> > + *     Redistribution and use in source and binary forms, with or
> > + *     without modification, are permitted provided that the following
> > + *     conditions are met:
> > + *
> > + *      - Redistributions of source code must retain the above
> > + *        copyright notice, this list of conditions and the following
> > + *        disclaimer.
> > + *
> > + *      - Redistributions in binary form must reproduce the above
> > + *        copyright notice, this list of conditions and the following
> > + *        disclaimer in the documentation and/or other materials
> > + *        provided with the distribution.
> > + *
> > + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> > + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> > + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> > + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> > + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> > + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> > + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> > + * SOFTWARE.
> > + */
>
> And this is not a SPDX BSD-2-Clause license, this is the SPDX
> Linux-OpenIB license.
>
> Please be careful to use the correct tag with SPDX..
>
> Also can you check if these SPDX tags are what are intended:
>
> include/rdma/restrack.h:/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
> drivers/infiniband/core/restrack.c:/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
> drivers/infiniband/hw/mlx5/ib_rep.c:/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
> drivers/infiniband/hw/mlx5/ib_rep.h:/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
>
> I'm not super excited about the license proliferation, so if they
> should have been OR Linux-OpenIB as well then please send a patch.

They are supposed to be OpenIB.

Thanks

>
> Jason

--1Ow488MNN9B9o/ov
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbEiW0AAoJEORje4g2clinsjgP/AlvwyaSgxh+dmP2xwRV9VvA
NcJW9UNL4jlt8Sx5v6DWdfHG2deBx0RD0dHWqPARQ5HgrxTMKJiMCh/TYvDeVk2q
LABAb/jddi0evMjP6+pV2jyzdeqXCiRmmp03sLcMTxOWvkqK0sUpL2Qh9TC5oLgA
Vzocc/vvt5RIWJYswzTJ2JimCGiB/J/RndGBS7joPm+bJocCta806c3Q60Jf6mDY
ybOIbYA3XhjGLMzkYQM86aDMEa1WSjV5flQDuVabp9SuYBZE47/AgI2jdFPf5HBU
v+s632+Ko/gJRzKb+Bv0zmuAV49A2Qx0cdvMbIRT3oiCTd9qd+E3PYctm2yHeM9D
YZ5hKOGhF4jETqaQDHKtYkvJI3WvKyYc0Qc1eaFkNDgRNjxmeKTBQkva9R8s7o0R
CHV3XJGQ2NWgIEzU0NvN6bboEgH4mILGNf/eHpdj7HP5Mf6jm/w6CQuC59jYO/No
YpTlPSNcfnBJtZD0hB7U23Z4xM9w4oIzk2Qg2e/AtBYgwCigy8+DZ2xLNrRu8JVV
o8zI6Cg7wlV6rxm7vhEKHZzqCowE2upg+ERwlnReqfO85jZ54QEq8wEhl9bgQXhw
a883/FLAobglynspuO6lep4MjE5qE3jSuz+XrmuLK4CGwir6fF7pmrLCgBdRa+Ff
6+IHOR866vRQAIcA/FaF
=CMOT
-----END PGP SIGNATURE-----

--1Ow488MNN9B9o/ov--
