From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] Adding support for Debian packaging
Date: Wed, 27 Feb 2013 21:11:13 +0200
Message-ID: <CAJZOPZKOpjrzW4+Gyotxhyx+uKhUHDEU6VeM8PbK-GQFN4z3iA@mail.gmail.com>
References: <1361441897-19486-1-git-send-email-ilyan@mellanox.com>
	<CABweQmK6zBZSeeLShS8MpcFu6oHVvNw6CF_3sWbqe1dGM-BeUg@mail.gmail.com>
	<CAL1RGDVaiOp84E3SfF6nUkNvjrAeUE=32EdmWusmWZSZqRJ_Qw@mail.gmail.com>
	<512DB43C.5060801@dev.mellanox.co.il>
	<CAL1RGDU3pHNNk_jtVWpW6OPyD1BjOxb8NFYcU=ojWxOGXkusug@mail.gmail.com>
	<512E14E7.9020808@dev.mellanox.co.il>
	<CABweQmKPpRvKZE8JoO_rX3OrUN+nB=u1DOUAJfuwXNP_+54neg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABweQmKPpRvKZE8JoO_rX3OrUN+nB=u1DOUAJfuwXNP_+54neg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Narayan Desai <narayan.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ilya Nelkenbaum <ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 27, 2013 at 5:47 PM, Narayan Desai <narayan.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Ilya. The easiest way to see packaging for a library (from an
> upstream apt source) is to run

[...]

Ilya,

You can also take a look on the upstream trees for libibverbs and
libmlx4 maintained by Roland which have a debian dir, which you
probably can re-use for the managment libraries and opensm, here are
the gitweb pointers,

http://git.kernel.org/?p=libs/infiniband/libibverbs.git;a=summary
http://git.kernel.org/?p=libs/infiniband/libmlx4.git;a=summary

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
