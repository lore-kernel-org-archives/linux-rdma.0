From: Or Gerlitz <or.gerlitz@gmail.com>
Subject: Re: linux-next: manual merge of the infiniband tree with Linus' tree
Date: Fri, 22 Feb 2013 14:06:22 +0200
Message-ID: <CAJZOPZLeNGwBy7YCTO1Ke7zzkGQDw8hGMGOsT7nt_QrSmX87zg@mail.gmail.com>
References: <20130222115021.d61d6101d1531f8dd4b581de@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20130222115021.d61d6101d1531f8dd4b581de@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>, Yan Burman <yanb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 22, 2013 at 2:50 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> Today's linux-next merge of the infiniband tree got a conflict in
> drivers/infiniband/ulp/ipoib/ipoib_ethtool.c between commit 7826d43f2db4
> ("ethtool: fix drvinfo strings set in drivers") from the  tree and commit
> 4b48680b5572 ("IPoIB: Add version and firmware info to ethtool
> reporting") from the infiniband tree.
>
> I fixed it up (using the latter version as it included the change to use
> strlcpy) and can carry the fix as necessary (no action is required).

thanks for fixing thay up!

Acked-by: Or Gerlitz <ogerlitz@mellanox.com>
