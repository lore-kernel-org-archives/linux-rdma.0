From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH mlx5-next] RDMA/mlx5: Don't use cached IRQ affinity mask
Date: Fri, 17 Aug 2018 14:17:01 -0600
Message-ID: <20180817201701.GJ28676@mellanox.com>
References: <f936d176-c56b-143e-3311-f6df48f633dd@mellanox.com>
 <20180723164910.GS31540@mellanox.com>
 <c079b7b4-bff8-8ffe-0be5-e470c86479b4@mellanox.com>
 <b0f6a58a-0078-05a2-a7f9-946b2ff21846@grimberg.me>
 <f1442839-ff32-ab80-9eab-6923456fe272@mellanox.com>
 <47178d4d-f730-6e59-5c19-58331cc3864a@opengridcomputing.com>
 <4a13541c-db48-beca-4ee7-932528b22986@grimberg.me>
 <85bba372-049c-2a12-362e-adcb0931cf49@opengridcomputing.com>
 <000001d43645$d0fdbc00$72f93400$@opengridcomputing.com>
 <ed1ea546-e7aa-3c17-710b-8c95fe90deea@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ed1ea546-e7aa-3c17-710b-8c95fe90deea@grimberg.me>
Sender: netdev-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Steve Wise <swise@opengridcomputing.com>, 'Max Gurtovoy' <maxg@mellanox.com>, 'Leon Romanovsky' <leon@kernel.org>, 'Doug Ledford' <dledford@redhat.com>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'Saeed Mahameed' <saeedm@mellanox.com>, 'linux-netdev' <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 17, 2018 at 01:03:20PM -0700, Sagi Grimberg wrote:
> 
> > Hey Sagi,
> > 
> > The patch works allowing connections for the various affinity mappings below:
> > 
> > One comp_vector per core across all cores, starting with numa-local cores:
> 
> Thanks Steve, is this your "Tested by:" tag?

The new patchworks doesn't grab patches inlined in messages, so you
will need to resend it.

Also, can someone remind me what the outcome is here? Does it
supersede Leon's patch:

https://patchwork.kernel.org/patch/10526167/

?

Thanks,
Jason
