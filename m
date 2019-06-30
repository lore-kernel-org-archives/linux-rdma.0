From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next v1 00/12] DEVX asynchronous events
Date: Sun, 30 Jun 2019 11:53:35 +0300
Message-ID: <20190630085335.GD4727@mtr-leonro.mtl.com>
References: <20190618171540.11729-1-leon@kernel.org>
 <19107c92279cf4ad4d870fa54514423c5e46b748.camel@mellanox.com>
 <20190619044557.GA11611@mtr-leonro.mtl.com>
 <a8de53f1acb069057dedc94fb8bd29ea3e658716.camel@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a8de53f1acb069057dedc94fb8bd29ea3e658716.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 24, 2019 at 09:57:05PM +0000, Saeed Mahameed wrote:
> On Wed, 2019-06-19 at 07:45 +0300, Leon Romanovsky wrote:
> > On Tue, Jun 18, 2019 at 06:51:45PM +0000, Saeed Mahameed wrote:
> > > On Tue, 2019-06-18 at 20:15 +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@mellanox.com>
> > > >
> > > > Changelog:
> > > >  v0 -> v1:
> > >
> > > Normally 1st submission is V1 and 2nd is V2.
> > > so this should have been v1->v2.
> >
> > "Normally" depends on the language you are using. In C, everything
> > starts from 0, including version of patches :).
> >
>
> You are wrong:
> quoting: https://kernelnewbies.org/PatchTipsAndTricks
>
> "For example, if you're sending the second revision of a patch, you
> should use [PATCH v2]."
>
> now don't tell me that second revision is actually 3rd revision or 1st
> is 2nd :)..

:)

If you don't mind, I will stick to common sense (v0, v1, v2 ...)
and official kernel documentation, which mentions existence of v1.

https://elixir.bootlin.com/linux/latest/source/Documentation/process/submitting-patches.rst#L682

>
> > > For mlx5-next patches:
> > >
> > > Acked-by: Saeed Mahameed <saeedm@mellanox.com>
> >
> > Thanks
