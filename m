From: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC] Introduce verbs API for multi-packet work request
Date: Sat, 16 Dec 2017 08:32:28 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1712160831200.2637@nuc-kabylake>
References: <CAFgAxU-rJb6mvH_XRt0S5_-wKwv3rOnweiLJ8WSuc=9F+P0BrQ@mail.gmail.com> <alpine.DEB.2.20.1712140920090.6249@nuc-kabylake> <20171215173729.GC12434@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171215173729.GC12434-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Guy Levi(SW)" <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Alex @ Mellanox" <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 15 Dec 2017, Jason Gunthorpe wrote:

> Mellanox hardware will implement this feature using what is called
> striding rq.
>
> The samantics here have been generalized, please look if it is useful
> for you..

Sure it is. In case of high volume processing of smaller packets one is
limited by the number of CQEs and WQEs that a processor can handle. This
is very useful.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
