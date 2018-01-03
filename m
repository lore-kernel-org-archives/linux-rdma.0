From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] ethernet: mlx4: Delete an error message for a failed
 memory allocation in five functions
Date: Wed, 3 Jan 2018 09:03:16 -0700
Message-ID: <20180103160316.GB11348@ziepe.ca>
References: <30191db0-4d99-0349-b66a-c7354ef90d50@users.sourceforge.net>
 <0fea8f2f-f8fc-ce2e-3d33-44227de3637a@mellanox.com>
 <alpine.DEB.2.20.1801030904290.5305@hadrien>
 <adfc3229-d3f9-afb9-00e6-9f765af0cbe8@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <adfc3229-d3f9-afb9-00e6-9f765af0cbe8@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Tariq Toukan <tariqt@mellanox.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, SF Markus Elfring <elfring@users.sourceforge.net>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 03, 2018 at 01:24:59PM +0200, Tariq Toukan wrote:

> >Strings take up space.  Since there is a backtrace on an out of memory
> >problem, if the string does not provide any more information than the
> >position of the call, then there is not much added value.  I don't know
> >what was the string in this case.  If it provides some additional
> >information, then it would be reasonable to keep it.
> 
> I don't really accept this claim...

The standard we are moving to is to rely on the backtrace print for
debugging. It is so huge it is unlikely a single print from the driver
will make much difference to the user's view.

Most users think backtrace == oops == bug report.

> In addition, some out-of-memory errors are recoverable, even though their
> backtrace is also printed. For example, in function mlx4_en_create_cq
> (appears in patch) we have a first allocation attempt (kzalloc_node) and a
> fallback (kzalloc).

Please send a patch fixing this as other have suggested, it is clearly
a bug.

Jason
