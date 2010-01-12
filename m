From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] tests/subnet_discover: discover test utility
Date: Tue, 12 Jan 2010 11:31:45 +0200
Message-ID: <20100112093145.GF26089@me>
References: <20090816110200.GS25501@me>
 <20090817083023.da17378b.weiny2@llnl.gov>
 <20090823120609.GG9547@me>
 <20090826164026.8dcce4b2.weiny2@llnl.gov>
 <20091023234349.GK5764@me>
 <20091220121406.GF5262@me>
 <20091220182809.f7e17fae.weiny2@llnl.gov>
 <20091221073550.GB18524@me>
 <20091228092251.GR26940@me>
 <f0e08f231001110556y7c47cc54oa3cfd5859f9a4e76@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f231001110556y7c47cc54oa3cfd5859f9a4e76-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 08:56 Mon 11 Jan     , Hal Rosenstock wrote:
> >
> > diff --git a/tests/subnet_discover.c b/tests/subnet_discover.c
> > index 7f8a85c..42e7aee 100644
> > --- a/tests/subnet_discover.c
> > +++ b/tests/subnet_discover.c
> > @@ -40,6 +40,7 @@ static struct node *node_array[32 * 1024];
> > =A0static unsigned node_count =3D 0;
> > =A0static unsigned trid_cnt =3D 0;
> > =A0static unsigned outstanding =3D 0;
> > +static unsigned max_outstanding =3D 8;
>=20
> Any reason why this default is different from the one which OpenSM
> uses ? Seems to me it should be the same (or less).

In my tests I found that '8' is more optimal number (the tool works
faster and without drops) than '4' used in OpenSM.

Of course it would be helpful to run this over bigger cluster than
what I have to see that the results are consistent.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
