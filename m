From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v3 1/2] idr: Add ida_simple_get_cyclic
Date: Thu, 7 Jun 2018 12:50:38 -0600
Message-ID: <20180607185038.GF14583@ziepe.ca>
References: <20180529073808.27735-1-hans.westgaard.ry@oracle.com>
 <20180607111435.17538-1-hans.westgaard.ry@oracle.com>
 <20180607111435.17538-2-hans.westgaard.ry@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180607111435.17538-2-hans.westgaard.ry@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>, Hakon Bugge <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Pravin Shedge <pravin.shedge4linux@gmail.com>, Matthew Wilcox <mawilcox@microsoft.com>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@kernel.org>, Wei Wang <wei.w.wang@intel.com>, Chris Mi <chrism@mellanox.com>, Eric Biggers <ebiggers@google.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Mel Gorman <mgorman@techsingularity.net>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 07, 2018 at 01:14:34PM +0200, Hans Westgaard Ry wrote:
> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> ---
>  include/linux/idr.h |  8 +++++--
>  lib/idr.c           | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 72 insertions(+), 2 deletions(-)

If you are going to do this you should convert the other places that
open coded this as well..

Jason
