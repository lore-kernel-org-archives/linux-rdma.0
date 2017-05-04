From: Ursula Braun <ubraun@linux.vnet.ibm.com>
Subject: Re: net/smc and the RDMA core
Date: Thu, 4 May 2017 15:08:39 +0200
Message-ID: <efa9bd6d-1df9-952a-7f32-c2ee6bffcae5@linux.vnet.ibm.com>
References: <20170501163311.GA22209@lst.de>
 <d9214af6-1c6f-9f95-fc00-3e4a316b4f81@linux.vnet.ibm.com>
 <1493750358.2552.13.camel@sandisk.com>
 <1b79048f-4495-3840-e7a6-d4fa5a8dfb57@grimberg.me>
 <20170504084825.GA5399@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170504084825.GA5399@lst.de>
Sender: netdev-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "davem@davemloft.net" <davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



On 05/04/2017 10:48 AM, hch@lst.de wrote:
> On Thu, May 04, 2017 at 11:43:50AM +0300, Sagi Grimberg wrote:
>> I would also suggest that you stop exposing the DMA MR for remote
>> access (at least by default) and use a proper reg_mr operations with a
>> limited lifetime on a properly sized buffer.
> 
> Yes, exposing the default DMA MR is a _major_ security risk.  As soon
> as SMC is enabled this will mean a remote system has full read/write
> access to the local systems memory.
> 
> There іs a reason why I removed the ib_get_dma_mr function and replaced
> it with the IB_PD_UNSAFE_GLOBAL_RKEY key that has _UNSAFE_ in the name
> and a very long comment explaining why, and I'm really disappointed that
> we got a driver merged that instead of asking on the relevant list on
> why a change unexpertong a function it needed happened and instead
> tried the hard way to keep a security vulnerarbility alive.
> 
Thanks for pointing out these problems. We will address them.
