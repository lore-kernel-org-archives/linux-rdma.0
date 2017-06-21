From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH rdma-next 03/19] RDMA/netlink: Rename and remove redundant parameter from ibnl_unicast
Date: Wed, 21 Jun 2017 09:01:54 -0500
Message-ID: <021a01d2ea96$f05ebbe0$d11c33a0$@opengridcomputing.com>
References: <20170621060528.3752-1-leon@kernel.org> <20170621060528.3752-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170621060528.3752-4-leon@kernel.org>
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
To: 'Leon Romanovsky' <leon@kernel.org>, 'Doug Ledford' <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, 'Chien Tin Tung' <chien.tin.tung@intel.com>, 'Stephen Hemminger' <stephen@networkplumber.org>, 'Jiri Pirko' <jiri@mellanox.com>, 'Ariel Almog' <ariela@mellanox.com>, 'Linux Netdev' <netdev@vger.kernel.org>, 'Leon Romanovsky' <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Netlink message header is not needed for unicast reply, hence remove it.
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Looks good.

Reviewed-by: Steve Wise <swise@opengridcomputing.com>
