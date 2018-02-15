From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix completion vector assignment algorithm
Date: Thu, 15 Feb 2018 15:39:52 -0700
Message-ID: <20180215223952.GA7766@ziepe.ca>
References: <20180212175025.18955-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180212175025.18955-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Schmid <alex-8Qr8HBQMDtZ/RfFiNYuDoCgLtw5krbHi@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 12, 2018 at 09:50:25AM -0800, Bart Van Assche wrote:
> Ensure that cv_end is equal to ibdev->num_comp_vectors for the
> NUMA node with the highest index. This patch improves spreading
> of RDMA channels over completion vectors and thereby improves
> performance, especially on systems with only a single NUMA node.
> This patch drops support for the comp_vector login parameter by
> ignoring the value of that parameter since I have not found a
> good way to combine support for that parameter and automatic
> spreading of RDMA channels over completion vectors.
> 
> Fixes: d92c0da71a35 ("IB/srp: Add multichannel support")
> Reported-by: Alexander Schmid <alex-8Qr8HBQMDtZ/RfFiNYuDoCgLtw5krbHi@public.gmane.org>
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> Cc: Alexander Schmid <alex-8Qr8HBQMDtZ/RfFiNYuDoCgLtw5krbHi@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>  drivers/infiniband/ulp/srp/ib_srp.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)

Applied to for-next

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
