From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 00/23] IB/Verbs: IB Management Helpers
Date: Thu, 30 Apr 2015 03:00:16 -0400
Message-ID: <1430377216.102408.47.camel@redhat.com>
References: <1430233823-7075-1-git-send-email-yun.wang@profitbricks.com>
	 <1430324895.102408.23.camel@redhat.com> <5541C044.7090800@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-JXPHupSH4k5A7/XhAiZM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5541C044.7090800-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-JXPHupSH4k5A7/XhAiZM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-04-30 at 08:40 +0300, Or Gerlitz wrote:
> On 4/29/2015 7:28 PM, Doug Ledford wrote:
> > On Tue, 2015-04-28 at 17:10 +0200, Michael Wang wrote:
> >> >Since v6:
> >> >   * Thanks to Ira, Devesh for the review and testing:-)
> >> >   * Thanks for the comments from Sean, Tom, Jason, Doug, Devesh, Ira=
,
> >> >     Liran:-)  Please remind me if anything missed:-P
> >> >   * Use query_protocol() and enum protocol type in 1#
> >> >   * Use rdma_protocol_XX() in 2#
> >> >   * Drop cma_set_legacy_transport()
> >> >   * Reserve rdma_ib_or_iboe() and rdma_node_get_transport()
> >> >   * Updated github repository to v7
> > I've taken your patchset and threw it into a for-4.2 branch in my repo.
> > This will get it 0day testing.  I've also pulled it into my test cluste=
r
> > and done minimal testing (bootup, finds devices, gets IP address via dh=
cp).
>=20
> Doug,
>=20
> As I wrote to Michael, this series carries way (way) over Cc: pointers=
=20
> in each it's commits. We have never had something like this since this=
=20
> stack was formed 10y ago and accepted into 2.6.12 --- and I didn't hear=
=20
> any good reason for why doing so (see the thread  for "[PATCH v7 04/23]=
=20
> IB/Verbs: Reform IB-core cm") -- can you please provide your opinion on=
=20
> the matter?

When you are talking about a patch series using a single, global --cc
list for the git send-email command, I'm OK with that.  The git
send-email command does not, however, stick the Cc: lines in the email
body itself.  So there, it makes sense to trim the Cc: list to just the
necessary people.

So, short answer:

--cc list options: include all interested parties
git log messages: include relevant parties

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-JXPHupSH4k5A7/XhAiZM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVQdMAAAoJELgmozMOVy/d43cP/iGWEKHLdyK+ynrnWtlVlQFn
J3lRuozfUSHv4tMcm0HkEo/BFbwUr5PI+yx6r00Uf6hXRG+RZQ7RbAfIZwdBqTtW
y68QA98ESxNZt4qCI/jDB26/ZmOZ7spD+TtqHzhEW+TeI8zhSm/LbC7oY4trTBOU
Mg4RezZog8wvVdoyzYq6G3KdthQFLWYwuxctevD1TrQykIvAvzcEix0Fak3FFFhi
mCzs+FrWJeI1Cm4wqm1tj4c9eo5Tx8Bcg1+6MAwOziAbStmRaQp8hFVR4emCA3vs
CGn5W15hPYtBnr0+RlQ42ItcTNrzXZxuLLevwOB9IZnoBaQOzdfl/7wS0mNvg4Rz
76Zwg44Xb1Cta+rGxp7+QTCDJHnpamde/OUqPFJbfVURWqPu/tPVLM5vyAUr2J4F
l0Mt8154wNY7zioPcpOxd6VZdeRzXhkkSBws5PBxcBgTvM5e5S7WH0ZGII6FdWvQ
MxUadJ7BUJ6poigoQYllpdo4bhQJElyCcCPBSBdOpB4WeezUHQN0bEyy5uewHIGL
nDWThUP8eEomIxev75zHdAIAEAFSWFFhzhpun13YVMIE2+3F5nNDeARSZTWs/Vdx
csYk5rG84qAFdvs6bKgLAtUe/aGLr8Yz31lbfs0muqnwtZH3tKxeBn3WyDqBIStD
3hRDu2HkL5pAo5Bg6dIE
=qoui
-----END PGP SIGNATURE-----

--=-JXPHupSH4k5A7/XhAiZM--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
