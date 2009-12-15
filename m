From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: SRP issues with OpenSM 3.3.3
Date: Tue, 15 Dec 2009 19:12:37 +0200
Message-ID: <20091215171237.GX5262@me>
References: <20091214164334.064102f0.weiny2@llnl.gov>
 <f0e08f230912150716y392cf1f1t4cd640b6663f7fea@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230912150716y392cf1f1t4cd640b6663f7fea-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10:16 Tue 15 Dec     , Hal Rosenstock wrote:
>=20
> > patch: 3d20f82edd3246879063b77721d0bcef927bdc48
> >
> > =A0 =A0opensm/osm_sa_path_record.c: separate router guid resolution=
 code
> >
> > =A0 =A0Move off subnet destination (router address) resolution code=
 to separate
> > =A0 =A0function to improve readability.
> >
> > =A0 =A0Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> >
> > I further traced the problem to pr_rcv_build_pr and the patch below=
 fixes the
> > bug.
>=20
> On quick glance, I'm missing the connection between Sasha's patch and
> this routine setting something bad in the hop limit of the returned
> path record.

In this patch I moved *p_dgid initialization out from router only
section, as side effect it turns on this section:

	/* Only set HopLimit if going through a router */
	if (is_nonzero_gid)
		p_pr->hop_flow_raw |=3D cl_hton32(IB_HOPLIMIT_MAX);

for all SA PR queries where DGID was selected (local subnet or not).

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
