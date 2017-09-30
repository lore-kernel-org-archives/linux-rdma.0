From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] libhns: Update the size and member order of
 hns_roce_create_qp structure
Date: Sat, 30 Sep 2017 10:29:53 -0600
Message-ID: <20170930162953.GA15393@obsidianresearch.com>
References: <1506761477-47350-1-git-send-email-oulijun@huawei.com>
 <20170930154518.GA14152@obsidianresearch.com>
 <20170930160515.GG2965@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170930160515.GG2965-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Sep 30, 2017 at 07:05:15PM +0300, Leon Romanovsky wrote:
> On Sat, Sep 30, 2017 at 09:45:18AM -0600, Jason Gunthorpe wrote:
> > On Sat, Sep 30, 2017 at 04:51:17PM +0800, Lijun Ou wrote:
> > > In order to keep the size and member order with the
> > > hns_roce_ib_create_qp sturcture of the kernel driver,
> > > it need to update hns_roce_create_qp's structure
> > > members. Otherwise, it will run fail.
> >
> > What?
> >
> > Did you break the uapi? What kernel patch does this match with?
> >
> > Generally structs in the u_abi.h headers cannot be changed like this.
> 
> Jason,
> 
> It was my suggestion to change rdma-core, because before they tried to
> change kernel.
> 
> https://patchwork.kernel.org/patch/9975329/

Ugh, better commit messages please.

Also, the patch is wrong, it needs to exactly duplicate the current
kernel struct word for word. You can send some thing else once the
kernel side is accepted.

How did we get to a point where hns in rdma-core doesn't work with the
kernel code? Is huawei not testing this stuff?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
