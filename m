From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: EINVAL when INIT -> RTR on RoCE
Date: Thu, 26 Jul 2012 10:47:09 -0700
Message-ID: <CAL1RGDWRsvjb6dYqfEP8X5DZ8UvoXh+5LF-mOEKNKjDzRx93ww@mail.gmail.com>
References: <B2CAB3C7-6049-4B8B-90C1-9DD2180857EE@gmail.com>
 <CAL1RGDUEMiuNKBjShYUmj2OTAS=YDGgpK7d5Li090r2ot8VanQ@mail.gmail.com>
 <CAL1RGDUsk2YV4GwYF7doina+bDGqw6VAHAEajJ7Qg7PJhF6aew@mail.gmail.com>
 <F0AFA058-856F-48A0-99A1-2FB5398B31B6@gmail.com> <2159AA50-F259-4963-BAB3-C300171C37BE@gmail.com>
 <20120726171043.GA7596@obsidianresearch.com> <CEED54B9-B3F4-4D7D-92DF-9314059FFC02@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CEED54B9-B3F4-4D7D-92DF-9314059FFC02-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?Q?Xavier_R=2E_Gu=E9rin?= <guerinx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 26, 2012 at 10:38 AM, "Xavier R. Gu=E9rin" <guerinx@gmail.c=
om> wrote:
> is there any overhead associated with using GIDs?

yes, every packet is 40 bytes longer.

> man ibv_post_recv tells me that the GRH is written into the first 40 =
bytes of the receive buffer for UD QPs. Is that behavior only restricte=
d to UD QPs, or should I plan the presence of this headers when using R=
C QPs ?

40 bytes of UD receive buffers are used for the GRH if it is present,
or skipped if it isn't present.

=46or RC/UC/XRC there is no difference at the transport level.  That's
why the man page only mentions UD.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
