From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC] Vendor-specific QPs
Date: Thu, 23 Nov 2017 11:14:40 +0200
Message-ID: <CAG9sBKPqVwbS0cXQPTdWCx7vwWaq5EMeghnPMEHrMZZsSsEu_g@mail.gmail.com>
References: <VI1PR05MB12784029D1DE2689A8194A58B9590@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <20171102200158.GU18874@ziepe.ca> <VI1PR05MB1278EA7700D1BEB63383FC52B9200@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <20171122180731.GS18272@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171122180731.GS18272-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 22, 2017 at 8:07 PM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
> On Wed, Nov 22, 2017 at 05:47:42PM +0000, Alex Margolin wrote:
>
>> To follow up on the previous discussion,
>> we changed the RFC proposal to focus on this single type for vendor QP.
>
> Okay.. So in future sending MIME attached patches is very hard to do
> anything with.. I have provided my comments as best I can below:
>
> - The QPT should be IB_QPT_DRIVER
>   Please scrub the word 'vendor' from your vocabulary and all patches.
>   Everything is *DRIVER* specific if it uses the dv interface.
> - It makes me annoyed that 'enum ib_qp_type' is not in a uapi header,
>   please consider sending a patch to fix this while you are touching
>   this area
> - I don't know if having a huge multiplex 'mlx5dv_create_qp' is such a
>   great idea. Since the DV API is linked, it would make more sense to
>   have a specially 'mlx5dv_create_dct' sort of API so that we have
>   better visibility on what the app needs of the dv library. Eg a dct
>   using app will fail to link on older dv libraries.
Since all dv_create_qp() API functions call the ibv_cmd_create_qp()
and put driver data at the end of the core data it will be simplest to
manage this in one function with one additional driver data structure
(that includes a comp_mask to describe the content of the block of
data). Also, the signature of the mlx5_dv_create_dct() should take an
extra parameter (besides ib_qp_init_attr and mlx4_dct_init_attr) that
is common to all dv_create_qp() functions to represent the shared
driver data. We can avoid all this if we declare only one API function
to create a driver QP.
> - The libmlx5.map is wrong..
>
> Otherwise, this is broadly what I had in mind when we talked about
> this at the last conference.
>
> The idea is to simply shunt eveything to the driver path until someone
> bothers to standadize the features. DC will not be exposed to the core
> RDMA code in the kernel.
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
