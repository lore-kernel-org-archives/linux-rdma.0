From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: [PATCH] IB/core: avoid 32-bit warning
Date: Wed, 07 Oct 2015 15:46:48 +0200
Message-ID: <1444225608.3188.67.camel@opteya.com>
References: <17269152.DqJfCm1LOx@wuerfel>
	 <56151BDF.8010504@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56151BDF.8010504@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Arnd Bergmann <arnd@arndb.de>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Roland Dreier <roland@purestorage.com>, linux-rdma@vger.kernel.org, Matan Barak <matanb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mercredi 07 octobre 2015 =C3=A0 16:19 +0300, Sagi Grimberg a =C3=A9c=
rit :
> On 10/7/2015 3:29 PM, Arnd Bergmann wrote:
> > The INIT_UDATA() macro requires a pointer or unsigned long argument
> > for
> > both input and output buffer, and all callers had a cast from when
> > the code was merged until a recent restructuring, so now we get
> >=20
> > core/uverbs_cmd.c: In function 'ib_uverbs_create_cq':
> > core/uverbs_cmd.c:1481:66: warning: cast to pointer from integer of
> > different size [-Wint-to-pointer-cast]
> >=20
> > This makes the code behave as before by adding back the cast to
> > unsigned long.
> >=20
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Fixes: 565197dd8fb1 ("IB/core: Extend ib_uverbs_create_cq")
> >=20
> > diff --git a/drivers/infiniband/core/uverbs_cmd.c
> > b/drivers/infiniband/core/uverbs_cmd.c
> > index be4cb9f04be3..88b3b78340f2 100644
> > --- a/drivers/infiniband/core/uverbs_cmd.c
> > +++ b/drivers/infiniband/core/uverbs_cmd.c
> > @@ -1478,7 +1478,7 @@ ssize_t ib_uverbs_create_cq(struct
> > ib_uverbs_file *file,
> >   	if (copy_from_user(&cmd, buf, sizeof(cmd)))
> >   		return -EFAULT;
> >=20
> > -	INIT_UDATA(&ucore, buf, cmd.response, sizeof(cmd),
> > sizeof(resp));
> > +	INIT_UDATA(&ucore, buf, (unsigned long)cmd.response,
> > sizeof(cmd), sizeof(resp));
>=20
> Would it make sense to cast inside INIT_UDATA() and not have callers
> worry about it?

It's ... complicated. See INIT_UDATA_BUF_OR_NULL().

Awayway, I have patch to do the opposite, eg. explicitly cast u64 value
to (void __user *)(unsigned long) in the caller function instead, as it
allows some safer / new operations on the response buffer.

Regards.

--=20
Yann Droneaud
OPTEYA
