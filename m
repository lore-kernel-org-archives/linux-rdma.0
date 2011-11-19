From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] ib_srpt: Make compilation with BUG=n proceed
Date: Sat, 19 Nov 2011 10:11:15 +0100
Message-ID: <CAO+b5-rWt1i1CrpqRKkVJevbhgDc=Ja=1QpmQg0sKg_ihe8q-w@mail.gmail.com>
References: <201111172025.44546.bvanassche@acm.org>
	<CAL1RGDV+vgQ7J1VtyeGi-eNw00Bxe35xRJgBu0X4-5PAG4q-nQ@mail.gmail.com>
	<CAO+b5-oakXVhbxNMOh2LZ7bLKnuTz3B7Q-KbHF_XKjLjNnqueg@mail.gmail.com>
	<CAL1RGDXhS8hc=ERvicXa8xgcLYFP+w5GLvzQOYw6mn0MGyk1XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <CAL1RGDXhS8hc=ERvicXa8xgcLYFP+w5GLvzQOYw6mn0MGyk1XA@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: linux-rdma@vger.kernel.org, linux-next@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>, Stephen Rothwell <sfr@canb.auug.org.au>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 18, 2011 at 9:10 PM, Roland Dreier <roland@purestorage.com>=
 wrote:
> On Thu, Nov 17, 2011 at 11:52 PM, Bart Van Assche <bvanassche@acm.org=
> wrote:
> > As far as I can see with CONFIG_BUG=3Dn WARN() is defined as follow=
s:
> >
> > #define WARN(condition, format...) ({ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> > =A0 =A0 =A0 =A0int __ret_warn_on =3D !!(condition); =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> > =A0 =A0 =A0 =A0unlikely(__ret_warn_on); =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> > })
> >
> > So the changing pr_err(); WARN_ON(true); into WARN(1, ...) would ca=
use
> > no error message to be printed if CONFIG_BUG=3Dn. Is that the way k=
ernel
> > code should behave if CONFIG_BUG=3Dn ?
>
> I don't know the code well enough to know what it *should* do ...
> pretty much all WARN (or WARN_ON or __WARN) gives over a
> printk is that it includes the backtrace. =A0Which might not be parti=
cularly
> useful in this case.
>
> So maybe pr_err() without WARN_ON is the best thing. =A0I was
> just responding microlocally to the couple of lines here without
> thinking through what output is actually useful.

According to the description in init/Kconfig, BUG=3Dn should only be
used on embedded systems with no facilities for error reporting. I do
not expect that anyone will miss the pr_err() output on such a system.

> What are these error messages for? =A0A "can never happen" bug
> in the ib_srpt logic, or something that could be triggered by an
> insane initiator sending a bogus sequence?

These messages are present in code paths that should never be reached,
no matter how the initiator or the IB network behaves. These messages
have been useful while making ib_srpt robust against IB cable pulling
- see e.g. http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg09=
664.html.

Bart.
