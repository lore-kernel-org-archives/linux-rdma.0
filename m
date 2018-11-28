From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH RFC iproute2-next 1/2] rdma: add 'link add/delete'
 commands
Date: Wed, 28 Nov 2018 15:25:58 -0700
Message-ID: <20181128222558.GI19914@ziepe.ca>
References: <cover.1543422310.git.swise@opengridcomputing.com>
 <7026be07534b14fd74e592c315523c57fde05a0a.1543422310.git.swise@opengridcomputing.com>
 <20181128182645.GJ4559@mtr-leonro.mtl.com>
 <fcc5af3c-4440-93ac-e6b4-212f5d1fbfe0@opengridcomputing.com>
 <20181128200412.GP4559@mtr-leonro.mtl.com>
 <ddbbc8b5-3a32-4eea-cc02-b3211d3d47bb@opengridcomputing.com>
 <20181128201303.GR4559@mtr-leonro.mtl.com>
 <d2aaeece-6491-b5f2-d1af-e6c327590cab@opengridcomputing.com>
 <20181128221711.GH19914@ziepe.ca>
 <870b87fa-0485-5aee-239a-0312b34a4361@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <870b87fa-0485-5aee-239a-0312b34a4361@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: Leon Romanovsky <leon@kernel.org>, dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, BMT@zurich.ibm.com
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 28, 2018 at 04:21:48PM -0600, Steve Wise wrote:

> >> It does make sense to not require type.  The name must be unique so that
> >> should be enough.  I'll have to respin the kernel side though...
> > The delete_link really should be an operation on the ib_device, not
> > the link_ops thing. 
> >
> > That directly prevents mis-matching function callbacks..
> >
> > Jason
> Looking at the rtnetlink newlink/dellink, I see they cache the link_ops
> ptr in the net_device struct.  So when the link is deleted, then
> appropriate driver-specific dellink function can be called after finding
> the device to be deleted.  Should I do something along these lines?  IE
> add a struct rdma_link_ops pointer to struct ib_device.

I don't see a problem with that either..

Jason
