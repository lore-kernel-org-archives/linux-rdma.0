From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next v4 06/17] RDMA/counter: Add "auto" configuration
 mode support
Date: Sun, 30 Jun 2019 00:40:54 +0000
Message-ID: <20190630004048.GB7173@mellanox.com>
References: <20190618172625.13432-1-leon@kernel.org>
 <20190618172625.13432-7-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190618172625.13432-7-leon@kernel.org>
Content-Language: en-US
Content-ID: <A3580C98FF1F4F49ABD1124336F20483@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Mark Zhang <markz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 18, 2019 at 08:26:14PM +0300, Leon Romanovsky wrote:

> +static void __rdma_counter_dealloc(struct rdma_counter *counter)
> +{
> +	mutex_lock(&counter->lock);
> +	counter->device->ops.counter_dealloc(counter);
> +	mutex_unlock(&counter->lock);
> +}

Does this lock do anything? The kref is 0 at this point, so no other
thread can have a pointer to this lock.

> +
> +static void rdma_counter_dealloc(struct rdma_counter *counter)
> +{
> +	if (!counter)
> +		return;

Counter is never NULL.

Jason
