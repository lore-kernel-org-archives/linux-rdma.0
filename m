From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-rc 1/2] IB/core: Only enforce security for InfiniBand
Date: Tue, 21 Nov 2017 10:10:00 -0700
Message-ID: <20171121171000.GD18272@ziepe.ca>
References: <4f5268b5-e5b6-a7d9-2096-70b4ae8facaf@mellanox.com>
 <20171121132215.GU18825@mtr-leonro.local>
 <9bb92ec4-d29f-55b7-d3ba-33bfe451ea6c@mellanox.com>
 <20171121151409.GA29826@mellanox.com>
 <3eff140b-8f0f-1c4f-07b7-9dec46090a1e@mellanox.com>
 <410e7b54-02f5-849c-e3ad-56cc61f66647@mellanox.com>
 <20171121160442.GB18272@ziepe.ca>
 <20171121163454.GW18825@mtr-leonro.local>
 <20171121163648.GC18272@ziepe.ca>
 <20171121164802.GY18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171121164802.GY18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 21, 2017 at 06:48:02PM +0200, Leon Romanovsky wrote:
> On Tue, Nov 21, 2017 at 09:36:48AM -0700, Jason Gunthorpe wrote:

> Ahh, correct me if I'm wrong, you are proposing to split mlx4_ib devices
> to two devices once it is configured in mixed mode, so everyone will
> have one port only. Did I understand you correctly?

Right, but only for mixed mode. dual port roce or dual port ib is not
altered.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
