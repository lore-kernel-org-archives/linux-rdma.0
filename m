From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v4 iproute2-next 0/7] cm_id, cq, mr, and pd resource
 tracking
Date: Sun, 1 Apr 2018 09:22:14 -0600
Message-ID: <8cdcb764-da42-e540-90e6-309eda0eb599@gmail.com>
References: <cover.1522359537.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1522359537.git.swise@opengridcomputing.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: leon@kernel.org, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 3/29/18 3:38 PM, Steve Wise wrote:
> This series enhances the iproute2 rdma tool to include dumping of
> connection manager id (cm_id), completion queue (cq), memory region (mr),
> and protection domain (pd) rdma resources.  It is the user-space part of
> the kernel resource tracking series merged into rdma-next for 4.17 [1]
> and [2].
> 
> Changes since v3:
> - replaced rdma_cma.h inclusion with UAPI rdma_user_cm.h
> - display only device names instead of device/port for cq, mr, and pd
> since they are not associated with a specific port.
> 
> Changes since v2:
> - pull in rdma-core:include/rdma/rdma_cma.h
> - 80 column reformat
> - add reviewed-by tags
> 
> Changes since v1/RFC:
> - removed RFC tag
> - initialize rd properly to avoid passing a garbage port number
> - revert accidental change to qp_valid_filters 
> - removed cm_id dev/network/transport types
> - cm_id ip addrs now passed up as __kernel_sockaddr_storage
> - cm_id ip address ports printed as "address:port" strings
> - only parse/display memory keys and iova if available
> - filter on "users" for cqs and pds
> - fixed memory leaks 
> - removed PD_FLAGS attribute
> - filter on "mrlen" for mrs
> - filter on "poll-ctx" for cqs
> - don't require addrs or qp_type for parsing cm_ids
> - only filter optional attrs if they are present
> - remove PGSIZE MR attr to match kernel 
> 
> [1] https://www.spinics.net/lists/linux-rdma/msg61720.html
> [2] https://www.spinics.net/lists/linux-rdma/msg62979.html
>     https://www.spinics.net/lists/linux-rdma/msg62980.html
> 
> ---
> 

applied to iproute2-next. Thanks,
