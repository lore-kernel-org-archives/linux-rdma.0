From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-rc 1/2] IB/core: Only enforce security for InfiniBand
Date: Tue, 21 Nov 2017 11:57:44 -0700
Message-ID: <20171121185744.GF18272@ziepe.ca>
References: <20171121132215.GU18825@mtr-leonro.local>
 <9bb92ec4-d29f-55b7-d3ba-33bfe451ea6c@mellanox.com>
 <20171121151409.GA29826@mellanox.com>
 <3eff140b-8f0f-1c4f-07b7-9dec46090a1e@mellanox.com>
 <410e7b54-02f5-849c-e3ad-56cc61f66647@mellanox.com>
 <20171121160442.GB18272@ziepe.ca>
 <20171121163454.GW18825@mtr-leonro.local>
 <20171121163648.GC18272@ziepe.ca>
 <20171121164802.GY18825@mtr-leonro.local>
 <fa4b7d56-5617-2b9f-65dc-386ab69c4e8f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fa4b7d56-5617-2b9f-65dc-386ab69c4e8f@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Don Dutile <ddutile@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>, Daniel Jurgens <danielj@mellanox.com>, Mark Bloch <markb@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Paul Moore <paul@paul-moore.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 21, 2017 at 01:16:43PM -0500, Don Dutile wrote:

> >>I don't really think it is really too user visible.. Only the device
> >>and port number change, but only if running in mixed mode.
> >
> >Ahh, correct me if I'm wrong, you are proposing to split mlx4_ib devices
> >to two devices once it is configured in mixed mode, so everyone will
> >have one port only. Did I understand you correctly?

> Which would require splitting resources that are shared now? other
> splitting issue(s)?

A change like this would be almost transparent to most users. The cx3
card in mixed mode will look like a mlx5 card does: two single port
RDMA devices.

I think only a minimal amount of stuff is actually shared between
ports, and as cx5 already demonstrates there isn't really a notable
downside to having two kernel RDMA devices.

Jason
