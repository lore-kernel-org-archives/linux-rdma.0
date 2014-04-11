From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Clean index map on exit
Date: Fri, 11 Apr 2014 19:06:10 +0200
Message-ID: <1397235970.29001.23.camel@localhost.localdomain>
References: <EB3C2705-3925-49DD-8DB2-07BAE9E60A05@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EB3C2705-3925-49DD-8DB2-07BAE9E60A05-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hannes Weisbach <hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Le vendredi 11 avril 2014 =C3=A0 18:58 +0200, Hannes Weisbach a =C3=A9c=
rit :
> This patch adds the function idm_free() to free all entries of an ind=
ex
> map. A call to this function is added in the ucma_cleanup destructor.
> The ucma_idm struct index_map is cleaned.
>=20

Please explain the purpose: what's your goal ?

> Signed-off-by: Hannes Weisbach <hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>
> ---
>  src/cma.c     | 1 +
>  src/indexer.c | 8 ++++++++
>  src/indexer.h | 1 +
>  3 files changed, 10 insertions(+)
>=20
> diff --git a/src/cma.c b/src/cma.c
> index 0cf4203..a533bf9 100644
> --- a/src/cma.c
> +++ b/src/cma.c
> @@ -139,6 +139,7 @@ static void ucma_cleanup(void)
>  			ibv_close_device(cma_dev_array[cma_dev_cnt].verbs);
>  		}
> =20
> +		idm_free(&ucma_idm);
>  		fastlock_destroy(&idm_lock);
>  		free(cma_dev_array);
>  		cma_dev_cnt =3D 0;
> diff --git a/src/indexer.c b/src/indexer.c
> index c8e8bce..4d1fd77 100644
> --- a/src/indexer.c
> +++ b/src/indexer.c
> @@ -164,3 +164,11 @@ void *idm_clear(struct index_map *idm, int index=
)
>  	entry[idx_entry_index(index)] =3D NULL;
>  	return item;
>  }
> +
> +void idm_free(struct index_map *idm)
> +{
> +	size_t i;
> +	for (i =3D 0; i < IDX_ARRAY_SIZE; i++) {
> +	free(idm->array[i]);
> +	}
> +}

Is the array always full ? is the maximum index of the array
IDX_ARRAY_SIZE or could it be lower ?

And what about idm, is it free()'d somewhere else ?

> diff --git a/src/indexer.h b/src/indexer.h
> index 0c5f388..829d46b 100644
> --- a/src/indexer.h
> +++ b/src/indexer.h
> @@ -89,6 +89,7 @@ struct index_map
> =20
>  int idm_set(struct index_map *idm, int index, void *item);
>  void *idm_clear(struct index_map *idm, int index);
> +void idm_free(struct index_map *idm);
> =20
>  static inline void *idm_at(struct index_map *idm, int index)
>  {

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
