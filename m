From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-3.2 v1 3/5] ib/mlx4: Add extended port capabilities support
Date: Wed, 19 Oct 2011 02:28:47 +0200
Message-ID: <CAJZOPZJsnBcomvTcSKCy7CuZXzqers=UwSDHE-ST24EmSvNCDw@mail.gmail.com>
References: <201110031755.41883.marcela@dev.mellanox.co.il>
	<CAL1RGDUc=5=Xce9PXTFe3p55kZPnQKcBxRwRnkAwASKc9MFAVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUc=5=Xce9PXTFe3p55kZPnQKcBxRwRnkAwASKc9MFAVQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, marcela-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Is there any reason mlx4_get_ext_port_caps() couldn't be more like
> mlx4_check_ext_port_caps(), and have that function set
> MLX4_FLAG_EXTENDED_PORT_INFO? =A0Is it possible that
> only some ports on the same HCA handle the extended port info query?
> If so is there some reason this one bit needs a u64 to hold it?

Roland,

I hope you saw Marcel's reply saying that yes, it could be that only
some ports on the same HCA can handle this query, so this does need to
be per port.

As for that "this" do you prefer this flag to be implemented now as
"u8 ext_info" field of the port structure and turned into a bit which
is part of 32/64 bits extended_info caps field later when the 2nd such
cap pops out?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
