From: Erez Shitrit <erezsh@dev.mellanox.co.il>
Subject: Re: [RFC v1 for accelerated IPoIB 04/25] IB/verb: Add ipoib_options
 struct and API
Date: Tue, 14 Mar 2017 15:25:52 +0200
Message-ID: <CAAk-MO9fL3ir421AjtTnJHx45CP+dNpLaM=Gsbtpy_x2x4E1Ow@mail.gmail.com>
References: <1489429896-10781-1-git-send-email-erezsh@mellanox.com>
 <1489429896-10781-5-git-send-email-erezsh@mellanox.com> <20170313200136.GA2738@obsidianresearch.com>
 <20170314070109.GD79937@knc-06.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170314070109.GD79937@knc-06.sc.intel.com>
Sender: netdev-owner@vger.kernel.org
To: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura@intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Erez Shitrit <erezsh@mellanox.com>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, netdev@vger.kernel.org, valex@mellanox.com, Leon Romanovsky <leonro@mellanox.com>, saedm@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 14, 2017 at 9:01 AM, Vishwanathapura, Niranjana
<niranjana.vishwanathapura@intel.com> wrote:
> On Mon, Mar 13, 2017 at 02:01:36PM -0600, Jason Gunthorpe wrote:
>>>
>>> +       /* multicast */
>>> +       int (*attach_mcast)(struct net_device *dev, struct ib_device
>>> *hca,
>>> +                           union ib_gid *gid, u16 lid, int set_qkey);
>>> +       int (*detach_mcast)(struct net_device *dev, struct ib_device
>>> *hca,
>>> +                           union ib_gid *gid, u16 lid);
>>
>>
>> It would make more sense to store the struct ib_device pointer in the
>> struct rdma_netdev.
>>
>
> Agree that it shouldn't be a function parameters.
> For opa_vnic, I found it convenient to store ib_device pointer in client and
> device private structures as those will be available in most places anyhow.

Will add it to the rdma_netdev obj, as Jason suggested.
Thanks,

>
> Niranjana
