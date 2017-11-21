From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core] libhns: Add rereg mr interface in userspace
Date: Tue, 21 Nov 2017 08:18:08 -0700
Message-ID: <20171121151808.GT29075@ziepe.ca>
References: <1511266846-137693-1-git-send-email-oulijun@huawei.com>
 <20171121135310.GV18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171121135310.GV18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 21, 2017 at 03:53:10PM +0200, Leon Romanovsky wrote:
> > +	if (flags & IBV_REREG_MR_KEEP_VALID)
> > +		return ENOTSUP;
> 
> You need to write the supported flags here, so the people will
> be able to extend ibv_rereg_mr_flags without worries about your driver.

And doesn't the kernel check flags anyhow? Why do you need to also
check it in userspace?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
