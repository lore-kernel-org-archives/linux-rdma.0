From: zhuyj <zyjzyj2000@gmail.com>
Subject: Re: [PATCH 1/1] net: rds: use memset to optimize the recv
Date: Mon, 17 Sep 2018 08:54:15 +0800
Message-ID: <CAD=hENe2+zSKdtE1BC3xx5gPb1CTWjVwTapev6n9Jm+uLFqUXg@mail.gmail.com>
References: <20180914084538.11666-1-yanjun.zhu@oracle.com> <20180916.153637.2289306962750648161.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180916.153637.2289306962750648161.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>
Cc: yanjun.zhu@oracle.com, santosh.shilimkar@oracle.com, netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

 OK. I will send V2 for net-next very soon.

Zhu Yanjun

On Mon, Sep 17, 2018 at 6:38 AM David Miller <davem@davemloft.net> wrote:
>
> From: Zhu Yanjun <yanjun.zhu@oracle.com>
> Date: Fri, 14 Sep 2018 04:45:38 -0400
>
> > The function rds_inc_init is in recv process. To use memset can optimize
> > the function rds_inc_init.
> > The test result:
> >
> >     Before:
> >     1) + 24.950 us   |        rds_inc_init [rds]();
> >     After:
> >     1) + 10.990 us   |        rds_inc_init [rds]();
> >
> > Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
>
> This doesn't apply cleanly to net-next, please respin.
