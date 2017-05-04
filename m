From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [infiniband-core] question about arguments position
Date: Thu, 04 May 2017 12:42:09 -0500
Message-ID: <20170504124209.Horde.B4I2tu9lZ9_KMd07dtjWcl2@gator4166.hostgator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sagi Grimberg <sagi@rimberg.me>, Bart Van Assche <bart.vanassche@sandisk.com>, Steve Wise <swise@opengridcomputing.com>, Leon Romanovsky <leonro@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Moni Shoua <monis@mellanox.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


Hello everybody,

While looking into Coverity ID 1351047 I ran into the following piece  
of code at drivers/infiniband/core/verbs.c:496:

ret = rdma_addr_find_l2_eth_by_grh(&dgid, &sgid,
                                    ah_attr->dmac,
                                    wc->wc_flags & IB_WC_WITH_VLAN ?
                                    NULL : &vlan_id,
                                    &if_index, &hoplimit);


The issue here is that the position of arguments in the call to  
rdma_addr_find_l2_eth_by_grh() function do not match the order of the  
parameters:

&dgid is passed to sgid
&sgid is passed to dgid

This is the function prototype:

int rdma_addr_find_l2_eth_by_grh(const union ib_gid *sgid,
				 const union ib_gid *dgid,
				 u8 *dmac, u16 *vlan_id, int *if_index,
				 int *hoplimit)

My question here is if this is intentional?

In case it is not, I will send a patch to fix it. But first it would  
be great to hear any comment about it.

Thank you
--
Gustavo A. R. Silva
