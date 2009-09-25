From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_ucast_lash: fix use after free bug
Date: Fri, 25 Sep 2009 19:11:31 -0400
Message-ID: <f0e08f230909251611l52971e2bwe65d269c9813f6e@mail.gmail.com>
References: <1251486496-24812-1-git-send-email-jaschut@sandia.gov>
	 <1251486496-24812-2-git-send-email-jaschut@sandia.gov>
	 <20090922185014.GF24398@me>
	 <1253651343.4776.1125.camel@sale659.sandia.gov>
	 <20090925135256.GE26931@me> <20090925145045.GF26931@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090925145045.GF26931@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: OpenIB <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/25/09, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
>
> When LASH runs its switch structures cleanup OpenSM can rediscover a
> subnet and 'p_sw' pointer may refer already freed memory, so don't touch
> it, just free our own stuff. (Note also that for valids OpenSM switches
> objects' 'priv' pointers are cleared on lash_cleanup()).
>
> Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>

Tested-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

> ---
>  opensm/opensm/osm_ucast_lash.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
>
> diff --git a/opensm/opensm/osm_ucast_lash.c b/opensm/opensm/osm_ucast_lash.c
> index dbc6bcc..3c424cb 100644
> --- a/opensm/opensm/osm_ucast_lash.c
> +++ b/opensm/opensm/osm_ucast_lash.c
> @@ -628,8 +628,7 @@ static switch_t *switch_create(lash_t * p_lash, unsigned
> id, osm_switch_t * p_sw
>  	}
>
>  	sw->p_sw = p_sw;
> -	if (p_sw)
> -		p_sw->priv = sw;
> +	p_sw->priv = sw;
>
>  	if (osm_mesh_node_create(p_lash, sw)) {
>  		free(sw->dij_channels);
> @@ -644,8 +643,6 @@ static void switch_delete(lash_t *p_lash, switch_t * sw)
>  {
>  	if (sw->dij_channels)
>  		free(sw->dij_channels);
> -	if (sw->p_sw)
> -		sw->p_sw->priv = NULL;
>  	free(sw);
>  }
>
> --
> 1.6.5.rc1
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
