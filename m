From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2 rdma: Ignore unknown netlink attributes
Date: Wed, 4 Apr 2018 16:43:26 -0700
Message-ID: <20180404164326.626c1c25@xeon-e3>
References: <20180403072842.32153-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180403072842.32153-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, David Ahern <dsahern@gmail.com>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

On Tue,  3 Apr 2018 10:28:42 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> From: Leon Romanovsky <leonro@mellanox.com>
> 
> The check if netlink attributes supplied more than maximum supported
> is to strict and may lead to backward compatibility issues with old
> application with a newer kernel that supports new attribute.
> 
> CC: Steve Wise <swise@opengridcomputing.com>
> Fixes: 74bd75c2b68d ("rdma: Add basic infrastructure for RDMA tool")
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Applied
