From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next v2 0/8] Support mlx5 flow steering with RAW data
Date: Thu, 26 Jul 2018 08:58:09 -0600
Message-ID: <20180726145809.GB10168@ziepe.ca>
References: <20180723122512.20967-1-leon@kernel.org>
 <20180724024236.GA16958@ziepe.ca>
 <20180724055609.GG3189@mtr-leonro.mtl.com>
 <20180724201300.GQ532@ziepe.ca>
 <20180725053703.GK3189@mtr-leonro.mtl.com>
 <20180725143517.GU532@ziepe.ca>
 <20180726043549.GZ3189@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180726043549.GZ3189@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 26, 2018 at 07:35:49AM +0300, Leon Romanovsky wrote:
> On Wed, Jul 25, 2018 at 08:35:17AM -0600, Jason Gunthorpe wrote:
> > On Wed, Jul 25, 2018 at 08:37:03AM +0300, Leon Romanovsky wrote:
> >
> > > > Also, I would like to keep the specs consistently formatted according
> > > > to clang-format with 'BinPackParameters: true', so I reflowed them as
> > > > well.
> > >
> > > I'm using default VIM clang-format.py without anything in .clang-format.
> > > Do you have an extra definitions there, except BinPackParameters?
> >
> > These days Linux includes a top level .clang-format that does a
> > pretty good job.
> >
> > I have to manually switch BinPackParameters on when working with these
> > specs to get the right indenting.. A pain, but maybe there is a better
> > way someday..
> 
> I don't think that it is feasible to ask from people to change some
> defaults only for patches that touch those specs. Any change in this
> area will change formatting back.

Eventually I think we might be able toadd a code comment to tell
clang-format, but that would be down the road a bit..

> Jason, bottom line, I won't use BinPackParameters for my patches.

Well, you can make sure the specs macro follows the required
formatting code style by hand if you prefer..

But, I want to see them in this layout, so they are easier to
maintain, not the haphazard layout we had before.

Jason
