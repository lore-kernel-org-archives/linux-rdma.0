From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH mlx5-next] RDMA/mlx5: Don't use cached IRQ affinity mask
Date: Fri, 17 Aug 2018 13:26:41 -0700
Message-ID: <ee2d312e-991f-6a63-4152-ed8ecfab1c05@grimberg.me>
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
 <20180817201701.GJ28676@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180817201701.GJ28676@mellanox.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Steve Wise <swise@opengridcomputing.com>, 'Max Gurtovoy' <maxg@mellanox.com>, 'Leon Romanovsky' <leon@kernel.org>, 'Doug Ledford' <dledford@redhat.com>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'Saeed Mahameed' <saeedm@mellanox.com>, 'linux-netdev' <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

> The new patchworks doesn't grab patches inlined in messages, so you
> will need to resend it.

Yes, just wanted to to add Steve's tested by as its going to
lists that did not follow this thread.

> Also, can someone remind me what the outcome is here? Does it
> supersede Leon's patch:
> 
> https://patchwork.kernel.org/patch/10526167/

Leon's patch is exposing the breakage so I think it would be
wise to have it go in after this lands mainline.
