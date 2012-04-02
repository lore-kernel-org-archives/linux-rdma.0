From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: mlx4 catas_reset hangs when using the CM
Date: Mon, 2 Apr 2012 09:02:25 +0200
Message-ID: <20120402090225.42087ad3@b012350-ux>
References: <20120329134110.0683d873@b012350-ux>
	<CAL1RGDV-j7A7vEXuWkK6Q96u09woB2vx92gp9LS2=uWFrDmCbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDV-j7A7vEXuWkK6Q96u09woB2vx92gp9LS2=uWFrDmCbw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vincent <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>, Celine <Celine.Bourde-6ktuUTfB/bM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 30 Mar 2012 11:33:56 -0700
Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> On Thu, Mar 29, 2012 at 4:41 AM, sebastien dugue
> <sebastien.dugue-6ktuUTfB/bM@public.gmane.org> wrote:
> > =C2=A0So it looks like that cma_process_remove() did all it's job c=
leaning up
> > but is hung waiting for the client refcount to reach 0, which never=
 happens.
>=20
> This is unfortunately expected with the current implementation.  Beca=
use we
> don't have a way to revoke active userspace users of the device, we j=
ust send
> them a catastrophic error async event and then expect them to clsoe t=
he
> device.  But if they never close the device, we just wait forever.

  Yep, that's what I gathered and unfortunately, having lustre as a cli=
ent
is not going to help.

  Thanks,

  S=C3=A9bastien.

>=20
>  - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
