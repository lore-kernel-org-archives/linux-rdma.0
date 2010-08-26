From: Christoph Lameter <cl@linux.com>
Subject: Re: [IPoIB] Identify multicast packets and fix IGMP breakage V3
Date: Thu, 26 Aug 2010 18:57:09 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1008261856090.29657@router.home>
References: <adapqx5rtez.fsf@cisco.com> <alpine.DEB.2.00.1008261613160.24174@router.home> <alpine.DEB.2.00.1008261629440.24174@router.home> <20100826.151553.242147157.davem@davemloft.net> <20100826222146.GA23025@obsidianresearch.com>
 <alpine.DEB.2.00.1008261825490.26351@router.home> <20100826234342.GA24333@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20100826234342.GA24333@obsidianresearch.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: rdreier@cisco.com, linux-rdma@vger.kernel.org, ogerlitz@voltaire.com, yosefe@voltaire.com, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 26 Aug 2010, Jason Gunthorpe wrote:

> I think doing the memcmp only in the multicast path should be
> reasonable overhead wise.

Thats is not always possible. Here the multicast path is the
default path that is taken 99% of the time.

