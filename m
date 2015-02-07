From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: [GIT PULL] please pull infiniband.git
Date: Sat, 07 Feb 2015 16:58:12 +0100
Message-ID: <1423324692.28062.24.camel@dworkin>
References: <1423257552-3072-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1423257552-3072-1-git-send-email-roland@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le vendredi 06 f=C3=A9vrier 2015 =C3=A0 13:19 -0800, Roland Dreier a =C3=
=A9crit :
>=20
> Please pull from
>=20
>     git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.g=
it tags/rdma-for-linus
>=20
> ----------------------------------------------------------------
> One more last-second RDMA change for 3.19:
>  - Yann realized that the previous revert of new userspace ABI did no=
t
>    go far enough, and we're still exposing a change that we don't wan=
t.
>    Revert even closer to 3.18 interface to make sure we get things ri=
ght
>    in the long run.
>=20
> Sorry for sending this at the very end of the release cycle, but we
> didn't realize the scope of the required fix until just now.
>=20

I hope this could go in v3.19 as, at this stage, we don't want to expos=
e
any bits of this ABI in a released kernel.

Regards.

--=20
Yann Droneaud
OPTEYA
