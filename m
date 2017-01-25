From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] IB/core: Add inline function to validate port
Date: Wed, 25 Jan 2017 17:00:45 +0000
Message-ID: <1485363630.2646.3.camel@sandisk.com>
References: <1485362497-18723-1-git-send-email-yuval.shaia@oracle.com>
         <20170125165022.GQ6005@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170125165022.GQ6005-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Content-ID: <C5F2E15B3DD4464E92EE162143A488A2-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>a
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-01-25 at 18:50 +0200, Leon Romanovsky wrote:
> On Wed, Jan 25, 2017 at 06:41:37PM +0200, Yuval Shaia wrote:
> > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/core/cache.c  | 18 ++++++++----------
> >  drivers/infiniband/core/cma.c    |  6 ++----
> >  drivers/infiniband/core/device.c |  4 ++--
> >  drivers/infiniband/core/verbs.c  |  3 +--
> >  include/rdma/ib_verbs.h          |  7 +++++++
> >  5 files changed, 20 insertions(+), 18 deletions(-)
>=20
> Nice change, however all places are pretended with "!".
> Can we change the name of function to something like
> "rdma_is_port_invalid"?

I prefer the current approach, namely with a positive function name.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
