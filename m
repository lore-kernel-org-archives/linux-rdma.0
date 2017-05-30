From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 7/9] IB/core: Allow QP state transition from
 reset to error
Date: Tue, 30 May 2017 08:46:09 +0300
Message-ID: <20170530054609.GG17751@mtr-leonro.local>
References: <20170530000314.534.72983.stgit@scvm10.sc.intel.com>
 <20170530002032.534.25061.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="C311HLcnHV2CzHlo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170530002032.534.25061.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--C311HLcnHV2CzHlo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 29, 2017 at 05:20:53PM -0700, Dennis Dalessandro wrote:
> From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Playing with IP-O-IB interface can trigger a warning message:
> "ib0: Failed to modify QP to ERROR state" to be logged.
> This happens when the QP is in IB_QPS_RESET state and the stack
> is trying to transition it to IB_QPS_ERR state in ipoib_ib_dev_stop().
>
> According to the IB spec, Table 91 - "QP State Transition Properties"
> it looks like the transition from reset to error is valid:
>
> Transition: Any State to Error
> Required Attributes: None
> Optional Attributes: None allowed
> Actions: Queue processing is stopped. Work Requests pending or in
> process are completed in error, when possible.
>
> This patch allows the transition and quiets the message.
>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--C311HLcnHV2CzHlo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlktByEACgkQ5GN7iDZy
WKcQ9BAArofoqI2zegGBxVtwMnKFKjZH34jvUCerukW6GvJO0s+Q3aXHxEutQzq2
JqQQBGjJr+6xQT3T7eZoa9+sKVEOdUCAcDC8kLWljj3ayFWZ2xS7VEToxnYvqgaa
lKqzizKf3w0JjtQ0er1QL7Ce1opQ95ZViYeezgDxVECdFNCTbxaRHQLtXomkVMni
4BJq4xpmxKymWiRUzBPek4uRCgS4Yli//s0jjssEd1PlcsHRHSG2Cji588Qm/1Sv
tFb/XXOvsClQ5OCWJxyrE/Ojhi1GoQfI9F/CvFDo7v9/hZRNpv5KHRpvIHmQ3XiG
BEMVuBjzWRpVZjNCiVZOd87NaGo8Ea+U5ZrSj/JOltsvg9OeRKliyNQhGbPkfgZ9
L45KjIi2Yef8FovGbHu4b1cKa9nNevY3zGP/wEQQhV+zXZ0yAP55RI6VKK1vJ+ig
JBSsRLyik8Kvp9PtpBvhuGpJ42+yP70+eM17Lq5T6/QESbZMN2Lx3FBsta4ito/4
n5BZlPUuTgW3/QfiAfIFyQ4cW9fxf7dLZuenHO1QO8BnUdW7gdpeZKQV79TF5Mk2
f6QSnE6MsjNxasEXQJwImPhQ4rK8E6gzkGhJ0n8+v9ANsfIFX0nPfANOv0Fl/4Gw
JhfI23bWbRakEbM1QVL72aGyT1ZnEehMa3MQY+YMdyqxdF0flKg=
=4LJU
-----END PGP SIGNATURE-----

--C311HLcnHV2CzHlo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
