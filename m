From: Qing Huang <qing.huang@oracle.com>
Subject: Re: [PATCH] net/mlx5: report persistent netdev stats across
 ifdown/ifup commands
Date: Thu, 26 Apr 2018 17:21:36 -0700
Message-ID: <68e80592-6455-5b97-d44d-5609aca01f82@oracle.com>
References: <1524775057-8012-1-git-send-email-qing.huang@oracle.com>
 <CALzJLG8=dnyLGRXamLR5-eYJ9Q8WCwKe44sHHZ57=1h_x0RCRA@mail.gmail.com>
 <5cd29779-fc70-930a-7060-ee3332c15558@oracle.com>
 <CALzJLG8atGxoJNQj4F6wR3kRg7jrj4oQi3O-1i0=UOo+3HPq0w@mail.gmail.com>
 <CALzJLG_ROqv1Kby1FbGXFSgB5My4Gj=3cubw=DEts_9_3V3=3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALzJLG_ROqv1Kby1FbGXFSgB5My4Gj=3cubw=DEts_9_3V3=3A@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@dev.mellanox.co.il>
Cc: Eran Ben Elisha <eranbe@mellanox.com>, linux-kernel <linux-kernel@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Linux Netdev List <netdev@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>, Matan Barak <matanb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Thanks! Looks like Eran's patch will be available much sooner than v4.18 
release time frame (since v4.16 was just released).

We will wait. :-)


On 04/26/2018 04:43 PM, Saeed Mahameed wrote:
> Before you address my comments, it looks like Eran's work is
> converging and we will finalize the internal
> review next week, in which case submission will take 2-3 weeks from today.
>
> So i suggest to wait.
>
> please checkout:
> https://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git/commit/?h=testing/mlx5e-stats&id=15ffb7f87432d073e8ac0e6b895188d40fdda4d4
