From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 02/12] selinux: Create policydb version for Infiniband
 support
Date: Fri, 1 Jul 2016 15:50:43 +0300
Message-ID: <20160701125043.GD4750@leon.nu>
References: <1466711578-64398-1-git-send-email-danielj@mellanox.com>
 <1466711578-64398-3-git-send-email-danielj@mellanox.com>
 <20160630150140.GB22107@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q9KOos5vDmpwPx9o"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160630150140.GB22107-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--q9KOos5vDmpwPx9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 30, 2016 at 06:01:42PM +0300, Yuval Shaia wrote:
> On Thu, Jun 23, 2016 at 10:52:48PM +0300, Dan Jurgens wrote:
> > From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > +				rc =3D next_entry(nodebuf, fp, sizeof(u32) * 6);
> > +				if (rc)
> > +					goto out;
> > +
> > +				c->u.pkey.subnet_prefix =3D be64_to_cpu(*((__be64 *)nodebuf));
>=20
> More than 80 characters

Yes, we prefer code readability over checkpatch warning.

>=20
> > +				/* The subnet prefix is stored as an IPv6
> > +				 * address in the policy.
> > +				 *
> > +				 * Check that the lower 2 DWORDS are 0.
> > +				 */
> > +				if (nodebuf[2] || nodebuf[3]) {
> > +					rc =3D -EINVAL;
> > +					goto out;
> > +				}
> > +
> > +				if (nodebuf[4] > 0xffff ||
> > +				    nodebuf[5] > 0xffff) {
> > +					rc =3D -EINVAL;
> > +					goto out;
> > +				}
> > +
> > +				c->u.pkey.low_pkey =3D le32_to_cpu(nodebuf[4]);
> > +				c->u.pkey.high_pkey =3D le32_to_cpu(nodebuf[5]);
> > +
> > +				rc =3D context_read_and_validate(&c->context[0],
> > +							       p,
> > +							       fp);
> > +				if (rc)
> > +					goto out;
> > +				break;
> > +			}
> > +			case OCON_IB_END_PORT:
> > +				rc =3D next_entry(buf, fp, sizeof(u32) * 2);
> > +				if (rc)
> > +					goto out;
> > +				len =3D le32_to_cpu(buf[0]);
> > +
> > +				rc =3D str_read(&c->u.ib_end_port.dev_name, GFP_KERNEL,
>=20
> More than 80 characters?

I would recommend to place all in one line.

>=20
> > +					      fp,
> > +					      len);
> > +				if (rc)
> > +					goto out;
> > +
> > +				c->u.ib_end_port.port =3D le32_to_cpu(buf[1]);
> > +
> > +				rc =3D context_read_and_validate(&c->context[0],
> > +							       p,
> > +							       fp);
> > +				if (rc)
> > +					goto out;
> > +				break;
> >  			}
> >  		}
> >  	}
> > @@ -3147,6 +3209,43 @@ static int ocontext_write(struct policydb *p, st=
ruct policydb_compat_info *info,
>=20
> More than 80 characters

Agree

>=20
> >  				if (rc)
> >  					return rc;
> >  				break;
> > +			case OCON_PKEY: {
>=20
> Is "{" needed?

No, I agree, need to remove.

>=20
> > +				__be64 *sbn_pfx =3D (__be64 *)nodebuf;
> > +				*sbn_pfx =3D cpu_to_be64(c->u.pkey.subnet_prefix);
> > +
> > +				/*
> > +				 * The low order 2 bits were confirmed to be 0
> > +				 * when the policy was loaded. Write them out
> > +				 * as zero
> > +				 */
> > +				nodebuf[2] =3D 0;
> > +				nodebuf[3] =3D 0;
> > +
> > +				nodebuf[4] =3D cpu_to_le32(c->u.pkey.low_pkey);
> > +				nodebuf[5] =3D cpu_to_le32(c->u.pkey.high_pkey);
> > +
> > +				rc =3D put_entry(nodebuf, sizeof(u32), 6, fp);
> > +				if (rc)
> > +					return rc;
> > +				rc =3D context_write(p, &c->context[0], fp);
> > +				if (rc)
> > +					return rc;
> > +				break;
> > +			}
> > +			case OCON_IB_END_PORT:
> > +				len =3D strlen(c->u.ib_end_port.dev_name);
> > +				buf[0] =3D cpu_to_le32(len);
> > +				buf[1] =3D cpu_to_le32(c->u.ib_end_port.port);
> > +				rc =3D put_entry(buf, sizeof(u32), 2, fp);
> > +				if (rc)
> > +					return rc;
> > +				rc =3D put_entry(c->u.ib_end_port.dev_name, 1, len, fp);
>=20
> More than 80 characters?

Readability

>=20
> > +				if (rc)
> > +					return rc;
> > +				rc =3D context_write(p, &c->context[0], fp);
> > +				if (rc)
> > +					return rc;
> > +				break;
> >  			}
> >  		}
> >  	}
> > diff --git a/security/selinux/ss/policydb.h b/security/selinux/ss/polic=
ydb.h
> > index 725d594..751bf604 100644
> > --- a/security/selinux/ss/policydb.h
> > +++ b/security/selinux/ss/policydb.h
> > @@ -187,6 +187,15 @@ struct ocontext {
> >  			u32 addr[4];
> >  			u32 mask[4];
> >  		} node6;        /* IPv6 node information */
> > +		struct {
> > +			u64 subnet_prefix;
> > +			u16 low_pkey;
> > +			u16 high_pkey;
> > +		} pkey;
> > +		struct {
> > +			char *dev_name;
> > +			u8 port;
> > +		} ib_end_port;
> >  	} u;
> >  	union {
> >  		u32 sclass;  /* security class for genfs */
> > @@ -215,14 +224,16 @@ struct genfs {
> >  #define SYM_NUM     8
> > =20
> >  /* object context array indices */
> > -#define OCON_ISID  0	/* initial SIDs */
> > -#define OCON_FS    1	/* unlabeled file systems */
> > -#define OCON_PORT  2	/* TCP and UDP port numbers */
> > -#define OCON_NETIF 3	/* network interfaces */
> > -#define OCON_NODE  4	/* nodes */
> > -#define OCON_FSUSE 5	/* fs_use */
> > -#define OCON_NODE6 6	/* IPv6 nodes */
> > -#define OCON_NUM   7
> > +#define OCON_ISID	 0 /* initial SIDs */
> > +#define OCON_FS		 1 /* unlabeled file systems */
> > +#define OCON_PORT	 2 /* TCP and UDP port numbers */
> > +#define OCON_NETIF	 3 /* network interfaces */
> > +#define OCON_NODE	 4 /* nodes */
> > +#define OCON_FSUSE	 5 /* fs_use */
> > +#define OCON_NODE6	 6 /* IPv6 nodes */
> > +#define OCON_PKEY	 7 /* Infiniband PKeys */
> > +#define OCON_IB_END_PORT 8 /* Infiniband End ports */
> > +#define OCON_NUM	 9
> > =20
> >  /* The policy database */
> >  struct policydb {
> > --=20
> > 1.8.3.1
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--q9KOos5vDmpwPx9o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXdmcjAAoJEORje4g2clinhVoQAKxDDvIiJgXteF31E5Nzy0wt
p5f09OakWXKYYNe3s47QKTR1izzgVgJS/VPVOks0Nbq+xXd8+6S3ubS6eXwkVhuP
sS7We5Z+gMBJIY3qERAEePl/uh4KKRJz3XYnFFCj/t/8wo/8/tzTzsT9swQMWGFi
vOhL9XssG4cq6jqiNUX8C4TVymfDCto2n7JAaP3Un5UaknQAfqlXiaqPk0WdqcVG
Ygj9NPfHybEXSRcnRA1Sl3hDA2muxRAsiCXaIUKohTCw2GUjjh2ueGWrkSL3iSYm
0g+ZwsZzvcYszK/YEwbe+/wfQ6BA+UuV87se1m8w7hm7zuyZT3tqkx5g6WP3BU8d
9aXUzyypz5zBwqfoI0OaIzqgssP9d3V5+m81Gn4+WTuCqjN3t79BfmWL1sDOg7Dj
geYmYvswp+MfKNoqhbPGNlivnqd1L0ETsnoEGo83dim4iB33ENgPwm8S87TbSf0h
An5ujbOteUXju4DUhiS72kElo9wEUu1670goydPwyGLKoNUINyntWQPm3PBqLLEj
CB84lYxE2kL+7p8ZqXRxwMiFuJkEveAxQQ2NNzUHWRSUqIZ/HbjuH6bBf0T3UKgL
dLxi3qrz3Kquwh0bEUdhtoxE5ewL8iPGMOFTN9ZVefJAnLJjOWZnsLr/NF6JrA1Y
embgMLwiX/7SAOUYubtf
=QbKh
-----END PGP SIGNATURE-----

--q9KOos5vDmpwPx9o--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
