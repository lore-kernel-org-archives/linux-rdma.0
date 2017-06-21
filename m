From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH rdma-next 08/19] RDMA/core: Expose translation from
 device name to ib_device
Date: Wed, 21 Jun 2017 10:07:48 -0600
Message-ID: <20170621160748.GA10200@obsidianresearch.com>
References: <20170621060528.3752-1-leon@kernel.org>
 <20170621060528.3752-9-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170621060528.3752-9-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Chien Tin Tung <chien.tin.tung@intel.com>, Steve Wise <swise@opengridcomputing.com>, Stephen Hemminger <stephen@networkplumber.org>, Jiri Pirko <jiri@mellanox.com>, Ariel Almog <ariela@mellanox.com>, Linux Netdev <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 21, 2017 at 09:05:17AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Provide ability to convert from device name to ib_device for the
> IB/core users.

FWIW, as a general comment, we really need to start using some kind of
device index like netdev does instead of the name. I'd like the see
the new netlink interface be index based.

As we saw in a past discussion there is a desire to have stable device
naming, which means renaming...

Jason
