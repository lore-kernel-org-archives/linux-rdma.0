From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/cm: Remove unused and erroneous msg sequence encoding
Date: Mon, 9 Jul 2018 11:42:17 -0600
Message-ID: <20180709174217.GA2658@ziepe.ca>
References: <20180704104801.912482-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180704104801.912482-1-Haakon.Bugge@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>, Don Hiatt <don.hiatt@intel.com>, Ira Weiny <ira.weiny@intel.com>, Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 04, 2018 at 12:48:01PM +0200, Håkon Bugge wrote:
> In cm_form_tid(), a two bit message sequence number is OR'ed into bit
> 31-30 of the lower TID value.
> 
> After commit f06d26537559 ("IB/cm: Randomize starting comm ID"), the
> local_id is XOR'ed with a 32-bit random value. Hence, bit 31-30 in the
> lower TID now has an arbitrarily value and it makes no sense to OR in
> the message sequence number.
> 
> Adding to that, the evolution in use of IDR routines in cm_alloc_id()
> has always had the possibility of returning a value with bit 30 set.
> 
> In addition, said bits are never checked.
> 
> Hence, remove the encoding and the corresponding enum.
> 
> Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
> ---
>  drivers/infiniband/core/cm.c      | 14 ++++++--------
>  drivers/infiniband/core/cm_msgs.h |  7 -------
>  2 files changed, 6 insertions(+), 15 deletions(-)

Applied to for-next, thanks

I suspect the bits were probably added long ago for debugging..

Jason
