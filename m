From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v1 iproute2-next 3/4] rdma: add 'link add/delete' commands
Date: Thu, 21 Feb 2019 16:14:59 -0700
Message-ID: <20190221231459.GV17500@ziepe.ca>
References: <cover.1550773362.git.swise@opengridcomputing.com>
 <5dd9d9aeada48bc5db0eb0394ed4e3ce38ee41bc.1550773362.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5dd9d9aeada48bc5db0eb0394ed4e3ce38ee41bc.1550773362.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: dsahern@gmail.com, leon@kernel.org, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 21, 2019 at 08:19:12AM -0800, Steve Wise wrote:
> Add new 'link' subcommand 'add' and 'delete' to allow binding a soft-rdma
> device to a netdev interface.
> 
> EG:
> 
> rdma link add rxe_eth0 type rxe netdev eth0
> rdma link delete rxe_eth0

This is great that we finally got here!

Jason
