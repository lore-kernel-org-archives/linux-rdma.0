From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] srp_daemon: Use consistent format when
 printing LID
Date: Thu, 13 Apr 2017 15:29:55 +0000
Message-ID: <1492097392.3298.6.camel@sandisk.com>
References: <f6f32353-bdcc-6dfa-bf52-1b03ebab1eee@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f6f32353-bdcc-6dfa-bf52-1b03ebab1eee-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Content-ID: <2AEB926F87ABB741AA06D3F36FE88CB7-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-04-13 at 10:48 -0400, Hal Rosenstock wrote:
> %d is not good as LIDs above 32K print as negative numbers.
> %#x seems to be the right choice here; %u was used by IB
> management tools for unicast LID printing.

Hello Hal,

Although the patch itself looks fine to me: LIDs are converted from network
to host format using be16toh(). That function returns an unsigned 16-bit
number. These numbers are converted to type "int" before pr_err() is called=
.
The type "int" is at least 32 bits on all architectures supported by Linux.
So how could using %d result in a negative number being printed?

> diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
> index 59a6137..4d8476e 100644
> --- a/srp_daemon/srp_daemon.c
> +++ b/srp_daemon/srp_daemon.c
> @@ -632,7 +632,7 @@ recv:
>  			ret =3D umad_status(in_mad);
>  			if (ret) {
>  				pr_err(
> -					"bad MAD status (%u) from lid %d\n",
> +					"bad MAD status (%u) from lid %#x\n",
>  					ret, (uint16_t) be16toh(out_mad->hdr.addr.lid));
>  				return -ret;

If you have to repost this patch, please remove the (uint16_t) cast since i=
t's
superfluous.

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
