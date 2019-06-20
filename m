From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH][next] RDMA: check for null return from call to
 ib_get_client_data
Date: Thu, 20 Jun 2019 12:02:17 -0300
Message-ID: <20190620150217.GA19891@ziepe.ca>
References: <20190620135052.27367-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190620135052.27367-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@mellanox.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 20, 2019 at 02:50:52PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The return from ib_get_client_data can potentially be null, so add a null
> check on umad_dev and return -ENODEV in this unlikely case to avoid any
> null pointer deferences.

It would be a kernel bug if NULL is seen here.

Jason
