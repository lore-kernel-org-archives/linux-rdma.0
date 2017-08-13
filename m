From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] cbuild: use rpmspec for macro replacement
Date: Sun, 13 Aug 2017 09:37:06 +0300
Message-ID: <20170813063706.GQ24282@mtr-leonro.local>
References: <27366048-d80f-3711-c6cd-93c87809650e@suse.de>
 <8ad0438f-b4a5-aec9-1e44-a9c9dc1ca17b@suse.de>
 <20170808230459.GF29372@obsidianresearch.com>
 <b3993b0c-0b9d-a917-cbf8-22f68c1d2a97@suse.de>
 <20170809155532.GC15586@obsidianresearch.com>
 <f42a6eaa-79f9-1063-b58a-08da363d09e7@suse.de>
 <20170809201932.GA7363@obsidianresearch.com>
 <5c4de783-ce62-2b8d-78aa-ee2f181fe719@suse.de>
 <20170809211536.GA10191@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BHMq0+oGliEfCAkH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170809211536.GA10191-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--BHMq0+oGliEfCAkH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 09, 2017 at 03:15:36PM -0600, Jason Gunthorpe wrote:
> On Wed, Aug 09, 2017 at 11:08:34PM +0200, Nicolas Morey-Chaisemartin wrote:
>
> > > And drop a symlink to fix it up.
>
> > Yes this should work. It feels a little bit dirty to have a tarball
> > name with unreplaced macro but it's a temporay state so I can live
> > with this :)
>
> It is a bit strange, but this trivially delegates parsing the .tar.xx
> to git archive which understands all the formats..
>
> Here is the patches, should I send them?
>
> https://github.com/jgunthorpe/rdma-plumbing/tree/cbuild

????

Thanks

--BHMq0+oGliEfCAkH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmP85IACgkQ5GN7iDZy
WKd4lw//eo0KgLl4xBoatX4ZVS2eEk/4bLyMNn55fYbmQDKm8uZbKzIVJr5ITFL9
02hGEQD4+VhAnXK9BtT5mU2rOkaszE/8QPDBNqhhQaJ2iwse9yOxcDV/d+nQI95K
MyG2S+ygJHfpD92M3oOt43Y+E/WdoEasQu4wjWnxYcQOXcNUbNkBt/+VmCWlLXM8
tLnUzfPTtR2gkCRJ5QohM4OT59GEHt9CKjRqGJGm1nPCJzBr9AMzbIdkpclsRZJw
jURQIzJbwqImrNyKCYrLNWqWxAQLc8rfELc6c2hRVuFe2uWPTIQ+KnlVLf9Ijqsn
a8oevHVsOSE/9/2tlBRdWoJYX3VWF9Ukedf+Sp4RJfueLpOoJ2noxi61MyBRgr8h
W5oR9TNPf8WZTwLmP9sN7cCcyN6ZPAiehfmyRk3sc6KtAP8ZGICz9AhhuWESmS+U
JxtSYrBcr2fYYMEsJnsd0NA/Bw3mKb2YfYPySd1J7iGeugihVGPoVV30XQE3Lgz7
PcF/l55VdqadxJ/0ugTy6/I6hOZT9h/cFcRWQc+V7E7WxEa9oXyfaWyLaM8sN+Ga
k2KuiU/0xrvfnPszz0TAwZFpd5ff0ppoC5bDVoKkPEUaM9+3t6gYrKeNuNqOPyYJ
/sHMJIBGVQQ4P8GXBT3v7vVSKUfh0gSACxygx7xHNj2QoGuyC2E=
=sqd+
-----END PGP SIGNATURE-----

--BHMq0+oGliEfCAkH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
