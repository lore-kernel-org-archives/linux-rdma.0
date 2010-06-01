From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm: fixing compilation issues in some header files
Date: Tue, 01 Jun 2010 14:58:31 +0300
Message-ID: <4C04F5E7.8030904@dev.mellanox.co.il>
References: <4BAA34B2.9060808@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BAA34B2.9060808-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sasha,

On 24-Mar-10 5:50 PM, Yevgeny Kliteynik wrote:
> All the compilation issues refer to implicit casting
> from "void*" to "some_struct_t*"

This was detected when compiling a code that includes these
headers with g++ compiler. The headers should be able to compile
by g++ (they have 'extern "C"'). But the problem is not only
with g++ - it is with typing in general. I may be wrong, but I
feel that every new gcc version is more strongly typed.
Moreover, it appears that it would be more strongly typed in the
future, as GCC folks themselves are starting to compile GCC
with G++:

http://gcc.gnu.org/ml/gcc/2010-05/msg00705.html

-- Yevgeny

  
> Signed-off-by: Yevgeny Kliteynik<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> ---
>   opensm/include/opensm/osm_pkey.h   |    8 +++++---
>   opensm/include/opensm/osm_port.h   |    4 ++--
>   opensm/include/opensm/osm_subnet.h |    2 +-
>   3 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/opensm/include/opensm/osm_pkey.h b/opensm/include/opensm/osm_pkey.h
> index d10479d..53e9657 100644
> --- a/opensm/include/opensm/osm_pkey.h
> +++ b/opensm/include/opensm/osm_pkey.h
> @@ -252,7 +252,8 @@ static inline ib_pkey_table_t *osm_pkey_tbl_block_get(const osm_pkey_tbl_t *
>   						      uint16_t block)
>   {
>   	return ((block<  cl_ptr_vector_get_size(&p_pkey_tbl->blocks)) ?
> -		cl_ptr_vector_get(&p_pkey_tbl->blocks, block) : NULL);
> +		(ib_pkey_table_t *)cl_ptr_vector_get(
> +		&p_pkey_tbl->blocks, block) : NULL);
>   };
>
>   /*
> @@ -282,8 +283,9 @@ static inline ib_pkey_table_t *osm_pkey_tbl_new_block_get(const osm_pkey_tbl_t *
>   							  p_pkey_tbl,
>   							  uint16_t block)
>   {
> -	return (block<  cl_ptr_vector_get_size(&p_pkey_tbl->new_blocks)) ?
> -	    cl_ptr_vector_get(&p_pkey_tbl->new_blocks, block) : NULL;
> +	return ((block<  cl_ptr_vector_get_size(&p_pkey_tbl->new_blocks)) ?
> +		(ib_pkey_table_t *)cl_ptr_vector_get(
> +		&p_pkey_tbl->new_blocks, block) : NULL);
>   };
>
>   /****f* OpenSM: osm_pkey_tbl_set_new_entry
> diff --git a/opensm/include/opensm/osm_port.h b/opensm/include/opensm/osm_port.h
> index ff0a178..8c68c99 100644
> --- a/opensm/include/opensm/osm_port.h
> +++ b/opensm/include/opensm/osm_port.h
> @@ -549,7 +549,7 @@ static inline void osm_physp_set_slvl_tbl(IN osm_physp_t * p_physp,
>
>   	CL_ASSERT(p_slvl_tbl);
>   	CL_ASSERT(osm_physp_is_valid(p_physp));
> -	p_tbl = cl_ptr_vector_get(&p_physp->slvl_by_port, in_port_num);
> +	p_tbl = (ib_slvl_table_t *)cl_ptr_vector_get(&p_physp->slvl_by_port, in_port_num);
>   	*p_tbl = *p_slvl_tbl;
>   }
>
> @@ -590,7 +590,7 @@ static inline ib_slvl_table_t *osm_physp_get_slvl_tbl(IN const osm_physp_t *
>   	ib_slvl_table_t *p_tbl;
>
>   	CL_ASSERT(osm_physp_is_valid(p_physp));
> -	p_tbl = cl_ptr_vector_get(&p_physp->slvl_by_port, in_port_num);
> +	p_tbl = (ib_slvl_table_t *)cl_ptr_vector_get(&p_physp->slvl_by_port, in_port_num);
>   	return p_tbl;
>   }
>
> diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
> index 3970e98..2eef9c7 100644
> --- a/opensm/include/opensm/osm_subnet.h
> +++ b/opensm/include/opensm/osm_subnet.h
> @@ -1015,7 +1015,7 @@ struct osm_mgrp *osm_get_mgrp_by_mgid(IN osm_subn_t * subn, IN ib_gid_t * mgid);
>   */
>   static inline struct osm_mgrp_box *osm_get_mbox_by_mlid(osm_subn_t const *p_subn, ib_net16_t mlid)
>   {
> -	return p_subn->mboxes[cl_ntoh16(mlid) - IB_LID_MCAST_START_HO];
> +	return (struct osm_mgrp_box *)p_subn->mboxes[cl_ntoh16(mlid) - IB_LID_MCAST_START_HO];
>   }
>   /*
>   * PARAMETERS

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
