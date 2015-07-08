From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.2 1/1] RDMA/core: Fixes for port mapper client registration
Date: Wed, 08 Jul 2015 18:42:33 -0400
Message-ID: <559DA759.5040007@redhat.com>
References: <20150702174744.GA3804@TENIKOLO-MOBL2>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3cPFfVjTvDnNm3kNddSm9smuNlAMv7K0t"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150702174744.GA3804@TENIKOLO-MOBL2>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3cPFfVjTvDnNm3kNddSm9smuNlAMv7K0t
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/02/2015 01:47 PM, Tatyana Nikolova wrote:
> Fixes to allow clients to make remove mapping requests, after
> they have provided the user space service with the mapping
> information, they are using when the service is restarted.
>=20
> 1) Adding IWPM_REG_VALID, IWPM_REG_INCOMPL and IWPM_REG_UNDEF
>    registration types for the port mapper clients and functions
>    to set/check the registration type.
> 2) If the port mapper user space service is not available to register
>    the client, then its registration stays IWPM_REG_UNDEF and the
>    registration isn't checked until the service becomes available
>    (no mappings are possible, if the user space service isn't running).=

> 3) After the service is restarted, the user space port mapper pid is se=
t
>    to valid and the client registration is set to IWPM_REG_INCOMPL
>    to allow the client to make remove mapping requests.
>=20
> Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/core/iwpm_msg.c  |   33 ++++++++++++++++-----------=
------
>  drivers/infiniband/core/iwpm_util.c |   12 ++++++++++--
>  drivers/infiniband/core/iwpm_util.h |   28 ++++++++++++++++++++++-----=
-
>  3 files changed, 48 insertions(+), 25 deletions(-)

Thanks, applied.

>=20
> diff --git a/drivers/infiniband/core/iwpm_msg.c b/drivers/infiniband/co=
re/iwpm_msg.c
> index e6ffa2e..22a3abe 100644
> --- a/drivers/infiniband/core/iwpm_msg.c
> +++ b/drivers/infiniband/core/iwpm_msg.c
> @@ -67,7 +67,8 @@ int iwpm_register_pid(struct iwpm_dev_data *pm_msg, u=
8 nl_client)
>  		err_str =3D "Invalid port mapper client";
>  		goto pid_query_error;
>  	}
> -	if (iwpm_registered_client(nl_client))
> +	if (iwpm_check_registration(nl_client, IWPM_REG_VALID) ||
> +			iwpm_user_pid =3D=3D IWPM_PID_UNAVAILABLE)
>  		return 0;
>  	skb =3D iwpm_create_nlmsg(RDMA_NL_IWPM_REG_PID, &nlh, nl_client);
>  	if (!skb) {
> @@ -106,7 +107,6 @@ int iwpm_register_pid(struct iwpm_dev_data *pm_msg,=
 u8 nl_client)
>  	ret =3D ibnl_multicast(skb, nlh, RDMA_NL_GROUP_IWPM, GFP_KERNEL);
>  	if (ret) {
>  		skb =3D NULL; /* skb is freed in the netlink send-op handling */
> -		iwpm_set_registered(nl_client, 1);
>  		iwpm_user_pid =3D IWPM_PID_UNAVAILABLE;
>  		err_str =3D "Unable to send a nlmsg";
>  		goto pid_query_error;
> @@ -144,12 +144,12 @@ int iwpm_add_mapping(struct iwpm_sa_data *pm_msg,=
 u8 nl_client)
>  		err_str =3D "Invalid port mapper client";
>  		goto add_mapping_error;
>  	}
> -	if (!iwpm_registered_client(nl_client)) {
> +	if (!iwpm_valid_pid())
> +		return 0;
> +	if (!iwpm_check_registration(nl_client, IWPM_REG_VALID)) {
>  		err_str =3D "Unregistered port mapper client";
>  		goto add_mapping_error;
>  	}
> -	if (!iwpm_valid_pid())
> -		return 0;
>  	skb =3D iwpm_create_nlmsg(RDMA_NL_IWPM_ADD_MAPPING, &nlh, nl_client);=

>  	if (!skb) {
>  		err_str =3D "Unable to create a nlmsg";
> @@ -214,12 +214,12 @@ int iwpm_add_and_query_mapping(struct iwpm_sa_dat=
a *pm_msg, u8 nl_client)
>  		err_str =3D "Invalid port mapper client";
>  		goto query_mapping_error;
>  	}
> -	if (!iwpm_registered_client(nl_client)) {
> +	if (!iwpm_valid_pid())
> +		return 0;
> +	if (!iwpm_check_registration(nl_client, IWPM_REG_VALID)) {
>  		err_str =3D "Unregistered port mapper client";
>  		goto query_mapping_error;
>  	}
> -	if (!iwpm_valid_pid())
> -		return 0;
>  	ret =3D -ENOMEM;
>  	skb =3D iwpm_create_nlmsg(RDMA_NL_IWPM_QUERY_MAPPING, &nlh, nl_client=
);
>  	if (!skb) {
> @@ -288,12 +288,12 @@ int iwpm_remove_mapping(struct sockaddr_storage *=
local_addr, u8 nl_client)
>  		err_str =3D "Invalid port mapper client";
>  		goto remove_mapping_error;
>  	}
> -	if (!iwpm_registered_client(nl_client)) {
> +	if (!iwpm_valid_pid())
> +		return 0;
> +	if (iwpm_check_registration(nl_client, IWPM_REG_UNDEF)) {
>  		err_str =3D "Unregistered port mapper client";
>  		goto remove_mapping_error;
>  	}
> -	if (!iwpm_valid_pid())
> -		return 0;
>  	skb =3D iwpm_create_nlmsg(RDMA_NL_IWPM_REMOVE_MAPPING, &nlh, nl_clien=
t);
>  	if (!skb) {
>  		ret =3D -ENOMEM;
> @@ -388,7 +388,7 @@ int iwpm_register_pid_cb(struct sk_buff *skb, struc=
t netlink_callback *cb)
>  	pr_debug("%s: iWarp Port Mapper (pid =3D %d) is available!\n",
>  			__func__, iwpm_user_pid);
>  	if (iwpm_valid_client(nl_client))
> -		iwpm_set_registered(nl_client, 1);
> +		iwpm_set_registration(nl_client, IWPM_REG_VALID);
>  register_pid_response_exit:
>  	nlmsg_request->request_done =3D 1;
>  	/* always for found nlmsg_request */
> @@ -644,7 +644,6 @@ int iwpm_mapping_info_cb(struct sk_buff *skb, struc=
t netlink_callback *cb)
>  {
>  	struct nlattr *nltb[IWPM_NLA_MAPINFO_REQ_MAX];
>  	const char *msg_type =3D "Mapping Info response";
> -	int iwpm_pid;
>  	u8 nl_client;
>  	char *iwpm_name;
>  	u16 iwpm_version;
> @@ -669,14 +668,14 @@ int iwpm_mapping_info_cb(struct sk_buff *skb, str=
uct netlink_callback *cb)
>  				__func__, nl_client);
>  		return ret;
>  	}
> -	iwpm_set_registered(nl_client, 0);
> +	iwpm_set_registration(nl_client, IWPM_REG_INCOMPL);
>  	atomic_set(&echo_nlmsg_seq, cb->nlh->nlmsg_seq);
> +	iwpm_user_pid =3D cb->nlh->nlmsg_pid;
>  	if (!iwpm_mapinfo_available())
>  		return 0;
> -	iwpm_pid =3D cb->nlh->nlmsg_pid;
>  	pr_debug("%s: iWarp Port Mapper (pid =3D %d) is available!\n",
> -		 __func__, iwpm_pid);
> -	ret =3D iwpm_send_mapinfo(nl_client, iwpm_pid);
> +		 __func__, iwpm_user_pid);
> +	ret =3D iwpm_send_mapinfo(nl_client, iwpm_user_pid);
>  	return ret;
>  }
>  EXPORT_SYMBOL(iwpm_mapping_info_cb);
> diff --git a/drivers/infiniband/core/iwpm_util.c b/drivers/infiniband/c=
ore/iwpm_util.c
> index a626795..5fb089e 100644
> --- a/drivers/infiniband/core/iwpm_util.c
> +++ b/drivers/infiniband/core/iwpm_util.c
> @@ -78,6 +78,7 @@ init_exit:
>  	mutex_unlock(&iwpm_admin_lock);
>  	if (!ret) {
>  		iwpm_set_valid(nl_client, 1);
> +		iwpm_set_registration(nl_client, IWPM_REG_UNDEF);
>  		pr_debug("%s: Mapinfo and reminfo tables are created\n",
>  				__func__);
>  	}
> @@ -106,6 +107,7 @@ int iwpm_exit(u8 nl_client)
>  	}
>  	mutex_unlock(&iwpm_admin_lock);
>  	iwpm_set_valid(nl_client, 0);
> +	iwpm_set_registration(nl_client, IWPM_REG_UNDEF);
>  	return 0;
>  }
>  EXPORT_SYMBOL(iwpm_exit);
> @@ -397,17 +399,23 @@ void iwpm_set_valid(u8 nl_client, int valid)
>  }
> =20
>  /* valid client */
> -int iwpm_registered_client(u8 nl_client)
> +u32 iwpm_get_registration(u8 nl_client)
>  {
>  	return iwpm_admin.reg_list[nl_client];
>  }
> =20
>  /* valid client */
> -void iwpm_set_registered(u8 nl_client, int reg)
> +void iwpm_set_registration(u8 nl_client, u32 reg)
>  {
>  	iwpm_admin.reg_list[nl_client] =3D reg;
>  }
> =20
> +/* valid client */
> +u32 iwpm_check_registration(u8 nl_client, u32 reg)
> +{
> +	return (iwpm_get_registration(nl_client) & reg);
> +}
> +
>  int iwpm_compare_sockaddr(struct sockaddr_storage *a_sockaddr,
>  				struct sockaddr_storage *b_sockaddr)
>  {
> diff --git a/drivers/infiniband/core/iwpm_util.h b/drivers/infiniband/c=
ore/iwpm_util.h
> index ee2d9ff..b7b9e19 100644
> --- a/drivers/infiniband/core/iwpm_util.h
> +++ b/drivers/infiniband/core/iwpm_util.h
> @@ -58,6 +58,10 @@
>  #define IWPM_PID_UNDEFINED     -1
>  #define IWPM_PID_UNAVAILABLE   -2
> =20
> +#define IWPM_REG_UNDEF          0x01
> +#define IWPM_REG_VALID          0x02
> +#define IWPM_REG_INCOMPL        0x04
> +
>  struct iwpm_nlmsg_request {
>  	struct list_head    inprocess_list;
>  	__u32               nlmsg_seq;
> @@ -88,7 +92,7 @@ struct iwpm_admin_data {
>  	atomic_t refcount;
>  	atomic_t nlmsg_seq;
>  	int      client_list[RDMA_NL_NUM_CLIENTS];
> -	int      reg_list[RDMA_NL_NUM_CLIENTS];
> +	u32      reg_list[RDMA_NL_NUM_CLIENTS];
>  };
> =20
>  /**
> @@ -159,19 +163,31 @@ int iwpm_valid_client(u8 nl_client);
>  void iwpm_set_valid(u8 nl_client, int valid);
> =20
>  /**
> - * iwpm_registered_client - Check if the port mapper client is registe=
red
> + * iwpm_check_registration - Check if the client registration
> + *			      matches the given one
>   * @nl_client: The index of the netlink client
> + * @reg: The given registration type to compare with
>   *
>   * Call iwpm_register_pid() to register a client
> + * Returns true if the client registration matches reg,
> + * otherwise returns false
> + */
> +u32 iwpm_check_registration(u8 nl_client, u32 reg);
> +
> +/**
> + * iwpm_set_registration - Set the client registration
> + * @nl_client: The index of the netlink client
> + * @reg: Registration type to set
>   */
> -int iwpm_registered_client(u8 nl_client);
> +void iwpm_set_registration(u8 nl_client, u32 reg);
> =20
>  /**
> - * iwpm_set_registered - Set the port mapper client to registered or n=
ot
> + * iwpm_get_registration
>   * @nl_client: The index of the netlink client
> - * @reg: 1 if registered or 0 if not
> + *
> + * Returns the client registration type
>   */
> -void iwpm_set_registered(u8 nl_client, int reg);
> +u32 iwpm_get_registration(u8 nl_client);
> =20
>  /**
>   * iwpm_send_mapinfo - Send local and mapped IPv4/IPv6 address info of=

>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--3cPFfVjTvDnNm3kNddSm9smuNlAMv7K0t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVnadaAAoJELgmozMOVy/dGDgP/R4FwAXoTEQqbH9SPbX8IQKZ
TJkK0x5Dyxe4tM4mf5DEjJU/EXjVKxQeFkmcESuBbWU+OIt0OyUHgAezBOV4ua+o
HLoeAr6RSVtKGHtyJP03aSeOjdX3qoZFZNzytYbH7MG0fH5+DU3gsCJvaMjQfjdE
fY+TIW7/jwfxRxlaPOk89+n3GEmAcwysGQpbfw4g9xmsCwJ8hqm4IthTV43Ei1Im
SuiI/UUnC+WjUAeOIDGEuw91U8mxwWf0xlQq98iMM1pySSGM3XoF25Bg9Fc/6b1z
gXg0NKqJsI1TG6dJKlIx4wb+NjoV9dO6B/nwKwaeBTIWdE4R72NSCc78v2eirLDT
UwXwx6itBLuh9ezGoN0JyaGEravaRBx8cK/4C5xstOPcGaMo3oQmtERZ25lBp5Zf
1/S9p1SUYXntFPtUSYygyRpOCKlb6fvLxosJVUmFhZOcKpzISxUq5RRalENyQ7N+
PaORGOidRpfls2UkUEC0BraQ6XCsZMdZh01LroKGemwjPHqSjDOd13teTmtuQzl0
xaY86d/jYeU9Jv2fuhKqcQmnm7uJt+zLPrLYo3cFq4PmSUCvFOQNJQ3r0dgYTsIK
93wX9T5vRoiDgRrsOPYRdVq+V8rJVC45Oxj7S2rAyDHhdKdNce3H7uyXL7takRPS
hFWO7Rl1b+E8FAm9O/o2
=aqva
-----END PGP SIGNATURE-----

--3cPFfVjTvDnNm3kNddSm9smuNlAMv7K0t--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
