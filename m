From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/3] Add support for dynamic UAR usage
Date: Thu, 28 Dec 2017 13:01:49 -0700
Message-ID: <20171228200149.GB11721@ziepe.ca>
References: <20171224143136.12306-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171224143136.12306-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 24, 2017 at 04:31:33PM +0200, Leon Romanovsky wrote:
> >From Yishai:
> 
> This series enables the user space driver to ask for a dynamic UAR
> allocation and uses its internal BF (i.e. blue-flame) registers as part
> of QP creation.
> 
> The motivation behind this functionality is to let the user space driver
> share BF register between few QPs or to set a dedicated BF for a given QP.
> 
> The above gives an option to user space applications to utilize its
> resources and performance according to its needs.
> 
> For example:
> An application can improve its performance by having a dedicated BF for
> collection of QPs that are running from the same thread and drop the
> need to take a lock as part of its post send flow. This is not enabled
> today as the kernel driver assigned BF registers in some FIFO logic and
> as such QPs from different threads may share same BF and as such a lock
> when accessing this BF will be needed.
> 
> The series consists from 3 patches:
> The first patch extends the alloc context flow to be prepared for
> working with dynamic UAR allocations.
> The second patch exposes the option to dynamic allocates a UAR.
> The third patch uses the given BF register from the user area as
> part of QP creation instead of using some arbitrary BF register.
> 
> The patches are available in the git repository at:
>   git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-12-24-5

Applied to for-next

Thanks
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
