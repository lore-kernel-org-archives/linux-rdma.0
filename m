From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_ucast_updn.c: Reduce temporary allocation
 of cas_per_sw
Date: Wed, 14 Oct 2009 16:34:23 +0200
Message-ID: <20091014143423.GC13830@me>
References: <20091014131435.GA23890@comcast.net>
 <20091014132911.GB13830@me>
 <f0e08f230910140633i43bd7648w1feba7c2be6c0d11@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230910140633i43bd7648w1feba7c2be6c0d11-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09:33 Wed 14 Oct     , Hal Rosenstock wrote:
> On Wed, Oct 14, 2009 at 9:29 AM, Sasha Khapyorsky <sashak-smomgflXvObQFizaE/u3fw@public.gmane.org=
m> wrote:
> > On 09:14 Wed 14 Oct =A0 =A0 , Hal Rosenstock wrote:
> >>
> >> Also, combine malloc/memset into calloc
> >
> > Any special reason for malloc/calloc change?
>=20
> It's a little more concise and efficient to calloc rather than
> malloc/memset.

Why do you think so? Normally calloc() is malloc() + memset() - you
just get extra call and extra check.

> Any reason not to do this ?

Above.

calloc() can be nicer in some cases and pretty common, feel free to use
it when appropriate. But I don't think that we need to make a global
malloc() -> calloc() conversion without any good reason.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
