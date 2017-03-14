From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [RFC v1 for accelerated IPoIB 05/25] IB/ipoib: Support ipoib
 acceleration options callbacks
Date: Tue, 14 Mar 2017 09:44:19 -0600
Message-ID: <20170314154419.GB3244@obsidianresearch.com>
References: <1489429896-10781-1-git-send-email-erezsh@mellanox.com>
 <1489429896-10781-6-git-send-email-erezsh@mellanox.com>
 <20170314063538.GB79937@knc-06.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170314063538.GB79937@knc-06.sc.intel.com>
Sender: netdev-owner@vger.kernel.org
To: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura@intel.com>
Cc: Erez Shitrit <erezsh@mellanox.com>, dledford@redhat.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, valex@mellanox.com, leonro@mellanox.com, saedm@mellanox.com, erezsh@dev.mellanox.co.il
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 13, 2017 at 11:35:38PM -0700, Vishwanathapura, Niranjana wrote:

> This will break ipoib on hfi1 as hfi1 will define alloc_rdma_netdev for
> OPA_VNIC type. We should probably look for a dedicated return type
> (-ENODEV?) to determine of the driver supports specified rdma netdev type.
> Or use a ib device attribute to suggest driver support ipoib rdma netdev.

I think I prefer call and detect ENOSUPP or whatever than yet another
flag.

Jason
