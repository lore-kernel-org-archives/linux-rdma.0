From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: Re: [infiniband-core] question about arguments position
Date: Thu, 04 May 2017 20:38:20 -0500
Message-ID: <20170504203820.Horde.-XF5wCocLZWytz_Ml2dGEBZ@gator4166.hostgator.com>
References: <20170504124209.Horde.B4I2tu9lZ9_KMd07dtjWcl2@gator4166.hostgator.com>
 <DB6PR0502MB2999ABEFF47AEBF944F8B65BD1EA0@DB6PR0502MB2999.eurprd05.prod.outlook.com>
 <1493941746.3041.242.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1493941746.3041.242.camel@redhat.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Parav Pandit <parav@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sagi Grimberg <sagi@grimberg.me>, Bart Van Assche <bart.vanassche@sandisk.com>, Steve Wise <swise@opengridcomputing.com>, Leon Romanovsky <leonro@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Moni Shoua <monis@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Parav and Doug,

Quoting Doug Ledford <dledford@redhat.com>:

> On Thu, 2017-05-04 at 21:52 +0000, Parav Pandit wrote:
>> Hi,
>>
>> >
>> > -----Original Message-----
>> > From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
>> > owner@vger.kernel.org] On Behalf Of Gustavo A. R. Silva
>> > Sent: Thursday, May 4, 2017 12:42 PM
>> > To: Doug Ledford <dledford@redhat.com>; Sean Hefty
>> > <sean.hefty@intel.com>; Hal Rosenstock <hal.rosenstock@gmail.com>;
>> > Sagi
>> > Grimberg <sagi@rimberg.me>; Bart Van Assche
>> > <bart.vanassche@sandisk.com>; Steve Wise <swise@opengridcomputing.c
>> > om>;
>> > Leon Romanovsky <leonro@mellanox.com>; Yishai Hadas
>> > <yishaih@mellanox.com>; Moni Shoua <monis@mellanox.com>
>> > Cc: linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org
>> > Subject: [infiniband-core] question about arguments position
>> >
>> >
>> > Hello everybody,
>> >
>> > While looking into Coverity ID 1351047 I ran into the following
>> > piece of code at
>> > drivers/infiniband/core/verbs.c:496:
>> >
>> > ret = rdma_addr_find_l2_eth_by_grh(&dgid, &sgid,
>> >                                     ah_attr->dmac,
>> >                                     wc->wc_flags & IB_WC_WITH_VLAN
>> > ?
>> >                                     NULL : &vlan_id,
>> >                                     &if_index, &hoplimit);
>> >
>> >
>> > The issue here is that the position of arguments in the call to
>> > rdma_addr_find_l2_eth_by_grh() function do not match the order of
>> > the
>> > parameters:
>> >
>> > &dgid is passed to sgid
>> > &sgid is passed to dgid
>> >
>> > This is the function prototype:
>> >
>> > int rdma_addr_find_l2_eth_by_grh(const union ib_gid *sgid,
>> > 				 const union ib_gid *dgid,
>> > 				 u8 *dmac, u16 *vlan_id, int *if_index,
>> > 				 int *hoplimit)
>> >
>> > My question here is if this is intentional?
>> >
>> Yes. ib_init_ah_from_wc() creates ah from the incoming packet.
>> Incoming packet has dgid of the receiver node on which this code is
>> getting executed
>> And sgid contains the GID of the sender.
>>
>> When resolving mac address of destination, you use arrived dgid as
>> sgid.
>> And use sgid as dgid because sgid contains destinations GID whom to
>> respond to.
>
> A patch to add a comment and forestall future questions here might be a
> good addition.
>

In the case of Coverity, I already triaged and documented this issue.  
So people can ignore it in the future.

Regarding the code comments, what about the following patch based on  
Parav's comments:

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 85ed505..38864ea 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -450,6 +450,19 @@ int ib_get_gids_from_rdma_hdr(const union  
rdma_network_hdr *hdr,
  }
  EXPORT_SYMBOL(ib_get_gids_from_rdma_hdr);

+/*
+ * This function creates ah from the incoming packet.
+ * Incoming packet has dgid of the receiver node on which this code is
+ * getting executed and, sgid contains the GID of the sender.
+ *
+ * When resolving mac address of destination, the arrived dgid is used
+ * as sgid and, sgid is used as dgid because sgid contains destinations
+ * GID whom to respond to.
+ *
+ * This is why when calling rdma_addr_find_l2_eth_by_grh() function, the
+ * position of arguments dgid and sgid do not match the order of the
+ * parameters.
+ */
  int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
                        const struct ib_wc *wc, const struct ib_grh *grh,
                        struct ib_ah_attr *ah_attr)

Thanks for clarifying
--
Gustavo A. R. Silva
