From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next] rdma: Add print of link CapabilityMask2
 flags
Date: Thu, 27 Dec 2018 18:42:56 -0500
Message-ID: <b24da4da-1bfa-a9ca-ae18-c9f4cb932c13@gmail.com>
References: <20181223112419.29157-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181223112419.29157-1-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Michael Guralnik <michaelgur@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 12/23/18 6:24 AM, Leon Romanovsky wrote:
> From: Michael Guralnik <michaelgur@mellanox.com>
> 
> CapabilityMask2 is defined in IBTA spec as a member of PortInfo.
> Add translation to string of new CapabilityMask2 expansion of link caps.
> 
> The flags are concatenated to current caps print as seen in this example
> printing EXT_INFO flag:
> 
> root@server-22 $ rdma -d link
> 1/1: mlx5_0/1: subnet_prefix fe80:0000:0000:0000 lid 2 sm_lid 2 lmc 0
> 	state ACTIVE physical_state LINK_UP
> caps: <SM, TRAP, SL_MAP, SYS_IMAGE_GUID, CABLE_INFO, EXTENDED_SPEEDS,
> 	CAP_MASK2, CM, DEVICE_MGMT, VENDOR_CLASS, CAP_MASK_NOTICE,
> 	CLIENT_REG, OTHER_LOCAL_CHANGES, MULT_PKER_TRAP, EXT_INFO>
> 
> Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  rdma/link.c | 36 +++++++++++++++++++++++++++++++-----
>  1 file changed, 31 insertions(+), 5 deletions(-)
> 

applied to iproute2-next. Thanks
