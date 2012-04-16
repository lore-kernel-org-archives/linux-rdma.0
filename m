From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH] IB: mlx4: Fix mem leaks in ib_link_query_port()
Date: Mon, 16 Apr 2012 11:20:03 +0300
Message-ID: <4F8BD633.5080207@mellanox.com>
References: <alpine.LNX.2.00.1204112340360.2137@swampdragon.chaosbits.net> <4F8A7A15.4060908@mellanox.com> <CAL1RGDXeny6ouGBD67OKYEa+m9cZ_x=NOaEGjPT6S62_BzWvuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAL1RGDXeny6ouGBD67OKYEa+m9cZ_x=NOaEGjPT6S62_BzWvuw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
List-Id: linux-rdma@vger.kernel.org

On 4/16/2012 8:05 AM, Roland Dreier wrote:
> thanks, applied (looks like a 3.4 regression so I'll send the fix to Linus with my next batch)

not sure to follow on the next branch part, it is a regression 
introduced in 3.4-rc1 so it should be in your fixes branch
and submitted within a batch possibly containing more fixes, isn't that?


Or.
