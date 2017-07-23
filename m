From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 7/9] IB/core: Allow QP state transition from
 reset to error
Date: Sun, 23 Jul 2017 10:39:05 +0300
Message-ID: <20170723073905.GE3259@mtr-leonro.local>
References: <20170530000314.534.72983.stgit@scvm10.sc.intel.com>
 <20170530002032.534.25061.stgit@scvm10.sc.intel.com>
 <20170530054609.GG17751@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yIMHf/Pa6CzSkARF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170530054609.GG17751-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--yIMHf/Pa6CzSkARF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 30, 2017 at 08:46:09AM +0300, Leon Romanovsky wrote:
> On Mon, May 29, 2017 at 05:20:53PM -0700, Dennis Dalessandro wrote:
> > From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > Playing with IP-O-IB interface can trigger a warning message:
> > "ib0: Failed to modify QP to ERROR state" to be logged.
> > This happens when the QP is in IB_QPS_RESET state and the stack
> > is trying to transition it to IB_QPS_ERR state in ipoib_ib_dev_stop().
> >
> > According to the IB spec, Table 91 - "QP State Transition Properties"
> > it looks like the transition from reset to error is valid:
> >
> > Transition: Any State to Error
> > Required Attributes: None
> > Optional Attributes: None allowed
> > Actions: Queue processing is stopped. Work Requests pending or in
> > process are completed in error, when possible.
> >
> > This patch allows the transition and quiets the message.
> >
> > Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
>
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Doug,

After digging more with Erez's help, it looks like the sentence "it
looks like the transition from reset to error is valid:" is not correct.

According to the InfiniBandTM Architecture Release 1.3, Figure 126 QP/EE Context
State Diagram - transition to error from reset is not valid.

The quote from the spec:
"An error can be forced from any state, except Reset, with the Modify QP/EE Verb."

I'll send revert patch along with proper fix.

Thanks

--yIMHf/Pa6CzSkARF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll0UpkACgkQ5GN7iDZy
WKeKHhAAn2jcLLUGV6F0AFpWh6hPFkzoUGMajpHEflmbVRy53cHIxJx5G8zNKVXU
rUu7r1AWhdGQxCh2U8TuxCqRY2vOdDruGPejyOv7UZeP0YuYb/4ZR20EMKK9U/ix
VXJFVz9BIf98eUAfU9jvZx3MCH7YlLvC4355dUUB4LO3AsRNgiOjCq7kPl27PQjh
Z+5kh8o17PuvwUW88yoUUJFXg4DVmI4aCFmJyXg2ehXfYaaqSaxJeY99Tga0O4CO
iIKfZ3xbOGW9TSwlgwZx+k/1QQGhm6nm8rppWfHCQmBI+seT2PpvcvOZJP3TAqA9
Sg6SRuT5RXfXxxLAv8ULz7QNtrHkBsmJLUEMulgLVVR/7fbZjtAQSUjYnbxds/5C
dUJnWFPnyt9Ej2rAEgGgE5/KWuMLuVqBKM5iSAfSrkLLSdxNbmUxcgb7xAuO7/Tf
pQjkzQ0IO5JcCfJgRDG8n7v573yvnYYX8MVm8P5NtpXAMJdYReirb7Y5KGprsIbK
ib7x3Or5LzD0+EFUucuePVjS9fHtXVCb037apQs/5QpWGAt6m6xDGR6btjTq03Xn
cd8mU4Nr2HNje1zeIQdQc93NXryLrXTvAGI8Ph6JR5HTTgHEotao0lF4mjApFyS3
u1s9Abbbrqzmqfbk2frB+/DD6EtoRgOayLWdHzWlE6BUE79NWq8=
=7WXQ
-----END PGP SIGNATURE-----

--yIMHf/Pa6CzSkARF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
