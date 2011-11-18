From: Roland Dreier <roland@purestorage.com>
Subject: Re: [PATCH] ib_srpt: Make compilation with BUG=n proceed
Date: Fri, 18 Nov 2011 12:10:14 -0800
Message-ID: <CAL1RGDXhS8hc=ERvicXa8xgcLYFP+w5GLvzQOYw6mn0MGyk1XA@mail.gmail.com>
References: <201111172025.44546.bvanassche@acm.org> <CAL1RGDV+vgQ7J1VtyeGi-eNw00Bxe35xRJgBu0X4-5PAG4q-nQ@mail.gmail.com>
 <CAO+b5-oakXVhbxNMOh2LZ7bLKnuTz3B7Q-KbHF_XKjLjNnqueg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <CAO+b5-oakXVhbxNMOh2LZ7bLKnuTz3B7Q-KbHF_XKjLjNnqueg@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-rdma@vger.kernel.org, linux-next@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>, Stephen Rothwell <sfr@canb.auug.org.au>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 17, 2011 at 11:52 PM, Bart Van Assche <bvanassche@acm.org> =
wrote:
> As far as I can see with CONFIG_BUG=3Dn WARN() is defined as follows:
>
> #define WARN(condition, format...) ({ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> =A0 =A0 =A0 =A0int __ret_warn_on =3D !!(condition); =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> =A0 =A0 =A0 =A0unlikely(__ret_warn_on); =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> })
>
> So the changing pr_err(); WARN_ON(true); into WARN(1, ...) would caus=
e
> no error message to be printed if CONFIG_BUG=3Dn. Is that the way ker=
nel
> code should behave if CONFIG_BUG=3Dn ?

I don't know the code well enough to know what it *should* do ...
pretty much all WARN (or WARN_ON or __WARN) gives over a
printk is that it includes the backtrace.  Which might not be particula=
rly
useful in this case.

So maybe pr_err() without WARN_ON is the best thing.  I was
just responding microlocally to the couple of lines here without
thinking through what output is actually useful.

What are these error messages for?  A "can never happen" bug
in the ib_srpt logic, or something that could be triggered by an
insane initiator sending a bogus sequence?

 - R.
