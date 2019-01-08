From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/srp: Use struct_size() in kzalloc()
Date: Tue, 8 Jan 2019 15:47:36 -0700
Message-ID: <20190108224736.GA4368@ziepe.ca>
References: <20190108160805.GA22698@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190108160805.GA22698@embeddedor>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 08, 2019 at 10:08:05AM -0600, Gustavo A. R. Silva wrote:
> One of the more common cases of allocation size calculations is finding the
> size of a structure that has a zero-sized array at the end, along with memory
> for some number of elements for that array. For example:
> 
> struct foo {
>     int stuff;
>     void *entry[];
> };
> 
> instance = kzalloc(sizeof(struct foo) + sizeof(void *) * count, GFP_KERNEL);
> 
> Instead of leaving these open-coded and prone to type mistakes, we can now
> use the new struct_size() helper:
> 
> instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL);
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Applied to for-next

Thanks,
Jason
