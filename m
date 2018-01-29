From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Reconnect on RDMA device reset
Date: Mon, 29 Jan 2018 17:28:19 -0500
Message-ID: <1517264899.27592.277.camel@redhat.com>
References: <CADZhsQqDFc1NWmsihOwki8_2Zj0HuYKC_N_x0jMnCtU9Rww1UA@mail.gmail.com>
         <f0a14240-1566-1bae-1b9f-21880bc3f3a0@grimberg.me>
         <CADZhsQqvK0LMd9sfxzz+x_5qVnoi4FP0FCFMsTPjpeXyqfXKew@mail.gmail.com>
         <77cef33e-a563-97fc-7ba6-69f220f1be84@grimberg.me>
         <1516904022.27592.187.camel@redhat.com>
         <26056a83-2f81-6b56-7bbf-fcecfc4518d6@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-T9LSnw8+t148XzBZv4so"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <26056a83-2f81-6b56-7bbf-fcecfc4518d6-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Oren Duer <oren.duer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-T9LSnw8+t148XzBZv4so
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-01-29 at 22:36 +0200, Sagi Grimberg wrote:
> >=20
> That is the case for nvme as well, but I was merely saying that device
> reset is not really a device removal. And this makes it hard for the ULP
> to understand what to do (or for me at least...)

OK, I get that the difference between the two is making it hard to
understand what to do.  But, the truth of the issue is that whether you
are doing a reset or a remove/add cycle, what *your* code needs to do
doesn't change.  For both cases, your code must A) drop everything on
the floor like a hot potato and B) restart from scratch.  The only thing
that's confusing you is that it's more or less assumed on a reset that
you would auto-restart, where as it isn't so clear that you would want
to do the same on a remove/add cycle.  I think the answer to your
question is: if the same device comes back that went away, then yes,
auto-restart would seem appropriate.  If you make that policy decision,
then the *only* difference between device reset and device hot-replug is
that you actually have to verify that the same device came back as went
away.

As an optional item, you could start a timer when the device disappears,
and if it takes more than, say, 10 minutes to reappear, you could cancel
the auto-restart on the basis that someone probably physically unplugged
and replugged the card and they might not want that.  But really, aside
from the fact that the hot plug flow needs you to check the same device
comes back, reset and hot plug have the exact same requirements/needs
and can be serviced by a single code path.

> > > > >   I'm not sure I understand why
> > > > > RDMA device resets manifest as DEVICE_REMOVAL events to ULPs (via
> > > > > rdma_cm or .remove_one via ib_client API). I think the correct in=
terface
> > > > > would be suspend/resume semantics for RDMA device resets (similar=
 to pm
> > > > > interface).
> >=20
> > No, we can't do this.  Suspend/Resume is not the right model for an RDM=
A
> > device reset.  An RDMA device reset is a hard action that stops all
> > ongoing DMA regardless of its source.
>=20
> Suspend also requires that.

But suspend has a locale semantic of "local to this machine" and usually
at least attempts to stop gracefully.  Because RDMA allows for things
such as a remote machine doing an RDMA READ when we suspend, we can't
even attempt the normal graceful shutdown and are left with only the
nuclear reset option.

In addition, if you reset a network card, the network card's registers
don't disappear, and your PCI MMIO region doesn't go away.  When you
reset an RDMA adapter, all of allocated memory regions for card
communications that have been handed out to kernel space, user space,
etc. *do* disappear.  That isn't really like the suspend semantic.  You
don't have the option of cleanly stopping things and quiescing the
system prior to suspend, because your basic communication channel is
gone already.  From this point of view, the hot remove semantic is very
fitting.  The entire card didn't get hot removed, but certainly all of
those allocated communication channels very well did.

> > Those sources include kernel
> > layer consumers, user space consumers acting without the kernel's direc=
t
> > intervention, and ongoing DMA with remote RDMA peers (which will throw
> > the remote queue pairs into an error state almost immediately).  In the
> > future it very likely could include RDMA between things like GPU offloa=
d
> > processors too.  We can't restart that stuff even if we wanted to.  So
> > suspend/resume semantics for an RDMA device level reset is a non-
> > starter.
>=20
> I see. I can understand the argument "we are stuck with what we have"
> for user-space, but does that mandate that we must live with that for
> kernel consumers as well? Even if the semantics is confusing? (Just
> asking, its only my opinion :))

See above.  It's not about user versus kernel space, it's that we really
did hot-remove a bunch of resources, even if not the card itself.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-T9LSnw8+t148XzBZv4so
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpvoAMACgkQuCajMw5X
L92ObQ/7BE7XPHEY4zrgqGjt+V/rmhdQwkNt8XzN0R9t6HQ2oL54C2+1J4cSTaWp
LvbBoS4j9pVcnW4eq790XoErfHva8znI5jYZ4P2mC8Fge8ac4/RMtH0ZVhcjI8Er
6Qwn3qPEYdaNR2+q8fuDa1+BoCDBDt0x4ghlgALAPo8zI/s6IP2hrLTwYyqBaJK1
6d2g4mXmrKtnmbD8Do4nEpzLImM4rnCYjtSbcU4ELCJnUy0aJUapMEYBpjIYgFC5
PE5cD7LLkQ5ubB+dCJvPwnFjiTkX//N21UeLgM+s+i9mdNxs6eagKhX7plV7u+4P
/Jy2JiyL89PLMOZYmHPm5C6atH7cf/NMHmBVdnihdkHXrTEzw2MN8562cBNIDDEF
jcqeIIAmu9NXx/x2SZ8MyUduLngE2oVYHim2QuvVeHVl8el2GtXXgAsgTyEiPvyk
pvBVrt55ODsRuyo5I9/YCUNYwPy8yDTu9ko9q3bNWRCKDrodiAJWsxrDD7Mi2C48
gDApIptpbvdkQbykSogEx/QwxwID+UocPlNvZobkSGKwlZ9XxIAfAGDjAtlC+RlM
jEQ+mKE3bG23fNhRuL1GqniP2EEwdyAF0K1lslgMgjYPpLfvuIM3qm6g40Gt79E8
gXzSOgH9MYwbUeCC824IOTLgx1NL9df/n2tmBqpuLWPhCChswqA=
=b6RR
-----END PGP SIGNATURE-----

--=-T9LSnw8+t148XzBZv4so--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
