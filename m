From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH v5 14/27] IB/Verbs: Reform cma_acquire_dev()
Date: Tue, 21 Apr 2015 10:08:56 +0200
Message-ID: <55360598.20700@profitbricks.com>
References: <5534B8C9.506@profitbricks.com> <5534BAFF.5030107@profitbricks.com> <EE7902D3F51F404C82415C4803930ACD5DC44164@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <EE7902D3F51F404C82415C4803930ACD5DC44164@CMEXMB1.ad.emulex.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Devesh Sharma <Devesh.Sharma@Emulex.Com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hal@dev.mellanox.co.il" <hal@dev.mellanox.co.il>
Cc: Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org



On 04/21/2015 08:15 AM, Devesh Sharma wrote:
> Looks good, I would like to test with ocrdma before confirming.

That's great :-) Any testing would be really helpful, please let
us know if there is some thing broken.

Regards,
Michael Wang

> 
>> -----Original Message-----
>> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
>> owner@vger.kernel.org] On Behalf Of Michael Wang
>> Sent: Monday, April 20, 2015 2:08 PM
>> To: Roland Dreier; Sean Hefty; linux-rdma@vger.kernel.org; linux-
>> kernel@vger.kernel.org; hal@dev.mellanox.co.il
>> Cc: Michael Wang; Tom Tucker; Steve Wise; Hoang-Nam Nguyen; Christoph
>> Raisch; Mike Marciniszyn; Eli Cohen; Faisal Latif; Jack Morgenstein; Or Gerlitz;
>> Haggai Eran; Ira Weiny; Tom Talpey; Jason Gunthorpe; Doug Ledford
>> Subject: [PATCH v5 14/27] IB/Verbs: Reform cma_acquire_dev()
>>
>>
>> Reform cma_acquire_dev() with management helpers, introduce
>> cma_validate_port() to make the code more clean.
>>
>> Cc: Hal Rosenstock <hal@dev.mellanox.co.il>
>> Cc: Steve Wise <swise@opengridcomputing.com>
>> Cc: Tom Talpey <tom@talpey.com>
>> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>> Cc: Doug Ledford <dledford@redhat.com>
>> Cc: Ira Weiny <ira.weiny@intel.com>
>> Cc: Sean Hefty <sean.hefty@intel.com>
>> Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
>> ---
>>  drivers/infiniband/core/cma.c | 68 +++++++++++++++++++++++++----------------
>> --
>>  1 file changed, 40 insertions(+), 28 deletions(-)
>>
>> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
>> index 6195bf6..44e7bb9 100644
>> --- a/drivers/infiniband/core/cma.c
>> +++ b/drivers/infiniband/core/cma.c
>> @@ -370,18 +370,35 @@ static int cma_translate_addr(struct sockaddr *addr,
>> struct rdma_dev_addr *dev_a
>>  	return ret;
>>  }
>>
>> +static inline int cma_validate_port(struct ib_device *device, u8 port,
>> +				      union ib_gid *gid, int dev_type) {
>> +	u8 found_port;
>> +	int ret = -ENODEV;
>> +
>> +	if ((dev_type == ARPHRD_INFINIBAND) && !rdma_tech_ib(device,
>> port))
>> +		return ret;
>> +
>> +	if ((dev_type != ARPHRD_INFINIBAND) && rdma_tech_ib(device, port))
>> +		return ret;
>> +
>> +	ret = ib_find_cached_gid(device, gid, &found_port, NULL);
>> +	if (port != found_port)
>> +		return -ENODEV;
>> +
>> +	return ret;
>> +}
>> +
>>  static int cma_acquire_dev(struct rdma_id_private *id_priv,
>>  			   struct rdma_id_private *listen_id_priv)  {
>>  	struct rdma_dev_addr *dev_addr = &id_priv->id.route.addr.dev_addr;
>>  	struct cma_device *cma_dev;
>> -	union ib_gid gid, iboe_gid;
>> +	union ib_gid gid, iboe_gid, *gidp;
>>  	int ret = -ENODEV;
>> -	u8 port, found_port;
>> -	enum rdma_link_layer dev_ll = dev_addr->dev_type ==
>> ARPHRD_INFINIBAND ?
>> -		IB_LINK_LAYER_INFINIBAND : IB_LINK_LAYER_ETHERNET;
>> +	u8 port;
>>
>> -	if (dev_ll != IB_LINK_LAYER_INFINIBAND &&
>> +	if (dev_addr->dev_type != ARPHRD_INFINIBAND &&
>>  	    id_priv->id.ps == RDMA_PS_IPOIB)
>>  		return -EINVAL;
>>
>> @@ -391,41 +408,36 @@ static int cma_acquire_dev(struct rdma_id_private
>> *id_priv,
>>
>>  	memcpy(&gid, dev_addr->src_dev_addr +
>>  	       rdma_addr_gid_offset(dev_addr), sizeof gid);
>> -	if (listen_id_priv &&
>> -	    rdma_port_get_link_layer(listen_id_priv->id.device,
>> -				     listen_id_priv->id.port_num) == dev_ll) {
>> +
>> +	if (listen_id_priv) {
>>  		cma_dev = listen_id_priv->cma_dev;
>>  		port = listen_id_priv->id.port_num;
>> -		if (rdma_node_get_transport(cma_dev->device->node_type)
>> == RDMA_TRANSPORT_IB &&
>> -		    rdma_port_get_link_layer(cma_dev->device, port) ==
>> IB_LINK_LAYER_ETHERNET)
>> -			ret = ib_find_cached_gid(cma_dev->device, &iboe_gid,
>> -						 &found_port, NULL);
>> -		else
>> -			ret = ib_find_cached_gid(cma_dev->device, &gid,
>> -						 &found_port, NULL);
>> +		gidp = rdma_tech_iboe(cma_dev->device, port) ?
>> +		       &iboe_gid : &gid;
>>
>> -		if (!ret && (port  == found_port)) {
>> -			id_priv->id.port_num = found_port;
>> +		ret = cma_validate_port(cma_dev->device, port, gidp,
>> +					dev_addr->dev_type);
>> +		if (!ret) {
>> +			id_priv->id.port_num = port;
>>  			goto out;
>>  		}
>>  	}
>> +
>>  	list_for_each_entry(cma_dev, &dev_list, list) {
>>  		for (port = 1; port <= cma_dev->device->phys_port_cnt; ++port)
>> {
>>  			if (listen_id_priv &&
>>  			    listen_id_priv->cma_dev == cma_dev &&
>>  			    listen_id_priv->id.port_num == port)
>>  				continue;
>> -			if (rdma_port_get_link_layer(cma_dev->device, port)
>> == dev_ll) {
>> -				if (rdma_node_get_transport(cma_dev-
>>> device->node_type) == RDMA_TRANSPORT_IB &&
>> -				    rdma_port_get_link_layer(cma_dev-
>>> device, port) == IB_LINK_LAYER_ETHERNET)
>> -					ret = ib_find_cached_gid(cma_dev-
>>> device, &iboe_gid, &found_port, NULL);
>> -				else
>> -					ret = ib_find_cached_gid(cma_dev-
>>> device, &gid, &found_port, NULL);
>> -
>> -				if (!ret && (port == found_port)) {
>> -					id_priv->id.port_num = found_port;
>> -					goto out;
>> -				}
>> +
>> +			gidp = rdma_tech_iboe(cma_dev->device, port) ?
>> +			       &iboe_gid : &gid;
>> +
>> +			ret = cma_validate_port(cma_dev->device, port, gidp,
>> +						dev_addr->dev_type);
>> +			if (!ret) {
>> +				id_priv->id.port_num = port;
>> +				goto out;
>>  			}
>>  		}
>>  	}
>> --
>> 2.1.0
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body
>> of a message to majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
