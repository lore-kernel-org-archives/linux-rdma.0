From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [for-next V2 09/10] RDMA/nldev: Added configuration of RDMA
 dynamic interrupt moderation to netlink
Date: Tue, 25 Jun 2019 14:15:38 -0700
Message-ID: <f621af3b-37a3-eb97-368a-3201fa49f338@grimberg.me>
References: <20190625205701.17849-1-saeedm@mellanox.com>
 <20190625205701.17849-10-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190625205701.17849-10-saeedm@mellanox.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Tal Gilboa <talgi@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yamin Friedman <yaminf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org



On 6/25/19 1:57 PM, Saeed Mahameed wrote:
> From: Yamin Friedman <yaminf@mellanox.com>
> 
> Added parameter in ib_device for enabling dynamic interrupt moderation so
> that it can be configured in userspace using rdma tool.
> 
> In order to set dim for an ib device the command is:
> rdma dev set [DEV] dim [on|off]
> Please set on/off.

Is "dim" what you want to expose to the user? maybe
"adaptive-moderation" is more friendly?
