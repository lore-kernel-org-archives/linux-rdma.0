From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v1 iproute2-next 2/3] rdma: print driver resource
 attributes
Date: Tue, 15 May 2018 08:44:20 -0600
Message-ID: <20180515144420.GB5615@ziepe.ca>
References: <cover.1525709213.git.swise@opengridcomputing.com>
 <1a0d146dffb17449aa6d8a6b6d06e865e69226de.1525709213.git.swise@opengridcomputing.com>
 <20180514204125.GM21531@ziepe.ca>
 <a8493ed9-f16c-eb71-55db-f27bd1331521@opengridcomputing.com>
 <20180515085411.GT10381@mtr-leonro.mtl.com>
 <00fe01d3ec4f$44a6f400$cdf4dc00$@opengridcomputing.com>
 <20180515135335.GA5615@ziepe.ca>
 <012201d3ec59$69242fa0$3b6c8ee0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <012201d3ec59$69242fa0$3b6c8ee0$@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: 'Leon Romanovsky' <leon@kernel.org>, dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 15, 2018 at 09:31:27AM -0500, Steve Wise wrote:
> > cap net admin is not high enough privledge to see unhashed kernel
> > pointers. CAP_RAW_IO? Or follow what printk does?
> > 
> 
> Do you mean CAP_NET_RAW?  Here's the comments for it:

Nope..

> Func restricted_pointer() from lib/vsprintf.c uses CAP_SYSLOG.  The comment for CAP_SYSLOG:

Yikes, yes, that is probably the required logic here, including the
kptr_restrict = 0 thing

Jason
