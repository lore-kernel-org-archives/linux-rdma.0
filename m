From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/2] Flow steering handling
Date: Thu, 9 Nov 2017 15:30:14 +0200
Message-ID: <3c61b229-3bad-11df-92dd-bccb9a1d8994@dev.mellanox.co.il>
References: <1510157897-10384-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510157897-10384-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/8/2017 6:18 PM, Yishai Hadas wrote:
> This series aligns in the user space area the flow steering uverbs commands
> with other objects (e.g. QP, CQ) such that the commands don't allocate and free
> the ib_flow but are just responsible to issue the command.
> 
> The second patch in the series in mlx4 handles the cleanup on fatal scenario as
> already done for other destroy commands on top of the above change.
> 
> PR was sent:
> https://github.com/linux-rdma/rdma-core/pull/244
> 
> Yishai Hadas (2):
>    Align flow steering commands with other objects
>    mlx4: Cleanup upon fatal in the destroy flow
> 
>   libibverbs/cmd.c       | 15 +++++----------
>   libibverbs/driver.h    |  3 ++-
>   providers/mlx4/mlx4.c  |  4 ++--
>   providers/mlx4/mlx4.h  |  2 ++
>   providers/mlx4/verbs.c | 30 ++++++++++++++++++++++++++++++
>   providers/mlx5/mlx5.c  |  4 ++--
>   providers/mlx5/mlx5.h  |  2 ++
>   providers/mlx5/verbs.c | 29 +++++++++++++++++++++++++++++
>   8 files changed, 74 insertions(+), 15 deletions(-)
> 

Merged, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
