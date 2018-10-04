From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCHv1] RDMA/core: Check error status of
 rdma_find_ndev_for_src_ip_rcu
Date: Wed, 3 Oct 2018 20:48:12 -0600
Message-ID: <20181004024812.GA18596@ziepe.ca>
References: <1537542022-4451-1-git-send-email-parav@mellanox.com>
 <VI1PR0501MB2271905AAC309C636C0B63B7D1EA0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0501MB2271905AAC309C636C0B63B7D1EA0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Parav Pandit <parav@mellanox.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "leon@kernel.org" <leon@kernel.org>, Daniel Jurgens <danielj@mellanox.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 04, 2018 at 02:28:54AM +0000, Parav Pandit wrote:
> Hi Doug, Jason,
> 
> > From: Parav Pandit <parav@mellanox.com>
> > Sent: Friday, September 21, 2018 10:00 AM
> > To: linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org;
> > leon@kernel.org; jgg@ziepe.ca; syzkaller-bugs@googlegroups.com; Daniel
> > Jurgens <danielj@mellanox.com>; dledford@redhat.com
> > Cc: Parav Pandit <parav@mellanox.com>
> > Subject: [PATCHv1] RDMA/core: Check error status of
> > rdma_find_ndev_for_src_ip_rcu
> > 
> > rdma_find_ndev_for_src_ip_rcu() returns either valid netdev pointer or
> > ERR_PTR().
> > Instead of checking for NULL, check for error.
> > 
> > Fixes: caf1e3ae9fa6 ("RDMA/core Introduce and use
> > rdma_find_ndev_for_src_ip_rcu")
> > Reported-by: syzbot+20c32fa6ff84a2d28c36@syzkaller.appspotmail.com
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> >  drivers/infiniband/core/addr.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
> > index c2ca9e4..3c07eeb 100644
> > +++ b/drivers/infiniband/core/addr.c
> > @@ -513,8 +513,8 @@ static int rdma_set_src_addr_rcu(struct
> > rdma_dev_addr *dev_addr,
> >  		 * loopback IP address.
> >  		 */
> >  		ndev = rdma_find_ndev_for_src_ip_rcu(dev_net(ndev),
> > dst_in);
> > -		if (!ndev)
> > -			return -ENODEV;
> > +		if (IS_ERR(ndev))
> > +			return PTR_ERR(ndev);
> >  	}
> > 
> >  	return copy_src_l2_addr(dev_addr, dst_in, dst, ndev);
> 
> Can you please review this fix?  I got below report from syzbot that
> it tested the patch and reproducer didn't trigger.

It is very strange, but this patch does not show up in rdma's patch
works.

This happened to Dennis as well for one patch, I'm afraid as a general
rule, people will need to check that patchworks has thier patches, and
maybe talk to LF IT about why things have gone missing. 

I would guess it is some spam filter issue?

I have applied this patch from my email.

Jason
