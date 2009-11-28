From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] opensm/osm_db_files.c: add '/' path delimited
Date: Sat, 28 Nov 2009 08:35:29 -0800
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1912CC7DAF13@orsmsx501.amr.corp.intel.com>
References: <784A3771E5D143179461A7D5151AE78C@amr.corp.intel.com>
 <20091012215455.GK13830@me>
 <3F6F638B8D880340AB536D29CD4C1E1912C896BBDA@orsmsx501.amr.corp.intel.com>
 <20091128142342.GA16607@me> <20091128142626.GB16607@me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091128142626.GB16607@me>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sasha Khapyorsky wrote:
> Add '/' path delimiter unconditionally on file path generation.

Any chance you could make the path delimiter a #define so there is not an explicit Linux filesystem assumption?


>
> Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
>  opensm/opensm/osm_db_files.c |   14 ++++++--------
>  1 files changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/opensm/opensm/osm_db_files.c
> b/opensm/opensm/osm_db_files.c
> index ec7436e..5fd7c83 100644
> --- a/opensm/opensm/osm_db_files.c
> +++ b/opensm/opensm/osm_db_files.c
> @@ -195,7 +195,7 @@ osm_db_domain_t *osm_db_domain_init(IN osm_db_t *
>  p_db, IN char *domain_name) {
>       osm_db_domain_t *p_domain;
>       osm_db_domain_imp_t *p_domain_imp;
> -     int dir_name_len;
> +     size_t path_len;
>       osm_log_t *p_log = p_db->p_log;
>       FILE *p_file;
>
> @@ -209,16 +209,14 @@ osm_db_domain_t *osm_db_domain_init(IN osm_db_t
>           * p_db, IN char *domain_name) (osm_db_domain_imp_t *)
>       malloc(sizeof(osm_db_domain_imp_t)); CL_ASSERT(p_domain_imp !=
> NULL);
>
> -     dir_name_len = strlen(((osm_db_imp_t *)
> p_db->p_db_imp)->db_dir_name); +      path_len = strlen(((osm_db_imp_t *)
> p_db->p_db_imp)->db_dir_name) +           + strlen(domain_name) + 2;
>
>       /* set the domain file name */
> -     p_domain_imp->file_name =
> -         (char *)malloc(sizeof(char) * (dir_name_len) +
> strlen(domain_name) +
> -                        2);
> +     p_domain_imp->file_name = malloc(path_len);
>       CL_ASSERT(p_domain_imp->file_name != NULL);
> -     strcpy(p_domain_imp->file_name,
> -            ((osm_db_imp_t *) p_db->p_db_imp)->db_dir_name);
> -     strcat(p_domain_imp->file_name, domain_name);
> +     snprintf(p_domain_imp->file_name, path_len, "%s/%s",
> +              ((osm_db_imp_t *) p_db->p_db_imp)->db_dir_name, domain_name);
>
>       /* make sure the file exists - or exit if not writable */
>       p_file = fopen(p_domain_imp->file_name, "a+");

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
