From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH RESEND] infiniband:core:Add needed error path in
 cm_init_av_by_path
Date: Wed, 16 Dec 2015 11:26:39 +0100
Message-ID: <56713C5F.5020507@profitbricks.com>
References: <1450194724-7107-1-git-send-email-xerofoify@gmail.com>
 <5670420A.7040202@profitbricks.com>
 <20151215173022.GB25965@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151215173022.GB25965-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On 12/15/2015 06:30 PM, Jason Gunthorpe wrote:
> On Tue, Dec 15, 2015 at 05:38:34PM +0100, Michael Wang wrote:
>> The hop_limit is only suggest that the package allowed to be
>> routed, not have to, correct?
>=20
> If the hop limit is >=3D 2 (?) then the GRH is mandatory. The
> SM will return this information in the PathRecord if it determines a
> GRH is required. The whole stack follows this protocol.
>=20
> The GRH is optional for in-subnet communications.

Thanks for the explain :-)

I've rechecked the ib_init_ah_from_path() again, and found it
still set IB_AH_GRH when the GID cache missing, but with:

  grh.sgid_index =3D 0
  grh.flow_label =3D 0
  grh.hop_limit  =3D 0
  grh.traffic_class =3D 0

Not sure if it's just coincidence=EF=BC=8C hop_limit is 0, so router
will discard the pkg and GRH won't be used, the transaction in
subnet still works.

Could this by designed as an optimization for the case like when
SM reassigning the GID?

BTW, cma_sidr_rep_handler() also call ib_init_ah_from_path() with out
a check on return.

Regards,
Michael Wang

>=20
> Jason
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
