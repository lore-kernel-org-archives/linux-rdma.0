From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH RFC] Introduce verbs API for multi-packet work request
Date: Fri, 15 Dec 2017 10:37:29 -0700
Message-ID: <20171215173729.GC12434@ziepe.ca>
References: <CAFgAxU-rJb6mvH_XRt0S5_-wKwv3rOnweiLJ8WSuc=9F+P0BrQ@mail.gmail.com>
 <alpine.DEB.2.20.1712140920090.6249@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1712140920090.6249@nuc-kabylake>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Guy Levi(SW)" <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Alex @ Mellanox" <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 14, 2017 at 09:21:24AM -0600, Christopher Lameter wrote:
> On Tue, 12 Dec 2017, Alex Rosenbaum wrote:
> 
> > This RFC patch introduces a libibverbs API for receiving multiple packets
> > on a single work request (aka: "MP WR").
> 
> So this may work like a striding rq if we set the alignment to a word or
> so?

Mellanox hardware will implement this feature using what is called
striding rq.

The samantics here have been generalized, please look if it is useful
for you..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
