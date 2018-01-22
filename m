From: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [RFC rdma-core 2/2] verbs: Introduce non-contiguous memory
 registration
Date: Mon, 22 Jan 2018 15:59:51 +0000
Message-ID: <VI1PR05MB1278C4C4FF78B4B1A551252EB9EC0@VI1PR05MB1278.eurprd05.prod.outlook.com>
References: <1515088046-26605-1-git-send-email-alexma@mellanox.com>
 <1515088046-26605-2-git-send-email-alexma@mellanox.com>
 <20180111122206.GB2800@yuvallap> <20180111164455.GA1309@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111164455.GA1309-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Jason Gunthorpe
> Sent: Thursday, January 11, 2018 6:45 PM
> To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Cc: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [RFC rdma-core 2/2] verbs: Introduce non-contiguous memory
> registration
>=20
> On Thu, Jan 11, 2018 at 02:22:07PM +0200, Yuval Shaia wrote:
> > > +The following code example demonstrates non-contiguous memory
> > > +registration, by combining two contiguous regions, along with the
> WR-based completion semantic:
> > > +.PP
> > > +.nf
> > > +mr1 =3D ibv_reg_mr(pd, addr1, len1, 0); if (!mr1) {
> > > +        fprintf(stderr, "Failed to create MR #1\en");
> > > +        return 1;
> > > +}
> > > +
> > > +mr2 =3D ibv_reg_mr(pd, addr2, len2, 0); if (!mr2) {
> > > +        fprintf(stderr, "Failed to create MR #2\en");
> > > +        return 1;
> > > +}
> >
> > So, to register non-contiguous 512 random buffers i would have to
> > create
> > 512 MRs?


I think typically if you have a large amount of buffers - it would be locat=
ed in fairly close proximity, so you'd prefer one MR to cover all of them a=
nd the SGEs will only differ in base address.

Are you proposing the function also replaces ibv_reg_mr() if the user passe=
s multiple unregistered regions?
I could see the benefit, but then we'd require additional parameters (i.e. =
send_flags) and those MRs couldn't be reused (otherwise need to add output =
pointers for resulting MRs).
The benefit will probably not be latency, though, since IIRC the MR creatio=
n can't really be parallelized.
Yuval - are you aware of a scenario implementing a high amount of ibv_reg_m=
r() calls?

>=20
> That is a fair point - I wonder if some of these API should have an
> option to accept a pointer directly? Maybe the driver requires a MR but
> we don't need that as an the API?
>=20
> Particularly the _sg one..
>=20
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
