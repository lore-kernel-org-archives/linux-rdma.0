From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v4 7/9] IB/core: generic RDMA READ/WRITE API
Date: Thu, 10 Mar 2016 07:30:36 -0800
Message-ID: <56E1931C.1040206@sandisk.com>
References: <1457461000-24088-1-git-send-email-hch@lst.de>
 <1457461000-24088-8-git-send-email-hch@lst.de> <56DF44FC.8070103@sandisk.com>
 <20160309130723.GD31210@lst.de> <20160309155457.GA1898@lst.de>
 <56E071B6.8060809@sandisk.com> <20160310075722.GA551@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160310075722.GA551@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "sagig@mellanox.com" <sagig@mellanox.com>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 03/09/16 23:57, Christoph Hellwig wrote:
> On Wed, Mar 09, 2016 at 10:55:50AM -0800, Bart Van Assche wrote:
>> Regarding the iSERt patches that are present in your rdma-rw-api branch:
>
> I haven't submitted those yet, as the signature MR support hasn't been
> tested and is most likely broken.  (and even if it's not broken it's too
> ugly to live :))
>
>> what is the impact of these patches on memory registration for the iSERt
>> driver in combination with an IB HCA? Is memory registration still enabled
>> for this combination? If not: how about changing this patch series such
>> that memory registration is performed either if the transport protocol is
>> iWARP or the ULP driver requests memory registration explicitly, e.g. by
>> setting a flag in struct rdma_rw_ctx and/or struct ib_qp_init_attr?
>
> I don't want the ULP to ask for memory registrations, and it's not really
> the ULPs business.  It should be done either if needed (iWarp, signature
> MRs), or if the HCA driver prefers it for a larger enough transfers.
>
> Once the basic API is in I'd like to add an interface for the HCA driver,
> as Mellanox has indicated they'd like to register for larger transfers.
>
> Any chance to get a review of the remaining patches so we can get it
> in for this merge window?

Hello Christoph,

I will continue with reviewing these patches. But I disagree that ULPs 
should not have control over whether or not memory registration is 
enabled. My experience is that it is essential to always enable memory 
registration while debugging an RDMA driver. Without memory registration 
it can be extremely hard to determine whether memory corruption is 
caused by code that is running locally or by a misplaced RDMA write from 
another host. With memory registration enabled misplaced writes result 
in an access violation error. Additionally, certain users prefer to 
enable memory registration for all RDMA transfers because of the 
additional safety it provides.

Bart.
