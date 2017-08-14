From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v3-v5] Add OPA extended LID support
Date: Mon, 14 Aug 2017 10:37:06 +0300
Message-ID: <20170814073706.GD24282@mtr-leonro.local>
References: <1502476546-9367-1-git-send-email-don.hiatt@intel.com>
 <20170812062941.GL24282@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gX5Hm7FaHdN5aeGl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170812062941.GL24282-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--gX5Hm7FaHdN5aeGl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 12, 2017 at 09:29:41AM +0300, Leon Romanovsky wrote:
> On Fri, Aug 11, 2017 at 02:35:46PM -0400, Don Hiatt wrote:
> > This patch series primarily increases sizes of variables that hold
> > lid values from 16 to 32 bits. Additionally, it adds a check in
> > the IB mad stack to verify a properly formatted MAD when OPA
> > extended LIDs are used.
> >
> > Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> >
>
> <...>
>
> >
> > -/* Return slid in 16bit CPU encoding */
> > -static inline u16 ib_slid_cpu16(u32 slid)
> > +/**
> > + * ib_lid_cpu16 - Return lid in 16bit CPU encoding.
> > + *     In the current implementation the only way to get
> > + *     get the 32bit lid is from other sources for OPA.
> > + *     For IB, lids will always be 16bits so cast the
> > + *     value accordingly.
> > + *
> > + * @lid: A 32bit LID
> > + */
> > +static inline u16 ib_lid_cpu16(u32 lid)
> >  {
> > -	return (u16)slid;
> > +	WARN_ON_ONCE(lid && 0xFFFF0000);
>
> It will print warning for first lid > 0
> The proper lines should be "lid & 0xFFFF0000" (one ampersand).
>
> > +	return (u16)lid;
> >  }
> >
> > -/* Return slid in 16bit BE encoding */
> > -static inline u16 ib_slid_be16(u32 slid)
> > +/**
> > + * ib_lid_be16 - Return lid in 16bit BE encoding.
> > + *
> > + * @lid: A 32bit LID
> > + */
> > +static inline u16 ib_lid_be16(u32 lid)
>
> This function returns be16 and not u16.
>
> >  {
> > -	return cpu_to_be16((u16)slid);
> > +	WARN_ON_ONCE(lid && 0xFFFF0000);
>
> The same as above.

Hi Don,

Are you planning to fix it?
Right now, for-next is overflowed with smatch errors.

Partial output from my checkers:
===== SPARSE =========
<...>

drivers/infiniband/hw/mlx4/mad.c:628:45: warning: incorrect type in assignment (different base types)
drivers/infiniband/hw/mlx4/mad.c:628:45:    expected restricted __be16 [usertype] slid_mac_47_32
drivers/infiniband/hw/mlx4/mad.c:628:45:    got unsigned short

<..>

drivers/infiniband/core/cm.c:1181:60: warning: incorrect type in argument 1 (different base types)
drivers/infiniband/core/cm.c:1181:60:    expected unsigned int [unsigned] [usertype] dlid
drivers/infiniband/core/cm.c:1181:60:    got restricted __be32 [usertype] dlid
drivers/infiniband/core/cm.c:1182:60: warning: incorrect type in argument 2 (different base types)
drivers/infiniband/core/cm.c:1182:60:    expected unsigned int [unsigned] [usertype] slid
drivers/infiniband/core/cm.c:1182:60:    got restricted __be32 [usertype] slid
./include/rdma/opa_addr.h:90:14: warning: cast to restricted __be32
./include/rdma/opa_addr.h:92:14: warning: cast to restricted __be32
drivers/infiniband/core/cm.c:1242:68: warning: incorrect type in argument 1 (different base types)
drivers/infiniband/core/cm.c:1242:68:    expected unsigned int [unsigned] [usertype] dlid
drivers/infiniband/core/cm.c:1242:68:    got restricted __be32 [usertype] dlid
drivers/infiniband/core/cm.c:1243:68: warning: incorrect type in argument 2 (different base types)
drivers/infiniband/core/cm.c:1243:68:    expected unsigned int [unsigned] [usertype] slid
drivers/infiniband/core/cm.c:1243:68:    got restricted __be32 [usertype] slid
./include/rdma/opa_addr.h:90:14: warning: cast to restricted __be32
./include/rdma/opa_addr.h:92:14: warning: cast to restricted __be32
./include/rdma/ib_verbs.h:3757:16: warning: incorrect type in return expression (different base types)
./include/rdma/ib_verbs.h:3757:16:    expected unsigned short
./include/rdma/ib_verbs.h:3757:16:    got restricted __be16 [usertype] <noident>
drivers/infiniband/core/cm.c:1773:52: warning: incorrect type in assignment (different base types)
drivers/infiniband/core/cm.c:1773:52:    expected restricted __be16 [usertype] primary_local_lid
drivers/infiniband/core/cm.c:1773:52:    got unsigned short
./include/rdma/ib_verbs.h:3757:16: warning: incorrect type in return expression (different base types)
./include/rdma/ib_verbs.h:3757:16:    expected unsigned short
./include/rdma/ib_verbs.h:3757:16:    got restricted __be16 [usertype] <noident>
drivers/infiniband/core/cm.c:1783:48: warning: incorrect type in assignment (different base types)
drivers/infiniband/core/cm.c:1783:48:    expected restricted __be16 [usertype] alt_local_lid
drivers/infiniband/core/cm.c:1783:48:    got unsigned short
drivers/infiniband/core/cm.c:2922:66: warning: incorrect type in argument 1 (different base types)
drivers/infiniband/core/cm.c:2922:66:    expected unsigned int [unsigned] [usertype] dlid
drivers/infiniband/core/cm.c:2922:66:    got restricted __be32 [usertype] dlid
drivers/infiniband/core/cm.c:2923:66: warning: incorrect type in argument 2 (different base types)
drivers/infiniband/core/cm.c:2923:66:    expected unsigned int [unsigned] [usertype] slid
drivers/infiniband/core/cm.c:2923:66:    got restricted __be32 [usertype] slid
./include/rdma/opa_addr.h:90:14: warning: cast to restricted __be32
./include/rdma/opa_addr.h:92:14: warning: cast to restricted __be32
./include/rdma/ib_verbs.h:3757:16: warning: incorrect type in return expression (different base types)
./include/rdma/ib_verbs.h:3757:16:    expected unsigned short
./include/rdma/ib_verbs.h:3757:16:    got restricted __be16 [usertype] <noident>
drivers/infiniband/core/user_mad.c:232:36: warning: incorrect type in assignment (different base types)
drivers/infiniband/core/user_mad.c:232:36:    expected restricted __be16 [usertype] lid
drivers/infiniband/core/user_mad.c:232:36:    got unsigned short
./include/rdma/ib_addr.h:313:63: warning: incorrect type in argument 1 (different base types)
./include/rdma/ib_addr.h:313:63:    expected restricted __be32 [usertype] addr
./include/rdma/ib_addr.h:313:63:    got unsigned int [unsigned] [addressable] [usertype] ipv4_addr
drivers/infiniband/hw/ocrdma/ocrdma_hw.c:3186:32: warning: Using plain integer as NULL pointer
./include/rdma/ib_addr.h:313:63: warning: incorrect type in argument 1 (different base types)
./include/rdma/ib_addr.h:313:63:    expected restricted __be32 [usertype] addr
./include/rdma/ib_addr.h:313:63:    got unsigned int [unsigned] [addressable] [usertype] ipv4_addr
./include/rdma/ib_addr.h:313:63: warning: incorrect type in argument 1 (different base types)
./include/rdma/ib_addr.h:313:63:    expected restricted __be32 [usertype] addr
./include/rdma/ib_addr.h:313:63:    got unsigned int [unsigned] [addressable] [usertype] ipv4_addr

>
> > +	return cpu_to_be16((u16)lid);
> >  }
> >  #endif /* IB_VERBS_H */
> > --
> > 1.8.3.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html



--gX5Hm7FaHdN5aeGl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmRUyIACgkQ5GN7iDZy
WKeZWg/+JJGRgMMvAdZtKjBaPC1k71fJDYLrPN0qSk0WfQEs6RJWmHHGLncUKok7
Lj4sAEUipovRzpoeWyXoxgdLnh93eKyHrOhEbzyyAZVGoyjK0Omar4/0PbBHprIp
4XfNSwJgE4RZH6fVnpRcQhBBgjpUelWbcVHTV5ONQs6aFhGl4JOLPL+/JcdKGthv
UEndBRYBXaU43dDuOEi9y3S18AMqz9BjEGSPjUp0ijtxG1ft6KAOeRbV3Xf4hN6s
Mn9zgL7Br+FTjseZtR1PeqvXfaKagKegjPn3ELBwx9cskSFhSumJRMMj0TLMkd5P
V4FlWLD7PHMbUvhSMqdMW8fPtpZHhjRRA0OJKe4fl+alnziVgoPW+ILjpVKDMPxO
kMW9VDf0qjoKKBDOCkFIU1qWcUdlYfXwFObhcc8IZ9bJQSkgRZ3xawV937SGSRgH
Du8MMuL7C9GVRv/bNaO6C8UjqfBjbt9gAvn2nrK5ADj69OIzmyvhT+bhsWtDiXlm
blD32Jris3KDU7Z/X+ZmtiiSqR31WAIT+bHmc3GHsKvim5N0Osl//gzgjU6SHUkO
/GK+/eZuLDqOW9aMyM4paLB0JsbxFG1HBu9GNDQR26xDv4dP6QwAn7o3mNGhIR1a
Z8ciacA8N9Q2nawWjb8m1O49yAXxVrUrhL0mOCg3+LRW8TDF0FA=
=FSZE
-----END PGP SIGNATURE-----

--gX5Hm7FaHdN5aeGl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
