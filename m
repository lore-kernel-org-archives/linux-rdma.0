From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/usnic: Delete an error message for a failed memory
 allocation in usnic_transport_init()
Date: Wed, 28 Feb 2018 14:13:47 -0700
Message-ID: <20180228211347.GA13394@ziepe.ca>
References: <d9b22086-13d0-b519-3126-937a531d93d2@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d9b22086-13d0-b519-3126-937a531d93d2@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma@vger.kernel.org, Christian Benvenuti <benve@cisco.com>, Dave Goodell <dgoodell@cisco.com>, Doug Ledford <dledford@redhat.com>, Roland Dreier <roland@purestorage.com>, Upinder Malhi <umalhi@cisco.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 27, 2018 at 08:15:17PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 27 Jan 2018 20:06:59 +0100
> 
> Omit an extra message for a memory allocation failure in this function.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
>  drivers/infiniband/hw/usnic/usnic_transport.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Applied to for-next

Jason
