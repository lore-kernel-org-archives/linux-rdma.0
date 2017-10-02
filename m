From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] IB/opa_vnic: Add debugfs interface
Date: Mon, 2 Oct 2017 07:23:23 +0300
Message-ID: <20171002042323.GG2031@mtr-leonro.local>
References: <1506525977.33755.3.camel@redhat.com>
 <20170928184727.GA33282@knc-06.sc.intel.com>
 <20170928185753.GG2297@mtr-leonro.local>
 <20170928190502.GA33289@knc-06.sc.intel.com>
 <20170928193740.GH2297@mtr-leonro.local>
 <20170928200258.GA27343@obsidianresearch.com>
 <20170929054959.GJ2297@mtr-leonro.local>
 <cbb65789-2d1e-779e-77f8-55b435511069@intel.com>
 <20170929145950.GC2965@mtr-leonro.local>
 <20170929152707.GA34521@knc-06.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1giRMj6yz/+FOIRq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170929152707.GA34521-wPcXA7LoDC+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--1giRMj6yz/+FOIRq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 29, 2017 at 08:27:08AM -0700, Vishwanathapura, Niranjana wrote:
> You are putting a wrong interpretation to this patch.
> EM provides the encapsulation configuration as in the opa_vnic documentation.
> EM will be opensourced when it is ready (VNIC is development in progress).
>
> As mentioned, this patch is a simple *debug* hook to that encapsulation
> configuration and no more.
> That is why it is put under DEBUGFS.
>
> I do see valid reason in Jason's and your earlier comments that it should a
> formal support to the admins.
> But this patch was not mainly for that. I don't expect DEBUGFS to be turned
> on in all deployments.
> I understand the question whether or not this patch should be in the kernel
> tree.
> But it is a useful debug hook for debugging/triaging issues (similar to NIC
> having debug hook read/write some register), and convenient to have it
> available in the kernel than maintaining it separately.

I want to summarize the responses:
1. If you want to know (read) which vport is configured by EM, the
tracepoints/prints will be enough to achieve it and no need to provide
any debugfs.
2. If you want to debug and configure (write) the vport, you should answer on two
questions.
2.a. Will it be local change and won't be propagated to EM?
2.b. Will this change be propagated to EM?

Upstream is not a development playground and you should submit your code once
you think that it is ready. So we are assuming that VNIC is working and
you are interested to debug your EM and such code doesn't belong to the kernel.

If you still insist on 2.a, the solution should be in your company: add
debugfs locally, write tests, find and fix bugs and submit them to
upstream.

There is no need to add "one-time" interface to clean the code.

Thanks

>
> Niranjana
>
> > Thanks
>
>

--1giRMj6yz/+FOIRq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnRvzsACgkQ5GN7iDZy
WKfyDxAA0YT8Q6SkSdWVssQwSMYuA4hQENPROSO8KI6catEQgroVQmSe666cndO5
29z8oFIFvnJhweMbPPgKhy90MceKqWGnTj6rj3gGDwoILZeCbDeYhxxVUJjvoi7F
2XTf98p0qBEbMelKmCiyXCho4xUMil06Z5ZE4Uw+0HCiF6L5WYVx7szLqC4/twHj
ZMOAreK6LCTjSeUVTFeyrvD2p0oTyG79tx3JVfAK6Y2maqRe2BfSUeOz/zKQYqrZ
H/jvt00luoBInm6fIIWbgXCaneVtFZRuW03rvLoV+/jFoyPz5iozBlGMlNt1Gelq
z4fG0ZfgxxFNIbZDdZjJJIICF5Qz0vjfx9sS2mx5NpTTzNoUfh7LyhoNk2v9ezAx
lXHIjj8QiHGsAPAqCmh5gscyJPYaYnFDfSu+TKUkKkYpw8vwZe2ofcmukM+/P47r
t6jEaNejEsQv4zmZ3W7egvbmnenZDCroye8UDixW6/IxVm8rIdFQF4jUIq9D4lKO
LkKS2WRn+L29e2iphYAvA0IG29NX7337ActSNRPrFe+xUFloCxMxNFY1NkL9VhyO
Fnvm19No+cVObnQDNNugi6CW9WsKrb9bIhj0etXa0lrbqvZl95anSx7PtPiaCnd3
w2mMkcgXn1wgMvN8TtL4fp3yh4S9LUQPtC7P1OSbUaCBQdWen+o=
=TsQi
-----END PGP SIGNATURE-----

--1giRMj6yz/+FOIRq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
