From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [RFC] Vendor-specific QPs
Date: Wed, 22 Nov 2017 11:07:31 -0700
Message-ID: <20171122180731.GS18272@ziepe.ca>
References: <VI1PR05MB12784029D1DE2689A8194A58B9590@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <20171102200158.GU18874@ziepe.ca>
 <VI1PR05MB1278EA7700D1BEB63383FC52B9200@VI1PR05MB1278.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR05MB1278EA7700D1BEB63383FC52B9200-79XLn2atqDMOK6E67s+DINqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 22, 2017 at 05:47:42PM +0000, Alex Margolin wrote:

> To follow up on the previous discussion,
> we changed the RFC proposal to focus on this single type for vendor QP.

Okay.. So in future sending MIME attached patches is very hard to do
anything with.. I have provided my comments as best I can below:

- The QPT should be IB_QPT_DRIVER
  Please scrub the word 'vendor' from your vocabulary and all patches.
  Everything is *DRIVER* specific if it uses the dv interface.
- It makes me annoyed that 'enum ib_qp_type' is not in a uapi header,
  please consider sending a patch to fix this while you are touching
  this area
- I don't know if having a huge multiplex 'mlx5dv_create_qp' is such a
  great idea. Since the DV API is linked, it would make more sense to
  have a specially 'mlx5dv_create_dct' sort of API so that we have
  better visibility on what the app needs of the dv library. Eg a dct
  using app will fail to link on older dv libraries.
- The libmlx5.map is wrong..

Otherwise, this is broadly what I had in mind when we talked about
this at the last conference.

The idea is to simply shunt eveything to the driver path until someone
bothers to standadize the features. DC will not be exposed to the core
RDMA code in the kernel.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
