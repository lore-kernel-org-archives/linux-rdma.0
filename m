From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [RFC] Vendor-specific QPs
Date: Thu, 23 Nov 2017 10:57:15 -0700
Message-ID: <20171123175715.GA30099@ziepe.ca>
References: <VI1PR05MB12784029D1DE2689A8194A58B9590@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <20171102200158.GU18874@ziepe.ca>
 <VI1PR05MB1278EA7700D1BEB63383FC52B9200@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <20171122180731.GS18272@ziepe.ca>
 <CAG9sBKPqVwbS0cXQPTdWCx7vwWaq5EMeghnPMEHrMZZsSsEu_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKPqVwbS0cXQPTdWCx7vwWaq5EMeghnPMEHrMZZsSsEu_g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 23, 2017 at 11:14:40AM +0200, Moni Shoua wrote:

> Since all dv_create_qp() API functions call the ibv_cmd_create_qp()
> and put driver data at the end of the core data it will be simplest to
> manage this in one function with one additional driver data structure
> (that includes a comp_mask to describe the content of the block of
> data). Also, the signature of the mlx5_dv_create_dct() should take an
> extra parameter (besides ib_qp_init_attr and mlx4_dct_init_attr) that
> is common to all dv_create_qp() functions to represent the shared
> driver data. We can avoid all this if we declare only one API function
> to create a driver QP.

I don't see why it makes any difference. Shuffle the data around
inside a mlx5_dv_create_dct to get to the internal format then call
the internal create_qp helper.

Why should it accept a 'shared driver data'? What does that even mean
from the user facing API?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
