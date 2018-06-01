From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next v3 05/14] IB/uverbs: Add create/destroy
 counters support
Date: Fri, 1 Jun 2018 14:54:36 -0600
Message-ID: <20180601205436.GA20377@ziepe.ca>
References: <20180531134341.18441-1-leon@kernel.org>
 <20180531134341.18441-6-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180531134341.18441-6-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, "Michael J . Ruhl" <michael.j.ruhl@intel.com>, Or Gerlitz <ogerlitz@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/drivers/infiniband/core/uverbs_std_types_counters.c b/drivers/infiniband/core/uverbs_std_types_counters.c
> new file mode 100644
> index 000000000000..a5bc50ceee13
> +++ b/drivers/infiniband/core/uverbs_std_types_counters.c
> @@ -0,0 +1,100 @@
> +/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */

Check patch tells me this is malformed should be:

// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB

Apparently the WITH Linux-syscall-note is only used in uapi header
files.

> +/*
> + * Copyright (c) 2018, Mellanox Technologies inc.  All rights reserved.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */

And this is not a SPDX BSD-2-Clause license, this is the SPDX
Linux-OpenIB license.

Please be careful to use the correct tag with SPDX..

Also can you check if these SPDX tags are what are intended:

include/rdma/restrack.h:/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
drivers/infiniband/core/restrack.c:/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
drivers/infiniband/hw/mlx5/ib_rep.c:/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
drivers/infiniband/hw/mlx5/ib_rep.h:/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */

I'm not super excited about the license proliferation, so if they
should have been OR Linux-OpenIB as well then please send a patch.

Jason
