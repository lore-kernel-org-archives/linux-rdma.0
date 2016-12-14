From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2] infiniband: remove WARN that is not kernel bug
Date: Wed, 14 Dec 2016 20:27:21 +0200
Message-ID: <20161214182721.GA811@mtr-leonro.local>
References: <1479723531-17940-1-git-send-email-dvyukov@google.com>
 <alpine.LNX.2.00.1611211123450.22752@pobox.suse.cz>
 <CACT4Y+ZO9sTbBGwNUUMkAQ5m0N-4aT0S9xypCRbBUch1pQNw9g@mail.gmail.com>
 <20161121114417.GA4158@leon.nu>
 <CACT4Y+Y1sL-8K7HhZ5M5ABVPG0kM=dKZh+6gvuNRvzXFtiA5aQ@mail.gmail.com>
 <20161121121408.GC4158@leon.nu>
 <20161121165253.GA22237@obsidianresearch.com>
 <20161121173820.GC23083@leon.nu>
 <b5343f5e-68a8-5a01-5fa9-04e9181e4082@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b5343f5e-68a8-5a01-5fa9-04e9181e4082@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Dmitry Vyukov <dvyukov@google.com>, syzkaller <syzkaller@googlegroups.com>, Valdis.Kletnieks@vt.edu, sean.hefty@intel.com, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 14, 2016 at 01:16:45PM -0500, Doug Ledford wrote:
> On 11/21/2016 12:38 PM, Leon Romanovsky wrote:
> > On Mon, Nov 21, 2016 at 09:52:53AM -0700, Jason Gunthorpe wrote:
> >> On Mon, Nov 21, 2016 at 02:14:08PM +0200, Leon Romanovsky wrote:
> >>>>
> >>>> In ib_ucm_write function there is a wrong prefix:
> >>>>
> >>>> + pr_err_once("ucm_write: process %d (%s) tried to do something hinky\n",
> >>>
> >>> I did it intentionally to have the same errors for all flows.
> >>
> >> Lets actually use a good message too please?
> >>
> >>  pr_err_once("ucm_write: process %d (%s) changed security contexts after opening FD, this is not allowed.\n",
> >>
> >> Jason
>
> I applied Leon's reworked version of this patch, thanks.

Thanks Doug,
I already forgot about it :)

>
> --
> Doug Ledford <dledford@redhat.com>
>     GPG Key ID: 0E572FDD
>




--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhRjv4ACgkQ5GN7iDZy
WKckFhAAu6GUwoixXqfcJdgmVMK0LxGJlT1MqF+v7cNCAeSs8jm5NOn4b/C9wqk2
RxSwH6ryN09/cGDv2L2J3QspBIhtjtvEyOa2CiqDmeMI+ydkh/lU1YKSPl6Qxk+V
xsWM/3usrUBhEgfrixzZqdeQcD75QxvCxpNLSaMo7O8AgvF/4QiGYafw70v+WhyS
Q44axlRqR4sYwwVZ/QVrNZX2A2+2BEwHdo+CoH++rcJugTmzRcUreVF1L//fF1GM
x4cz/2QvGb5d402elHRrrk7SgBMp3nX9VFXPBsFHxVeCDf0fEy78w7HVZ8xsDJbY
AGVK+Uo1ipUChQvM/6IbhDPRviq/O4r3FVsPjo3m52HLnRiCGK/76ooP9PMOqJSH
Isf0ygF6E9HgrBqZ5LBKLLusdTWvCccJJxIJyENAJXgv00mN6/tf4TIXzFRBq/13
uYMCcrf6z8dnjT/xJKc8UUrrInoZS1LeVdBYEOHYvUYrqzlhkAW2BDnPNDcj8YgE
KbQmWbz3y4qIzrMzluowkiHyqc+Ilerfy/otFhT8nznmjciG3cahfRblE5uEgQKL
KxYTqs7R9YZLbtwDGOxOhIAt0YVMjNtxyFYJnqKtg9kPAle3/QMSNNb8WIN6QIVF
OCHGidtQl8ts0CS5mCWq2eeFDIyqFEJwzC6c1j2s1bvm13BSMYo=
=5NWa
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
