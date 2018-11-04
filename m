From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH iproute2-next v2] rdma: Document IB device renaming option
Date: Sun, 4 Nov 2018 21:00:04 +0200
Message-ID: <20181104190004.GC3638@mtr-leonro.mtl.com>
References: <20181104115405.9455-1-leon@kernel.org>
 <07ffbccc-916c-25d3-654e-7e457be3c133@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <07ffbccc-916c-25d3-654e-7e457be3c133@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 04, 2018 at 07:26:24AM -0700, David Ahern wrote:
> On 11/4/18 4:54 AM, Leon Romanovsky wrote:
> > @@ -45,6 +53,11 @@ rdma dev show mlx5_3
> >  Shows the state of specified RDMA device.
> >  .RE
> >  .PP
> > +rdma dev set mlx5_3 name rdma_0
> > +.RS 4
> > +Renames the mlx5_3 device to be named rdma_0.
> > +.RE
> > +.PP
>
> You missed my other comment: Fix the "Renames .... to be named ..."

Sorry, my bad.

I'm resending it right now.

Thanks
