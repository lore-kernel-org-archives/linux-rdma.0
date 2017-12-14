From: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC] Introduce verbs API for multi-packet work request
Date: Thu, 14 Dec 2017 09:21:24 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1712140920090.6249@nuc-kabylake>
References: <CAFgAxU-rJb6mvH_XRt0S5_-wKwv3rOnweiLJ8WSuc=9F+P0BrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFgAxU-rJb6mvH_XRt0S5_-wKwv3rOnweiLJ8WSuc=9F+P0BrQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Guy Levi(SW)" <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Alex @ Mellanox" <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 12 Dec 2017, Alex Rosenbaum wrote:

> This RFC patch introduces a libibverbs API for receiving multiple packets
> on a single work request (aka: "MP WR").

So this may work like a striding rq if we set the alignment to a word or
so?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
