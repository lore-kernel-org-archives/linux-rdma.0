From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] Fix assorted memory leaks on error paths
Date: Thu, 26 May 2016 08:10:10 +0300
Message-ID: <20160526051010.GR25500@leon.nu>
References: <1463591267-29975-1-git-send-email-jarod@redhat.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FNX2SHge3qdlDajY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1463591267-29975-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--FNX2SHge3qdlDajY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 18, 2016 at 01:07:47PM -0400, Jarod Wilson wrote:
> Clang noticed that we might leak mcg_params.ib_devname in failure paths.
> There are additional leaks after fixing this initial one that it still
> reported, here's hoping I've got them all now...
>=20
>  1. perftest-3.0/src/send_lat.c:232:3: warning: Potential leak of memory =
pointed to by 'mcg_params.ib_devname'
>  #                 fprintf(stderr, " Couldn't get context for the device\=
n");
>  #                 ^
>  4. perftest-3.0/src/send_lat.c:203:6: note: Assuming 'ret_val' is 0
>  #         if (ret_val) {
>  #             ^~~~~~~
>  7. perftest-3.0/src/send_lat.c:203:2: note: Taking false branch
>  #         if (ret_val) {
>  #         ^
>  10. perftest-3.0/src/send_lat.c:209:5: note: Left side of '||' is false
>  #         if(user_param.use_xrc || user_param.connection_type =3D=3D DC)=
 {
>  #            ^
>  13. perftest-3.0/src/send_lat.c:209:2: note: Taking false branch
>  #         if(user_param.use_xrc || user_param.connection_type =3D=3D DC)=
 {
>  #         ^
>  16. perftest-3.0/src/send_lat.c:214:2: note: Taking false branch
>  #         if (user_param.connection_type =3D=3D RawEth) {
>  #         ^
>  19. perftest-3.0/src/send_lat.c:221:6: note: Assuming 'ib_dev' is non-nu=
ll
>  #         if (!ib_dev) {
>  #             ^~~~~~~
>  22. perftest-3.0/src/send_lat.c:221:2: note: Taking false branch
>  #         if (!ib_dev) {
>  #         ^
>  25. perftest-3.0/src/send_lat.c:226:2: note: Taking true branch
>  #         if (user_param.use_mcg)
>  #         ^
>  28. perftest-3.0/src/send_lat.c:227:3: note: Memory is allocated
>  #                 GET_STRING(mcg_params.ib_devname,ibv_get_device_name(i=
b_dev));
>  #                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~
>  31. perftest-3.0/src/perftest_parameters.h:217:3: note: expanded from ma=
cro 'GET_STRING'
>  # { ALLOCATE(orig,char,(strlen(temp) + 1)); strcpy(orig,temp); }
>  #   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>  34. perftest-3.0/src/perftest_parameters.h:212:20: note: expanded from m=
acro 'ALLOCATE'
>  # { if((var =3D (type*)malloc(sizeof(type)*(size))) =3D=3D NULL)        \
>  #                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>  37. perftest-3.0/src/send_lat.c:227:3: note: Taking false branch
>  38. perftest-3.0/src/perftest_parameters.h:217:3: note: expanded from ma=
cro 'GET_STRING'
>  # { ALLOCATE(orig,char,(strlen(temp) + 1)); strcpy(orig,temp); }
>  #   ^
>  41. perftest-3.0/src/perftest_parameters.h:212:3: note: expanded from ma=
cro 'ALLOCATE'
>  # { if((var =3D (type*)malloc(sizeof(type)*(size))) =3D=3D NULL)        \
>  #   ^
>  44. perftest-3.0/src/send_lat.c:231:2: note: Taking true branch
>  #         if (!ctx.context) {
>  #         ^
>  47. perftest-3.0/src/send_lat.c:232:3: note: Potential leak of memory po=
inted to by 'mcg_params.ib_devname'
>  #                 fprintf(stderr, " Couldn't get context for the device\=
n");
>  #                 ^
>  #   230|   	ctx.context =3D ibv_open_device(ib_dev);
>  #   231|   	if (!ctx.context) {
>  #   232|-> 		fprintf(stderr, " Couldn't get context for the device\n");
>  #   233|   		return 1;
>  #   234|   	}
>=20
> Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>=20
> fix fix
>=20
> Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  src/send_lat.c | 62 ++++++++++++++++++++++++++++++++++++----------------=
------
>  1 file changed, 39 insertions(+), 23 deletions(-)
>=20
> diff --git a/src/send_lat.c b/src/send_lat.c
> index bc194d8..e5beda9 100755
> --- a/src/send_lat.c
> +++ b/src/send_lat.c
> @@ -230,19 +230,19 @@ int main(int argc, char *argv[])
>  	ctx.context =3D ibv_open_device(ib_dev);
>  	if (!ctx.context) {
>  		fprintf(stderr, " Couldn't get context for the device\n");
> -		return 1;
> +		goto failure;
>  	}
> =20
>  	/* See if MTU and link type are valid and supported. */
>  	if (check_link(ctx.context,&user_param)) {
>  		fprintf(stderr, " Couldn't get context for the device\n");
> -		return FAILURE;
> +		goto failure;
>  	}
> =20
>  	/* copy the relevant user parameters to the comm struct + creating rdma=
_cm resources. */
>  	if (create_comm_struct(&user_comm,&user_param)) {
>  		fprintf(stderr," Unable to create RDMA_CM resources\n");
> -		return 1;
> +		goto failure;
>  	}
> =20
>  	if (user_param.output =3D=3D FULL_VERBOSITY && user_param.machine =3D=
=3D SERVER) {
> @@ -254,7 +254,7 @@ int main(int argc, char *argv[])
>  	/* Initialize the connection and print the local data. */
>  	if (establish_connection(&user_comm)) {
>  		fprintf(stderr," Unable to init the socket connection\n");
> -		return FAILURE;
> +		goto failure;
>  	}
> =20
>  	exchange_versions(&user_comm, &user_param);
> @@ -264,7 +264,7 @@ int main(int argc, char *argv[])
>  	/* See if MTU and link type are valid and supported. */
>  	if (check_mtu(ctx.context,&user_param, &user_comm)) {
>  		fprintf(stderr, " Couldn't get context for the device\n");
> -		return FAILURE;
> +		goto failure;
>  	}
> =20
>  	/* Print basic test information. */
> @@ -284,17 +284,17 @@ int main(int argc, char *argv[])
>  		if (user_param.machine =3D=3D CLIENT) {
>  			if (retry_rdma_connect(&ctx,&user_param)) {
>  				fprintf(stderr,"Unable to perform rdma_client function\n");
> -				return FAILURE;
> +				goto failure2;
>  			}
> =20
>  		} else {
>  			if (create_rdma_resources(&ctx,&user_param)) {
>  				fprintf(stderr," Unable to create the rdma_resources\n");
> -				return FAILURE;
> +				goto failure2;
>  			}
>  			if (rdma_server_connect(&ctx,&user_param)) {
>  				fprintf(stderr,"Unable to perform rdma_client function\n");
> -				return FAILURE;
> +				goto failure2;
>  			}
>  		}
> =20
> @@ -303,14 +303,14 @@ int main(int argc, char *argv[])
>  		/* create all the basic IB resources (data buffer, PD, MR, CQ and even=
ts channel) */
>  		if (ctx_init(&ctx,&user_param)) {
>  			fprintf(stderr, " Couldn't create IB resources\n");
> -			return FAILURE;
> +			goto failure2;
>  		}
>  	}
> =20
>  	/* Set up the Connection. */
>  	if (send_set_up_connection(&ctx,&user_param,my_dest,&mcg_params,&user_c=
omm)) {
>  		fprintf(stderr," Unable to set up socket connection\n");
> -		return 1;
> +		goto failure2;
>  	}
> =20
>  	for (i=3D0; i < user_param.num_of_qps; i++)
> @@ -322,7 +322,7 @@ int main(int argc, char *argv[])
>  		/* shaking hands and gather the other side info. */
>  		if (ctx_hand_shake(&user_comm,&my_dest[i],&rem_dest[i])) {
>  			fprintf(stderr,"Failed to exchange data between server and clients\n"=
);
> -			return 1;
> +			goto failure2;
>  		}
> =20
>  		ctx_print_pingpong_data(&rem_dest[i],&user_comm);
> @@ -332,7 +332,7 @@ int main(int argc, char *argv[])
>  		if (ctx_check_gid_compatibility(&my_dest[0], &rem_dest[0])) {
>  			fprintf(stderr,"\n Found Incompatibility issue with GID types.\n");
>  			fprintf(stderr," Please Try to use a different IP version.\n\n");
> -			return 1;
> +			goto failure2;
>  		}
>  	}
> =20
> @@ -346,7 +346,7 @@ int main(int argc, char *argv[])
>  			/* Request for Mcast group create registery in SM. */
>  			if (join_multicast_group(SUBN_ADM_METHOD_SET,&mcg_params)) {
>  				fprintf(stderr," Failed to Join Mcast request\n");
> -				return 1;
> +				goto failure;
>  			}
>  		}
> =20
> @@ -367,26 +367,26 @@ int main(int argc, char *argv[])
>  		/* Prepare IB resources for rtr/rts. */
>  		if (ctx_connect(&ctx,rem_dest,&user_param,my_dest)) {
>  			fprintf(stderr," Unable to Connect the HCA's through the link\n");
> -			return 1;
> +			goto failure2;
>  		}
>  	}
> =20
>  	/* shaking hands and gather the other side info. */
>  	if (ctx_hand_shake(&user_comm,&my_dest[0],&rem_dest[0])) {
>  		fprintf(stderr,"Failed to exchange data between server and clients\n");
> -		return 1;
> +		goto failure;
>  	}
> =20
>  	if (user_param.use_event) {
> =20
>  		if (ibv_req_notify_cq(ctx.send_cq, 0)) {
>  			fprintf(stderr, "Couldn't request RCQ notification\n");
> -			return 1;
> +			goto failure2;
>  		}
> =20
>  		if (ibv_req_notify_cq(ctx.recv_cq, 0)) {
>  			fprintf(stderr, "Couldn't request RCQ notification\n");
> -			return 1;
> +			goto failure;
>  		}
>  	}
>  	if (user_param.output =3D=3D FULL_VERBOSITY) {
> @@ -409,7 +409,7 @@ int main(int argc, char *argv[])
>  			/* Post receive recv_wqes fo current message size */
>  			if (ctx_set_recv_wqes(&ctx,&user_param)) {
>  				fprintf(stderr," Failed to post receive recv_wqes\n");
> -				return 1;
> +				goto failure2;
>  			}
> =20
>  			/* Sync between the client and server so the client won't send packets
> @@ -418,11 +418,15 @@ int main(int argc, char *argv[])
> =20
>  			if (ctx_hand_shake(&user_comm,&my_dest[0],&rem_dest[0])) {
>  				fprintf(stderr,"Failed to exchange data between server and clients\n=
");
> -				return 1;
> +				goto failure2;
>  			}
> =20
> -			if(run_iter_lat_send(&ctx, &user_param))
> +			if(run_iter_lat_send(&ctx, &user_param)) {
> +				free(my_dest);
> +				free(rem_dest);
> +				free(mcg_params.ib_devname);
>  				return 17;
> +			}
> =20
>  			user_param.test_type =3D=3D ITERATIONS ? print_report_lat(&user_param=
) : print_report_lat_duration(&user_param);
>  		}
> @@ -432,7 +436,7 @@ int main(int argc, char *argv[])
>  		/* Post recevie recv_wqes fo current message size */
>  		if (ctx_set_recv_wqes(&ctx,&user_param)) {
>  			fprintf(stderr," Failed to post receive recv_wqes\n");
> -			return 1;
> +			goto failure2;
>  		}
> =20
>  		/* Sync between the client and server so the client won't send packets
> @@ -441,11 +445,15 @@ int main(int argc, char *argv[])
> =20
>  		if (ctx_hand_shake(&user_comm,my_dest,rem_dest)) {
>  			fprintf(stderr,"Failed to exchange data between server and clients\n"=
);
> -			return 1;
> +			goto failure2;
>  		}
> =20
> -		if(run_iter_lat_send(&ctx, &user_param))
> +		if(run_iter_lat_send(&ctx, &user_param)) {
> +			free(my_dest);
> +			free(rem_dest);
> +			free(mcg_params.ib_devname);
>  			return 17;
> +		}
> =20
>  		user_param.test_type =3D=3D ITERATIONS ? print_report_lat(&user_param)=
 : print_report_lat_duration(&user_param);
>  	}
> @@ -460,4 +468,12 @@ int main(int argc, char *argv[])
>  	}
> =20
>  	return send_destroy_ctx(&ctx,&user_param,&mcg_params);
> +
> +failure2:

Where is "failure1" ?

> +	free(my_dest);
> +	free(rem_dest);
> +	destroy_ctx(&ctx,&user_param);
> +failure:
> +	free(mcg_params.ib_devname);
> +	return FAILURE;
>  }
> --=20
> 1.8.3.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--FNX2SHge3qdlDajY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXRoUyAAoJEORje4g2clinGSAP/0W5UxpYxp/TsdIoEgOJeXNz
Trq6dWvxasXBXrK4JpuCCGe26NV/GIW8XqfnoVVSveHv9gITwroIZVLcx4gdlwUg
PLskyD/yO+g7+aYGn+WwiV55w+kOPFD1mAx+VkOyTQwDIq7I3t/u16KH3TX1JUr8
fzhafqXm/NcgLeyx158tfwEIKBuOddGb5+QUwgkS2MalVsJF0cmXWYvoz1owSsiU
Q3bOt7KiNm3V7JdE/wKVLVqEdAfUjrgRUKy+o8+zfUtt13e6gEfZiCrT59IFoHC0
ErMZtfrQIzf4RpuxHcG+l/lAP0/KGPH4dsb4rFr1Is5Zqy7hOtrk7NTng7XGy8eH
Emwx5DOeZ6PAcjsyJWdJb4atz3EOD5s2hgeVmyZ1H0umoBXiu6JtLMk21NihPmnC
ECfvnCHSScGbKlG4ZZc3mfZwDv0uJqSqbNfJ89lMeE65yYU9VG88zQUm7eaH8HR8
AwTntyHjmsn9ebNhoWRbd7W41OVAEaaJFFCf0xQ22bENW+jJ387+p0xjlXrAZrZ9
oEvqefwZw/GTkAiL41KL9UOT+HhFlIbxN18OouakPJ5AbMifaFPnBFzfNk+lUNg/
bVlQv37FEcSfYgczABut1mCrIISEfVULOujqSu7MBxJlGVpwYnhHa0owAmuGbqip
ek2H3hgrqmqK+BS6Mj+O
=E/HY
-----END PGP SIGNATURE-----

--FNX2SHge3qdlDajY--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
