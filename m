From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/usnic: Use struct_size() in kmalloc()
Date: Mon, 7 Jan 2019 11:48:58 -0700
Message-ID: <20190107184858.GB18875@ziepe.ca>
References: <20190107173953.GA6154@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190107173953.GA6154@embeddedor>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Christian Benvenuti <benve@cisco.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 07, 2019 at 11:39:54AM -0600, Gustavo A. R. Silva wrote:
> One of the more common cases of allocation size calculations is finding
> the size of a structure that has a zero-sized array at the end, along
> with memory for some number of elements for that array. For example:
> 
> struct foo {
>     int stuff;
>     void *entry[];
> };
> 
> instance = kmalloc(sizeof(struct foo) + sizeof(void *) * count, GFP_KERNEL);
> 
> Instead of leaving these open-coded and prone to type mistakes, we can
> now use the new struct_size() helper:
> 
> instance = kmalloc(struct_size(instance, entry, count), GFP_KERNEL);
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/infiniband/hw/usnic/usnic_uiom.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Applied to for-next, thanks

Jason
