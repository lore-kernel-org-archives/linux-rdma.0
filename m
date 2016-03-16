From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [WTF] utterly tasteless ABI in hfi1 (around
 ->write()/->write_iter())
Date: Wed, 16 Mar 2016 11:46:31 -0400
Message-ID: <56E97FD7.9020007@redhat.com>
References: <20160316041717.GJ17997@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NQXBAtkBF9lRO8wSf6hXdLDrDM2lDaWXg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160316041717.GJ17997-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ira weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NQXBAtkBF9lRO8wSf6hXdLDrDM2lDaWXg
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 03/16/2016 12:17 AM, Al Viro wrote:
> 	Folks, we'd discussed that kind of crap already; why, in name of
> everything unholy, is that kind of garbage brought back in a new driver=
?

No doubt because in large part the hfi1 driver copy and pastes
significant portions of the qib driver.  Likewise, libpsm2 (which works
with the hfi1 devices) is largely a copy and paste job from open-psm
(which works with qib/ipath devices).

> 	Having both ->write() and ->write_iter() *AND* having entirely
> unrelated interpretation of user input on those two on the same device
> is bogus, with the capital Stop That Shit Right Now.
>=20
> 	As it is, write(fd, p, len) and writev(fd, &(struct iovec){p,len}, 1)
> are interpreted in absolutely unrelated ways.  As in, entirely differen=
t
> set of commands.  Moreover, aio IOCB_CMD_PWRITE matches writev(), not w=
rite().
>=20
> 	What's going on?  Sure, ipathfs is a precious snowflake with the same
> kind of braindamage.  Back when it had been brought to your attention
> (along with the fact that this piece of idiocy happens to be a file on
> filesystem of your own, under your full control and no need whatsofucki=
ngever
> to multiplex completely unrelated sets of commands on the same file wit=
h
> "was it write(2) or writev(2)?" used as a selector) the answer had been=

> basically "it doesn't have to make sense, it's Special".

I can't speak for Mike, but I never said "It's Special".  I said it's a
driver internal thing with only one consumer and the kernel driver and
the user space consumer are a matched pair.  If this were a general API
for use by any old program I would agree with you, but since it isn't, I
wasn't that concerned about whether it got fixed.  If it broke, Intel
had both pieces and could fix it.  And with that in mind I said "ince
this is an internal driver interface that only Intel uses, I'm not
inclined to force them to rewrite their driver and their library just
because their particular usage took you off guard."

I should point out that the fragility is not so rampant as you make it
sound.  The qib driver was added in 2010 and had this interface then
(modulo your changes in 4961772560d2).  It was a copy from the ipath
driver at the time, so in truth had been around much longer even than 201=
0.

>  Now it turns out
> that it has grown an equally special sibling.  With the idiocy directly=

> exposed as userland ABI.  Could we please fix that thing before it's ca=
st in
> stone?

If we want to maintain back compatibility, then the qib driver has to
maintain this interface. We could possibly do a new one as well, but we
can't remove this one.

For the hfi1 driver (and OPA in general), we do have the ability to do a
new API.  But, going back to what I said before, I just don't care that
much.  It's Intel internal stuff as far as I'm concerned.  If they do
something fragile and it breaks, then that's all on their hands.
They've gotten away with it for over 10 years so I can see why they
probably aren't that concerned about it themselves.

> 	Take a look at drivers/staging/rdma/hfi1/file_ops.c in -next and
> compare hfi1_write_iter() with hfi1_file_write().  Folks, this ABI is t=
oo
> ugly to live, let alone to be allowed breeding.
>=20
> 	It's also brittle as hell - trivial massage around fs/read_write.c
> and fs/aio.c is quite capable of breaking that shit.  Arguably, IOCB_CM=
D_PWRITE
> and IOCB_CMD_PWRITEV both triggering your writev() semantics is an exam=
ple of
> just such breakage.  Sigh...

I'm sure you could break it intentionally if you wanted to.  Not that I
think you *should*, but I'm sure you *could*.

Intel: For your own sake's you might want to consider doing something
simple such as using two files, one for regular commands and one for
SDMA commands, and modifying both the hfi1 and libpsm2 code bases.  I
don't care, and I wouldn't force you to do it, but I've made my argument
to Al and he appears to be running it up the tree, so it might be
easiest to capitulate.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--NQXBAtkBF9lRO8wSf6hXdLDrDM2lDaWXg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW6X/YAAoJELgmozMOVy/d2cYP+wQlt6+Y1c4Wt7Abroea9kn7
yfAMbfT2ZLEYWwqg6orEOQpnfdS0Rx91Xk1tlXTJeyuHUc3pMHumckWAKZQcmSro
MB7WDwaAIv7UIP5DJsd2smZJr85SyyQkdycp9pM/IPFY0Yy1+iKrTRPKobFqSYtr
WDl7KM8GrXbbraiu/0NbcJcERzuAS9uANpcatrnOlywCMRd51CegeVQvbHlZ8vSI
FvzCPcxdYqRau5kNcb4xMs66oZZxWyIDWxt7cEHLlmRUSNKPfbqje8PPu0nFal9o
EyCDifm8E0xsP/YVrnhf5hZ9AmGkYTRaDUvO405e7pwvWtnXRjTQyn0ny3QvnJe4
vSnYumcLCnaW8OwVELmnRdSeiPS7ooY/JQBlqbVIRua/9QaI5zMfvALOseQO+1O/
UH54TZwwpjYKtjSg0UJsL35EhmpPClaH1xA6Clkfy7XuRk60nZ39IvkNIDvspW+l
LqcZUi5w/hexj4LQ2IK2CQtkWBHP/1cQw5oJ3YHcGfwCdwznJJ3eQd4j8sv9HXX5
c7cNQUutNYdbxHhOnpY35qE+XXmbu0EqcDP8G2hx1z079v/5iTLyExyGtdJyR7q1
ceW21nBbLaD21EEVI4VKigO7qEdfnMeaf6fxECwoCZbMYDUx2x09n/kr4Z3pOuam
W5iH1dsD9vY0BVdXTpB0
=vJ7s
-----END PGP SIGNATURE-----

--NQXBAtkBF9lRO8wSf6hXdLDrDM2lDaWXg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
