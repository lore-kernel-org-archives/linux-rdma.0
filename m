From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Any progress on horrible IPoIB perf with kernel 4.5+?
Date: Wed, 6 Jul 2016 20:46:04 +0300
Message-ID: <20160706174603.GF4299@yuval-lap.uk.oracle.com>
References: <CAL1RGDXC7JsBN_DS_iqiywKP3GikgAgXm3OK-cZ02tmVctQJQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDXC7JsBN_DS_iqiywKP3GikgAgXm3OK-cZ02tmVctQJQA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Haakon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 06, 2016 at 10:09:51AM -0700, Roland Dreier wrote:
> Hi,
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D111921 describes a
> performance regression introduced by commit 9207f9d45b0a ("net:
> preserve IP control block during GSO segmentation").  I've recently
> run into this when updating my system, since that commit hit stable
> kernel 4.4.y =E2=80=94 in my case I noticed because scp over an IPoIB=
 link
> went from ~200 MB/sec down to below 1 MB/sec.  I confirmed that
> reverting that change did fix my performance.

Same for us.

>=20
> Obviously just reverting that commit isn't the right answer, since I
> believe the patch description that says the commit fixes a crash.
> However before I start working on this myself, I want to make sure I'=
m
> not duplicating anyone else's work.  Doug, you mentioned having time
> to work on it back in May =E2=80=94 did you figure anything out?  Or =
is anyone
> else investigating this?

Adding Haakon which as far as i recall has some insights.

>=20
> Thanks,
>   Roland
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
