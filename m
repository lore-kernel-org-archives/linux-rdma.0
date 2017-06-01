From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Thu, 1 Jun 2017 07:10:22 +0300
Message-ID: <20170601041022.GM5406@mtr-leonro.local>
References: <20170529082423.1180-1-leon@kernel.org>
 <20170530212431.GA21008@ssaleem-MOBL4.amr.corp.intel.com>
 <20170531040437.GE5406@mtr-leonro.local>
 <20170531174245.GA16304@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Cqq5NadOW2RfLMJ/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170531174245.GA16304-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Cqq5NadOW2RfLMJ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 31, 2017 at 12:42:45PM -0500, Shiraz Saleem wrote:
> On Wed, May 31, 2017 at 07:04:37AM +0300, Leon Romanovsky wrote:
> > On Tue, May 30, 2017 at 04:24:31PM -0500, Shiraz Saleem wrote:
> > > On Mon, May 29, 2017 at 11:24:23AM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org>
> > > >
>
> > 3. The commit cea05eadde made libnl library (basic block of user-space part of netlink)
> > to work incorrectly and not according to _blocking/_nonblocking semantics.
>
> How? Is libnl calling ibnl_unicast? As far we can understand ibnl_unicast is only called
> by portmapper kernel code.

Yes, libnl is calling to ibnl_unicast() and this is why it brought my
attention to regression caused by commit which I'm reverting.

Bottom-up flow:
						ibnl_unicast
					send_nlmsg_done
				iwpm_send_mapinfo
			iwpm_mapping_info_cb
		[RDMA_NL_IWPM_MAPINFO] = {.dump = iwpm_mapping_info_cb}
	ibnl_rcv_msg
netlink_rcv_skb(skb, &ibnl_rcv_msg);
-----
libnl:
nl_recvmsgs()

>
> > 4. Reverting is a common practice in Linux kernel. Patches are not
> > carved in stones.
>
> Reverting a patch that's introduced during RC cycle is fine, introducing
> regression is NOT and that is what you are doing by simply proposing to revert
> this patch.  Reverting this patch will introduce a REGRESSION error with respect to
> port mapping functionality for all iWARP vendors.

Interesting and how did all these iWARP vendors survive before your
patch?

>
> > 5. I proposed a solution -> go and fix your user space program.
> This is a kernel patch you are trying to revert, you are breaking existing
> kernel functionality.  Nothing to do with user space.

Sorry, but it is not the case. The user space is broken.

Thanks

--Cqq5NadOW2RfLMJ/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkvk64ACgkQ5GN7iDZy
WKeK0BAAiD3AgflhqufqSMHqibSMcfAPIYTJKF/1XzoslF3mMR7hA4eX2C1ASBEa
8T7g8guJQTdhcW/v6ygopgbG0pbjao4O7YIpDjyxLl7Yxl12XYPZxeGpeb4bJa9r
nROkU1g6S46e5vIFMSRUxArKIKOvSUc1cdbLWyinMrHdbp3KnUy5D59DxpnVxsjp
ZI6E4ronjOM5xja8ml78Zf0p0e2z5bYztBrsbR365soxiMCT3kD5q+IgeCa6gH6x
rl6RdboKUFKOD4oRMsyLK2UUNxI/SqzzoKqwaEMODSUiuJLG6s78BGahMZg+aFJP
IEvqQP3A+9n8pJYLM9WEHAY2WPs/HSBlkzUb9KXbBrYP4F+0WQPvGVwpgpLq4kWr
cm+HO8Bugq/9+aBClqIX8vUgCFURffmepkVg+sAPyeyghYOeAQQ+Nm6uYYgdr4QZ
k0xPFyIPpqaIkT5OKjbLMymejRadziwVLSPBvMJT4DtReKHXU3nUXbRQ7JRPAatY
IBee1Masi+60HcCdubY0ksZLCSvlqWMvCg/0z129aL0ORum4MGVsqcje33vSI5Yq
gvc00dzmK7WnrMj3VfzJ4TGnel39v1oowqGVEJjowZaNU+RNeY8FzdNSKlPvmxxZ
to0chIO9mr2HxRD8V36eQSoypaC5K1KpkTuudDF3Ky8uAhi2S9g=
=PIjh
-----END PGP SIGNATURE-----

--Cqq5NadOW2RfLMJ/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
