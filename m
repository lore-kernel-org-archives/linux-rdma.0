From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next v1 00/19] Export object IDs to users
Date: Thu, 21 Feb 2019 10:26:44 -0500
Message-ID: <b2a33de0-eb68-fdc8-934f-d75c3ebb1927@gmail.com>
References: <20190220072136.3840-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190220072136.3840-1-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

On 2/20/19 2:21 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Changelog:
> v0->v1:
>  * Rebased to latest iproute2-next
>  * Added latest rdma_netlink.h and updated commit message to point
>    to kernel SHA commit.
> 
> This series adds ability to present and query all known to rdmatool
> object by their respective, unique IDs (e.g. pdn. mrn, cqn e.t.c).
> All objects which have "parent" object has this information too.
> 
> Thanks
> 

I would prefer someone from the rdma world review this as well. Thanks
