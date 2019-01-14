From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] [V2] infiniband: fix a missing check of nla_put
Date: Mon, 14 Jan 2019 14:04:54 -0700
Message-ID: <20190114210454.GA13422@ziepe.ca>
References: <20190105161808.3496-1-pakki001@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190105161808.3496-1-pakki001@umn.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Aditya Pakki <pakki001@umn.edu>
Cc: kjlu@umn.edu, Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@mellanox.com>, Daniel Jurgens <danielj@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 05, 2019 at 10:18:07AM -0600, Aditya Pakki wrote:
> nla_put() may fail. The fix adds a check for its return value, and
> returns -EMSGSIZE if it fails, post canceling netlink msg.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>  drivers/infiniband/core/addr.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Leon?

Jason
