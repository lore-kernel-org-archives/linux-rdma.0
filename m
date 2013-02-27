From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] Adding support for Debian packaging
Date: Wed, 27 Feb 2013 13:21:17 -0800
Message-ID: <CAL1RGDXoajY0=W7iJUE4m8a5tgDVbmVihV-gGNVho4Y5cT06gQ@mail.gmail.com>
References: <1361441897-19486-1-git-send-email-ilyan@mellanox.com>
 <CABweQmK6zBZSeeLShS8MpcFu6oHVvNw6CF_3sWbqe1dGM-BeUg@mail.gmail.com>
 <CAL1RGDVaiOp84E3SfF6nUkNvjrAeUE=32EdmWusmWZSZqRJ_Qw@mail.gmail.com>
 <512DB43C.5060801@dev.mellanox.co.il> <CAL1RGDU3pHNNk_jtVWpW6OPyD1BjOxb8NFYcU=ojWxOGXkusug@mail.gmail.com>
 <512E14E7.9020808@dev.mellanox.co.il> <CABweQmKPpRvKZE8JoO_rX3OrUN+nB=u1DOUAJfuwXNP_+54neg@mail.gmail.com>
 <CAJZOPZKOpjrzW4+Gyotxhyx+uKhUHDEU6VeM8PbK-GQFN4z3iA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZKOpjrzW4+Gyotxhyx+uKhUHDEU6VeM8PbK-GQFN4z3iA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Narayan Desai <narayan.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ilya Nelkenbaum <ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 27, 2013 at 11:11 AM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> You can also take a look on the upstream trees for libibverbs and
> libmlx4 maintained by Roland which have a debian dir, which you
> probably can re-use for the managment libraries and opensm, here are
> the gitweb pointers,
>
> http://git.kernel.org/?p=libs/infiniband/libibverbs.git;a=summary
> http://git.kernel.org/?p=libs/infiniband/libmlx4.git;a=summary

I happen to maintain the Debian packaging for libibverbs and libmlx4
in the same source tree as the upstream source.  However it's actually
easier in the case where the Debian packaging maintainer and the
upstream maintainer are different just to leave debian/ directory out
of the upstream source.  If you're not really that familiar with
Debian packaging and Debian policy, it's probably best just to leave
the packaging to the Debian project.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
