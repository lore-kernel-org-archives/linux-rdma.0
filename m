From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] please pull infiniband.git
Date: Wed, 23 Mar 2011 11:15:17 -0700
Message-ID: <AANLkTimGvTrus1r38pPN4v0ZUgN-dqoUaR-JH93SSrCz@mail.gmail.com>
References: <1300902477-6608-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1300902477-6608-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 23, 2011 at 10:47 AM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wro=
te:
> drivers/infiniband/core/addr.c =A0 =A0 =A0 =A0 =A0 | =A0 =A02 +-
> =A0drivers/infiniband/core/agent.c =A0 =A0 =A0 =A0 =A0| =A0 =A03 +-
> =A0drivers/infiniband/hw/mthca/mthca_main.c | =A0 =A03 +
> =A0drivers/infiniband/hw/nes/nes.c =A0 =A0 =A0 =A0 =A0| =A0 =A02 +-
> =A0drivers/infiniband/ulp/srp/ib_srp.c =A0 =A0 =A0| =A0725 ++++++++++=
++++++++++----------
> =A0drivers/infiniband/ulp/srp/ib_srp.h =A0 =A0 =A0| =A0 38 ++-
> =A06 files changed, 521 insertions(+), 252 deletions(-)

Somehow I missed a hunk of

 IB: Increase DMA max_segment_size on Mellanox hardware

diffstat now should look like

 drivers/infiniband/core/addr.c           |    2 +-
 drivers/infiniband/core/agent.c          |    3 +-
 drivers/infiniband/hw/mthca/mthca_main.c |    3 +
 drivers/infiniband/hw/nes/nes.c          |    2 +-
 drivers/infiniband/ulp/srp/ib_srp.c      |  725 ++++++++++++++++++++--=
--------
 drivers/infiniband/ulp/srp/ib_srp.h      |   38 ++-
 drivers/net/mlx4/main.c                  |    3 +
 7 files changed, 524 insertions(+), 252 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
