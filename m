From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Thu, 1 Sep 2016 14:03:52 +0300
Message-ID: <20160901110352.GI3694@leon.nu>
References: <20160823185441.GA1233@obsidianresearch.com>
 <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
 <c84de2a5-6526-c0a6-6535-519add3fbabb@dev.mellanox.co.il>
 <20160828182715.GA12783@obsidianresearch.com>
 <004e01d20203$156edc30$404c9490$@opengridcomputing.com>
 <20160829161902.GB23557@obsidianresearch.com>
 <20160830060842.GJ594@leon.nu>
 <9C6B67F36DCAFC479B1CF6A967258A8C7DE04100@ORSMSX115.amr.corp.intel.com>
 <20160831200336.GA4134@obsidianresearch.com>
 <20160901082643.GA19799@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tSiBuZsJmMXpnp7T"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160901082643.GA19799-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>ya
List-Id: linux-rdma@vger.kernel.org


--tSiBuZsJmMXpnp7T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 01, 2016 at 01:26:43AM -0700, Christoph Hellwig wrote:
> Arguing with these sorts of bullshit positions from Robert and Leon
> just makes me feel tired.

What are you arguing with us about? These "clueless" people suggested
you the way to move forward and get vendor support to this effort -
convince Doug to add co-maintainer to RDMA stack (kernel and user-space) to
help him to deal with increase in upstream activity.

This co-maintainer won't deal with API's patches (UAPI and libibverbs),
but will help with various internal things (drivers, user-space drivers,
ulps, fixes, e.t.c).

The kernel.org infrastructure allows multiple write access to the same
repository and there are subsystems which are already using it.

If it helps, I can step in and do this job.

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--tSiBuZsJmMXpnp7T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXyAsYAAoJEORje4g2clinZA4P/3xeyWK2rwv5D3LXuhUSVp/r
4FaVemhg50BdHLB6AIByC27djw94MOGYwSq45zUD3A4AO+Oq92cKoviTwUPuq4Ch
YDyKu2UBywPBFq/rnITn/XLBz0FkoXtkelMfRM/UFgKB78MKhnJZR0sde0aBVSnm
4M4tQXig1g+3nWuSwb10umrwZ/uSQhy9XeMXFz2L8SdOWlEMfADzg8SAzG21uYCh
b8TKti0Q1E4HiYxZ8EUd6iXVURquh0AXcJKb60MZTgj0cITAJPNg7tnym1ZXChYz
KaBBPc54OcJW7xIdBRyomjdD/GpIdugTItT40FkqUdXAILbPVnXfFsMk/dIWSyjv
uKsZiE9R4W8ceYJ0jgq8uUlQz8VzQ5dw+6zZkGojbWiNJwfiCNykfK1D1QCwVDWW
4oh66sgGiZhTDO2VbK0sZMClCjD4fQV9TmDNHUpnqcC0h5ocyZORPHce7tiGYij8
zwQoE3AAYEA1nVRsgJ9usIZVsavcgiOTCtZ1zWvtjTb7fAx1LKT+i+Gaac20ZRJg
wMnIjhW2w5xoC4kK5OoOWi/srhyH2Ha6zQYLixjqKjarYACEPtTxjy+YmL6EmRVA
Dk75asIa2hBlZkFBnVgnkmzo/bF7GW2jSmQFD7COEi9LGYDiss6t8otk9Uuiud1L
xKAesRngHPqyCzScB1ul
=AEBg
-----END PGP SIGNATURE-----

--tSiBuZsJmMXpnp7T--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
