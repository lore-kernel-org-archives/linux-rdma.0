From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH] IB/core: Avoid crash on pkey enforcement failed in
 received MADs
Date: Mon, 6 Nov 2017 17:12:26 +0000
Message-ID: <VI1PR0502MB300832C02DA8288A6CD55BCDD1500@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <1509463998-49670-1-git-send-email-parav@mellanox.com>
 <VI1PR0502MB3008E61E5EBFA422FAF52674D15D0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20171103202136.GJ16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171103202136.GJ16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> Sent: Friday, November 03, 2017 3:22 PM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [PATCH] IB/core: Avoid crash on pkey enforcement failed in
> received MADs
>=20
> > > Fixes: 47a2b338fe63 ("IB/core: Enforce security on management
> > > datagrams")
> > > Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Reported-by: Chris Blake <chrisrblake93-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > ---
> >
> > I think this is needed for 4.13+. I missed to CC stable in this patch.
> > Shall I resend with Cc: or?
>=20
> I believe that Doug will add it.
>=20
Ok. Thanks.

> By the way, did you find the root cause of why security check failed and =
we
> entered into that path?
>=20
I believe Dan replied in the other thread.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
