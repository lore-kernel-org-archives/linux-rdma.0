From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-rc 1/2] IB/core: Only enforce security for InfiniBand
Date: Tue, 21 Nov 2017 08:36:47 -0700
Message-ID: <20171121153647.GC29826@mellanox.com>
References: <20171121102618.31216-1-leon@kernel.org>
 <20171121102618.31216-2-leon@kernel.org>
 <4f5268b5-e5b6-a7d9-2096-70b4ae8facaf@mellanox.com>
 <20171121132215.GU18825@mtr-leonro.local>
 <9bb92ec4-d29f-55b7-d3ba-33bfe451ea6c@mellanox.com>
 <20171121151409.GA29826@mellanox.com>
 <3eff140b-8f0f-1c4f-07b7-9dec46090a1e@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3eff140b-8f0f-1c4f-07b7-9dec46090a1e@mellanox.com>
Sender: stable-owner@vger.kernel.org
To: Mark Bloch <markb@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Daniel Jurgens <danielj@mellanox.com>, Paul Moore <paul@paul-moore.com>, Don Dutile <ddutile@redhat.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 21, 2017 at 05:33:04PM +0200, Mark Bloch wrote:

> You say never be allowed, I say code talks, and in the code we don't
> have this restriction.  maybe we should add something?

I say that because I will NAK any attempt to merge such a driver.

I'd welcome patches to encforce this restriction in the core.

> Maybe we should make sure all the ports are IB, and if not, flag it
> to the user (dmesg?)

I would welcome this patch too.

Will this break any mellanox drivers?

Jason
