From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH, RESEND] RDMA/srp: Accept again source addresses that do
 not have a port number
Date: Fri, 7 Jun 2019 13:53:37 -0300
Message-ID: <20190607165337.GB22304@ziepe.ca>
References: <20190529163831.138926-1-bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190529163831.138926-1-bvanassche@acm.org>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Laurence Oberman <loberman@redhat.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 29, 2019 at 09:38:31AM -0700, Bart Van Assche wrote:
> The function srp_parse_in() is used both for parsing source address
> specifications and for target address specifications. Target addresses
> must have a port number. Having to specify a port number for source
> addresses is inconvenient. Make sure that srp_parse_in() supports again
> parsing addresses with no port number.
> 
> Cc: Laurence Oberman <loberman@redhat.com>
> Cc: <stable@vger.kernel.org>
> Fixes: c62adb7def71 ("IB/srp: Fix IPv6 address parsing") # v4.17.
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)

Applied to for-next, thanks

Jason
