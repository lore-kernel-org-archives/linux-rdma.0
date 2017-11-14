From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: rdma-core_15-1_amd64.changes ACCEPTED into unstable
Date: Tue, 14 Nov 2017 11:47:19 -0700
Message-ID: <20171114184719.GC4263@ziepe.ca>
References: <E1eENiD-000EaM-BG@fasolo.debian.org>
 <20171114023711.GA22633@ziepe.ca>
 <20171114072056.GP18825@mtr-leonro.local>
 <1510656661.4026.23.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510656661.4026.23.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 11:51:01AM +0100, Benjamin Drung wrote:

> * Non-Linux architectures: One package is marked as architechture "any"
> instead of "linux-any". Thus the builds are tried on non-Linux archs.
> Expect a patch to come.

Yep

> * Architecture NOT able to do coherent DMA: Some providers will be
> disabled and the install target fail to install the missing providers.

I'm surprised, can you point me at a build log? I belive the cmake
side should work?

I suppose we have a bit of a Debian problem here as things like
mlx5dv will not compile on certain arches but their outputs are
directly refenced in the debian/*.install files.. Do you know how to
handle that?

> * valgrind is not available on some archs: Can we drop valgrind for
> those archs?

Yes. cmake will automatically disable valgrind annotations if it is
not installed. Altering the control file to only require valgrind on
supported arches is fine.

Jason


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
