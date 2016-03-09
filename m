From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v4 7/9] IB/core: generic RDMA READ/WRITE API
Date: Wed, 9 Mar 2016 10:55:50 -0800
Message-ID: <56E071B6.8060809@sandisk.com>
References: <1457461000-24088-1-git-send-email-hch@lst.de>
 <1457461000-24088-8-git-send-email-hch@lst.de> <56DF44FC.8070103@sandisk.com>
 <20160309130723.GD31210@lst.de> <20160309155457.GA1898@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160309155457.GA1898@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "sagig@mellanox.com" <sagig@mellanox.com>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 03/09/2016 07:55 AM, Christoph Hellwig wrote:
> On Wed, Mar 09, 2016 at 02:07:23PM +0100, Christoph Hellwig wrote:
>> I think the multiple MR case here is simply broken, as we never hit
>> for the iSER or NVMe over Fabrics I/O sizes.  I think the safest
>> is to simply not allow for it.  I'll update the patch to disable the
>> loop, and add a helper for the driver to query the max I/O size
>> supported by the device.
>
> Turns out if was easily fixable by doing a loop of sg_next() calls
> until we reach the number of segments.  Verified by hacking the
> code to enable MRs for IB, and only accepting 4 pages per MR as arbitrarily
> low limit.

Hello Christoph,

Regarding the iSERt patches that are present in your rdma-rw-api branch: 
what is the impact of these patches on memory registration for the iSERt 
driver in combination with an IB HCA? Is memory registration still 
enabled for this combination? If not: how about changing this patch 
series such that memory registration is performed either if the 
transport protocol is iWARP or the ULP driver requests memory 
registration explicitly, e.g. by setting a flag in struct rdma_rw_ctx 
and/or struct ib_qp_init_attr?

Thanks,

Bart.
