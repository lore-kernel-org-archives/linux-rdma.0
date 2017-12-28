From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-next 2/2] RDMA/hns: Fix alignment problem of the
 doorbell
Date: Thu, 28 Dec 2017 09:00:54 -0700
Message-ID: <20171228160054.GV25436@ziepe.ca>
References: <1514209039-9388-1-git-send-email-liuyixian@huawei.com>
 <1514209039-9388-3-git-send-email-liuyixian@huawei.com>
 <20171226081526.GB10734@mtr-leonro.local>
 <6f657295-ab91-a940-c1d8-8d85dcedb4ea@huawei.com>
 <20171227164407.GB25436@ziepe.ca>
 <2a0a56fb-1ec8-dfc9-3c29-c9bae7bd9bae@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2a0a56fb-1ec8-dfc9-3c29-c9bae7bd9bae-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 28, 2017 at 02:48:10PM +0800, Liuyixian (Eason) wrote:

> And I also find a discussion on the usage of union. It also mentions that
> we can only get the "active" member from an union.
> https://stackoverflow.com/questions/2310483/purpose-of-unions-in-c-and-c

linux requires a compiler that supports the C99 model of allowing type
punning with unions.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
