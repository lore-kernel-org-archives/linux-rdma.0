From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_mcast_tbl.c: Fix multicast group removal
Date: Fri, 30 Oct 2009 22:36:06 +0200
Message-ID: <20091030203606.GD5829@me>
References: <20091030144919.GA26847@comcast.net>
 <20091030102649.fa06e288.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091030102649.fa06e288.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10:26 Fri 30 Oct     , Ira Weiny wrote:
> This patch causes this assert again...
> 
> OpenSM $ opensm: osm_mcast_tbl.c:104: osm_mcast_tbl_set: Assertion `mlid_ho <= p_tbl->max_mlid_ho' failed.
> Aborted (core dumped)
> 
> I thought the -1 was required...

The problem is different: when osm_mcast_tbl_realloc() is called twice
let's say with 'mlid_offset = 0' and later with 'mlid_offset = 1'
tbl->max_mlid_ho still have MLID_START value because its update is
skipped in this patch. Seems wrong to me.

Sasha

> 
> diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast_tbl.c
> index da106c6..67f083e 100644
> --- a/opensm/opensm/osm_mcast_tbl.c
> +++ b/opensm/opensm/osm_mcast_tbl.c
> @@ -144,7 +144,7 @@ int osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p_tbl, IN uintn_t mlid_offset)
>                size - p_tbl->mft_depth * (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8);
>         p_tbl->p_mask_tbl = p_mask_tbl;
>         p_tbl->mft_depth = mft_depth;
> -       p_tbl->max_mlid_ho = mlid_offset + IB_LID_MCAST_START_HO;
> +       p_tbl->max_mlid_ho = mlid_offset + IB_LID_MCAST_START_HO - 1;
>         return 0;
>  }
> 
> But this did not fix it...  I would dig further but I am kind of busy today, sorry.
> 
> Ira
> 
> 
> On Fri, 30 Oct 2009 09:49:19 -0500
> Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org> wrote:
> 
> > 
> > Revert de3171043b3cbe078e410351a00e5756509bd514 and
> > some of 537d67b19a4b72d72341e529f611e4e30754f8fc
> > 
> > In osm_mcast_tbl_realloc, don't change max_mlid_ho when mlid_offset < p_tbl->mft_depth
> > Also, restore some checks when mlid_offset >= p_tbl->mft_depth
> > These changes are needed for proper group removal 
> > 
> > Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > ---
> > diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast_tbl.c
> > index 0a45904..da106c6 100644
> > --- a/opensm/opensm/osm_mcast_tbl.c
> > +++ b/opensm/opensm/osm_mcast_tbl.c
> > @@ -122,7 +122,7 @@ int osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p_tbl, IN uintn_t mlid_offset)
> >  	uint16_t (*p_mask_tbl)[][IB_MCAST_POSITION_MAX];
> >  
> >  	if (mlid_offset < p_tbl->mft_depth)
> > -		goto done;
> > +		return 0;
> >  
> >  	/*
> >  	   The number of bytes needed in the mask table is:
> > @@ -144,7 +144,6 @@ int osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p_tbl, IN uintn_t mlid_offset)
> >  	       size - p_tbl->mft_depth * (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8);
> >  	p_tbl->p_mask_tbl = p_mask_tbl;
> >  	p_tbl->mft_depth = mft_depth;
> > -done:
> >  	p_tbl->max_mlid_ho = mlid_offset + IB_LID_MCAST_START_HO;
> >  	return 0;
> >  }
> > @@ -167,6 +166,9 @@ boolean_t osm_mcast_tbl_is_port(IN const osm_mcast_tbl_t * p_tbl,
> >  		CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
> >  
> >  		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
> > +		if (mlid_offset >= p_tbl->mft_depth)
> > +			return FALSE;
> > +
> >  		mask_offset = port_num / IB_MCAST_MASK_SIZE;
> >  		bit_mask = cl_ntoh16((uint16_t)
> >  				     (1 << (port_num % IB_MCAST_MASK_SIZE)));
> > @@ -194,6 +196,8 @@ boolean_t osm_mcast_tbl_is_any_port(IN const osm_mcast_tbl_t * p_tbl,
> >  		CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
> >  
> >  		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
> > +		if (mlid_offset >= p_tbl->mft_depth)
> > +			return FALSE;
> >  
> >  		for (position = 0; position <= p_tbl->max_position; position++)
> >  			result |= (*p_tbl->p_mask_tbl)[mlid_offset][position];
> > @@ -247,6 +251,8 @@ void osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho)
> >  
> >  	if (p_tbl->p_mask_tbl && mlid_ho <= p_tbl->max_mlid_ho) {
> >  		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
> > +		if (mlid_offset >= p_tbl->mft_depth)
> > +			return;
> >  		for (i = 0; i <= p_tbl->max_position; i++)
> >  			(*p_tbl->p_mask_tbl)[mlid_offset][i] = 0;
> >  	}
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://*vger.kernel.org/majordomo-info.html
> > 
> 
> 
> -- 
> Ira Weiny
> Math Programmer/Computer Scientist
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
