From: Zohar Ben Aharon <zoharb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH perftest] Avoid configuring the MRs with 1's
Date: Wed, 1 Mar 2017 09:03:12 +0000
Message-ID: <AM5PR0501MB2532432B629529D15A6A88C1A9290@AM5PR0501MB2532.eurprd05.prod.outlook.com>
References: <1488111691-23620-1-git-send-email-Ram.Amrani@cavium.com>
 <20170228200040.GD2754@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170228200040.GD2754-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Will push it by the EOW

-----Original Message-----
From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]=20
Sent: Tuesday, February 28, 2017 10:01 PM
To: Zohar Ben Aharon <zoharb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Ram Amrani <Ram.Amrani@cavium.c=
om>
Cc: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Ariel.Elior=
@cavium.com
Subject: Re: [PATCH perftest] Avoid configuring the MRs with 1's

On Sun, Feb 26, 2017 at 02:21:31PM +0200, Ram Amrani wrote:
> Avoid setting the value '1' in the MR. If this happens in a write=20
> latency test then the server will send two consecutive packets,=20
> regardless of the client's state. This can cause the application to=20
> hang - If the client reaches the busy-wait loop after the second write=20
> then it'll keep waiting for the value of the first write forever.
>
> Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  src/perftest_resources.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/src/perftest_resources.c b/src/perftest_resources.c index=20
> afae5f2..dc768c4 100755
> --- a/src/perftest_resources.c
> +++ b/src/perftest_resources.c
> @@ -1252,7 +1252,11 @@ int create_single_mr(struct pingpong_context *ctx,=
 struct perftest_parameters *u
>  	/* Initialize buffer with random numbers */
>  	srand(time(NULL));
>  	for (i =3D 0; i < ctx->buff_size; i++) {
> -		((char*)ctx->buf[qp_index])[i] =3D (char)rand();
> +		/* prevent the value 1 from being written into the buffer so in,
> +		 * e.g., write latency test, the server won't send two packets
> +		 * consecutively without receiving a packet from the client first.
> +		 */
> +		((char*)ctx->buf[qp_index])[i] =3D 2 + ((char)rand() % 255);
>  	}
>
>  	return 0;

Zohar?

> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=20
> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo=20
> info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
