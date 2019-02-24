From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next v2 00/19] Export object IDs to users
Date: Sun, 24 Feb 2019 10:16:37 -0500
Message-ID: <c5995a79-e0d6-c88d-44d4-52d5477f2662@gmail.com>
References: <20190223091528.8509-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190223091528.8509-1-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

On 2/23/19 4:15 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Changelog:
> v1->v2:
>  * Fixed commit messages
>  * Added Steve's ROB
> v0->v1:
>  * Rebased to latest iproute2-next
>  * Added latest rdma_netlink.h and updated commit message to point
>    to kernel SHA commit.
> 
> This series adds ability to present and query all known to rdmatool
> object by their respective, unique IDs (e.g. pdn. mrn, cqn e.t.c).
> All objects which have "parent" object has this information too.
> 

applied to iproute2-next. Thanks, Leon.
