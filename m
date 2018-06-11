From: jackm <jackm@dev.mellanox.co.il>
Subject: Re: [PATCH 2/2] IB/mad: Use IDR for agent IDs
Date: Mon, 11 Jun 2018 09:19:14 +0300
Message-ID: <20180611091914.00007858@dev.mellanox.co.il>
References: <20180608174218.32455-1-willy@infradead.org>
        <20180608174218.32455-3-willy@infradead.org>
        <20180610063028.GH12407@mtr-leonro.mtl.com>
        <20180610104305.GA9284@bombadil.infradead.org>
        <20180610122505.GM12407@mtr-leonro.mtl.com>
        <20180610203027.GF5560@mellanox.com>
        <20180611043425.GA21382@mtr-leonro.mtl.com>
        <20180611044203.GA32562@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180611044203.GA32562@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>, Matthew Wilcox <willy@infradead.org>, hans.westgaard.ry@oracle.com, Doug Ledford <dledford@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, =?ISO-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 10 Jun 2018 22:42:03 -0600
Jason Gunthorpe <jgg@mellanox.com> wrote:

> Er, the spec has nothing to do with this. In Linux the TID is made
> unique because the core code provides 32 bits that are unique and the
> user provides another 32 bits that are unique. The driver cannot
> change any of those bits without risking non-uniquenes, which is
> exactly the bug mlx4 created when it stepped outside its bounds and
> improperly overrode bits in the TID for its own internal use.

Actually, the opposite is true here.
When SRIOV is active, each VM generates its *own* TIDs -- with 32 bits
of agent number and 32 bits of counter.

There is a  chance that two different VMs can generate the same TID!
Encoding the slave (VM) number in the packet actually guarantees
uniqueness here.
There is nothing wrong with modifying the TID in a reversible way in
order to:
a. guarantee uniqueness
b. identify the VM which should receive the response packet

The problem was created when the agent-id numbers started to use the
most-significant byte (thus making the MSB slave-id addition
impossible).
