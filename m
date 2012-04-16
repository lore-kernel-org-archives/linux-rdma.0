From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH] IB: mlx4: Fix mem leaks in ib_link_query_port()
Date: Sun, 15 Apr 2012 22:05:55 -0700
Message-ID: <CAL1RGDXeny6ouGBD67OKYEa+m9cZ_x=NOaEGjPT6S62_BzWvuw@mail.gmail.com>
References: <alpine.LNX.2.00.1204112340360.2137@swampdragon.chaosbits.net> <4F8A7A15.4060908@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F8A7A15.4060908@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
List-Id: linux-rdma@vger.kernel.org

thanks, applied (looks like a 3.4 regression so I'll send the fix to
Linus with my next batch)
