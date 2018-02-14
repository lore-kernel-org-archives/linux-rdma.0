From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH] rxe: Do not use 'struct sockaddr' in a uapi header
Date: Wed, 14 Feb 2018 16:54:12 -0700
Message-ID: <20180214235412.GD16962@ziepe.ca>
References: <20180207234910.GA14608@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180207234910.GA14608-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 07, 2018 at 04:49:10PM -0700, Jason Gunthorpe wrote:
> Linux has two 'linux/socket.h' files - and only the one in the kernel
> defines struct sockaddr - the user space one does not.
> 
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  drivers/infiniband/sw/rxe/rxe_av.c | 5 +++--
>  include/uapi/rdma/rdma_user_rxe.h  | 4 +++-
>  2 files changed, 6 insertions(+), 3 deletions(-)

applied to -next

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
