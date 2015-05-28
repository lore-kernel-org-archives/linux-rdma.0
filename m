From: Haggai Eran <haggaie@mellanox.com>
Subject: Re: [PATCH v4 for-next 00/12] Add network namespace support in the
 RDMA-CM
Date: Thu, 28 May 2015 16:15:21 +0300
Message-ID: <556714E9.4030203@mellanox.com>
References: <1431841868-28063-1-git-send-email-haggaie@mellanox.com>
 <1432647280.28905.107.camel@redhat.com>
 <20150526165928.GC11800@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20150526165928.GC11800@obsidianresearch.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org, Liran Liss <liranl@mellanox.com>, Guy Shapiro <guysh@mellanox.com>, Shachar Raindel <raindel@mellanox.com>, Yotam Kenneth <yotamke@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 26/05/2015 19:59, Jason Gunthorpe wrote:
> The big open question for ethernet is how to work without relying on
> VLAN to create delgated netdevs - typically one would use a bridge and
> veth's, which do not seem very RDMA compatible. But that doesn't need
> to be answered right now.

I think in Ethernet the first step would be to support macvlan devices.
Like IPoIB child devices, they are directly attached to an RDMA device,
so they don't require handling a complex virtual bridging topology as
veths do.
