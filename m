From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/8] mlx5: Avoid sparse complaints about !!
Date: Thu, 13 Jul 2017 17:52:06 +0000
Message-ID: <1499968325.2740.12.camel@wdc.com>
References: <1499894262-10761-1-git-send-email-jgunthorpe@obsidianresearch.com>
         <1499894262-10761-5-git-send-email-jgunthorpe@obsidianresearch.com>
         <20170713075116.GA11233@infradead.org>
         <20170713172035.GB11069@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170713172035.GB11069-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <7FCBC87F74DE8F4196E9F15E9BFB8AC3-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-07-13 at 11:20 -0600, Jason Gunthorpe wrote:
> On Thu, Jul 13, 2017 at 12:51:16AM -0700, Christoph Hellwig wrote:
> > >  			if (qp->qp_cap_cache & MLX5_RX_CSUM_VALID)
> > > -				wc->wc_flags |=3D (!!(cqe->hds_ip_ext & MLX5_CQE_L4_OK) &
> > > -						 !!(cqe->hds_ip_ext & MLX5_CQE_L3_OK) &
> > > -						(get_cqe_l3_hdr_type(cqe) =3D=3D
> > > -						MLX5_CQE_L3_HDR_TYPE_IPV4)) <<
> > > -						IBV_WC_IP_CSUM_OK_SHIFT;
> > > +				wc->wc_flags |=3D
> > > +				    ((bool)(cqe->hds_ip_ext & MLX5_CQE_L4_OK) &
> > > +				     (bool)(cqe->hds_ip_ext & MLX5_CQE_L3_OK) &
> > > +				     (get_cqe_l3_hdr_type(cqe) =3D=3D
> > > +				      MLX5_CQE_L3_HDR_TYPE_IPV4))
> > > +				    << IBV_WC_IP_CSUM_OK_SHIFT;
> >=20
> > Meh.  This code is complete crap.  Please factor it out into a little
> > helper that mere humans can read first.  And then replace the odd ^ use=
d
> > as && with proper if constructs and all should make much more sense.
>=20
> As far as I could make out, this ugly thing is designed like this for
> performance.

Hello Jason,

How about using an expression like the below to avoid that branches get ins=
erted
for testing the MLX5_CQE_L4_OK and MLX5_CQE_L3_OK flags?

(cqe->hds_ip_ext & (MLX5_CQE_L4_OK | MLX5_CQE_L3_OK)) =3D=3D MLX5_CQE_L4_OK=
 | MLX5_CQE_L3_OK

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
