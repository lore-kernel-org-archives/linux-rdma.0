From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: OmniPath physical state bits
Date: Tue, 1 Aug 2017 21:43:08 +0300
Message-ID: <20170801184308.GR13672@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="X9OP1fpbq0KufMFh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--X9OP1fpbq0KufMFh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dennis,

I'm almost finished to work on the third wave of my RDMAtool patches -
expose through UAPI various device capability bits, physical states, e.t.c.

While writing rdma_link_phys_state bits, I saw that OmniPath using 8-15
bits and I would like to add ability for RDMAtool to handle it properly.

The last piece before I can send the patches is the lack of
documentation for those bits. Can you please provide short description
for them so I'll be able to add it to the exported header file?
It will serve as a documentation for the RDAMtool users.

Right now, it looks like this:

156 /*
157  * When writing this field, only values 0, 1, 2, and 3
158  * are valid. Other values are ignored. See InfiniBand Architecture
159  * Specification Volume 2, Link/Phy Interface chapter.
160  */
161 enum rdma_link_phys_state {
162         /*
163          * 0 - 7 are according to the IB specification
164          * 8 - 15 -  Reserved and ignored in IB, but partially
165          *           in use by OmniPath
166          */
167         RDMA_LINK_PHYS_STATE_NOP,
168         RDMA_LINK_PHYS_STATE_SLEEP,
169         RDMA_LINK_PHYS_STATE_POLLING,
170         RDMA_LINK_PHYS_STATE_DISABLED,
171         RDMA_LINK_PHYS_STATE_PORT_CONFIGURATION_TRAINING,
172         RDMA_LINK_PHYS_STATE_LINK_UP,
173         RDMA_LINK_PHYS_STATE_LINK_ERROR_RECOVER,
174         RDMA_LINK_PHYS_STATE_LINK_PHY_TEST,
175         /* 8 is reserved */
176         RDMA_LINK_PHYS_STATE_OFFLINE = 9,
177         RDMA_LINK_PHYS_STATE_GANGED,
178         RDMA_LINK_PHYS_STATE_TEST,
179         RDMA_LINK_PHYS_STATE_MAX,
180         /* values 12-15 are reserved/ignored */
181 };

Thanks

--X9OP1fpbq0KufMFh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmAy7sACgkQ5GN7iDZy
WKfdxBAAlFWyR52L2S6btAsQodQtwQB2GN1OuuShGUj4h3v6PbBSv+CCF1wJLa+7
S2T5ZgeFgSen+VIWfrCVoxqMS9KEV+Dqn6Mh1/nR26nW7iq1ddQyP0NBK1ILALz/
IskX66TbuZBVpmluryLNMOYRBbaZawKX0RuD58LbTlHOhGM3hd+ktt3g5fIlzbHO
KDomjB4o2wDeBR83f0PxGMKj1r6VBL5i54q7If6PyNQTq6JvnkCwMXnV0+OLhyrT
/KOl28AZ1ZFKl7iC20san9y1biNdcOe5B1L6AIbTG2adLwGIKbp9JcUJQfRPWsjk
vW0wLVJHrqmc3IOBwHjt+l/sUhaEKz4S6DBOVxn3FeCm/33JXrCBpZEttyxIHORv
16oe88YXhzVPziGYwi0cgh+HJDZO7kFdpFSM0K9Vwd19v3OT9fpBUHJV7AIelBsT
mHkSP9qJUioQzW+k3u+iKtytkOMrtVAbTF0/t0E0aX8wlgEzyCPMmnGJ3fN2/njM
QKnTcCIFdY5negKH5LG5ab5zgTVgsNVUp6AXxGScYHE7c2zCnyIgmglahf0yJ7G0
MKXHsqMNole48SGvBcOkHCD402ue0SggUJVmCfiKrFpHGE+k7AsciU7SVfOpbcy1
Y1fobsU426nOsRNJckzsukmofZXLuCwf9Gz5iGH57HkIWvc5ggA=
=7jM/
-----END PGP SIGNATURE-----

--X9OP1fpbq0KufMFh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
