From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Current patch statuses
Date: Fri, 29 May 2015 17:57:25 -0400
Message-ID: <1432936645.114391.156.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-JssrcUMm9qV1s1RBkOGP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Alex Vainman <alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-JssrcUMm9qV1s1RBkOGP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

* Ira's 3 patch const cleanup: generally approved, waiting latest
version
* Ira's 14 patch OPA set: I haven't reviewed yet, waiting for next
version
* Matan's 14 patch RoCE GID set: Changes were requested, awaiting next
version
* Or's 11 patch timestamp set: The general idea is OK, creating an
extension is OK, but I think the actual uAPI needs nailed down a little
more.  Right now it's too vendor/model/driver specific for a general
uAPI.
* Haggai's 12 patch cma namespace set: Serious concerns over the
suitability of creating more than one link per unique guid/pkey.
Requesting that Haggai investigate using alias GUIDs for containers
instead.
* Or's 3 patch SRIOV set: both changes and coordination with
netdev/iproute2 folks requested, awaiting results of that interaction
and update for 8byte GUID management
* Yishai's 3 patch hot removal set: changes in locking requested
* Alex's Verbs RSS RFC: I read through the proposal, but I didn't
research it in enough detail to provide high quality feedback.  But I
will give a little low quality feedback.  First the good: I'm generally
receptive to anything that improves our NUMA operation.  While I didn't
see that the RSS necessarily took NUMA into consideration, the overall
framework looked like a good starting point for doing exactly that.  The
ability to have RSS via hashed receives and multiple flows is a start,
now you just need to add pinning the flows to specific sockets that are
adjacent to the PCI bus the controller is on and populating the number
of threads to use for RSS based upon the number of cores/threads per
socket.  Next the questionable: I'm not sure I like the specific
implementation.  It puts a lot of new, complex configuration on the
application.  But the benefits of this could have a default setting
without requiring application interaction.  I'm not sure I wouldn't
prefer something that, by default, creates all new QPs and CQs so that
they go through a default hashing and redirection without any user
interaction at all.  Or maybe the user simply sets a flag to signal that
they are OK with multithread completion handling and they get it.  Or
something like that.  On other words, I would like to see an application
get the benefit of this without having to be recoded.  Maybe they only
get a default benefit and not an optimized benefit, and maybe the user
has to set an environment variable for libibverbs before it gets enabled
by default, but I would still like to see a non-recompiled app benefit
from this.  The proposal I see here might be able to do that if the
changes to libibverbs are done properly.  And if the implementation is
right it might be able to help the kernel consumers too.  So, please
keep these things in mind as you continue to work on this.

And with that, I've got to do some Red Hat work for a bit.  I won't be
as responsive the early part of next week as a result.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-JssrcUMm9qV1s1RBkOGP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVaODFAAoJELgmozMOVy/dqcUQAJYT9ZwF/BPuqyfJuPD6fKMw
f7ggWmd/oJyT99/E6lFc4mHg+K3Klj0Vifjt1O0NqcZs11SIv02E4RZ77VyvNIUv
m1YEs5klNiNmDbOkKOneRtpt/1kpQeIJ0aJ6nRlpf2FJ9KmwYUT9E8dxBGcWZp4p
kyxjNbebDgN/1jYCCmV+S9nDasCo6Ril+vCu8H6WssIOOV0aTRI6UXXvAmHCthbr
htHddWcW/aT4Mxk4fF/kK1FhVCeNSnFAT2urkWMb9qzQUu7JwJFjAYRsbk5MO+GJ
k/nkdsKeWW2yc4EIF5DSXgFYmI0XpP4LXznpak/l6JfWliR+iwVGYLU7z7VopOKf
aIun7tg7g7zJzJE9R+hF0bD/5SsJh6PguTmAXeGDMjnG0wOh2zcavk5y2di5kWT7
tF4fou3GEv0j/8kSzNmiXe2C2WedMj+S1JjaH9Og5dekVR1fTP70itQ4YLNBfkdj
GStWp7XSJ4sqg/ezVZEU1OJnW2WU62ycJEQEFqd3p0HRpTbO4UXePUNNVbDGPfsz
VOHNbiftEg+hiU/LBzpne9m2WoZL5ibD8JBANZE/midR/rrRjHDuvV0EWMUcjenW
vl2RwCwXDZ9sznVinJ6MySIINVFVo4tAxQr0QkDpytg3p2gip/nIEk0qdP+0TZAZ
r0IigLIqJSzMQkYg93kq
=iVrF
-----END PGP SIGNATURE-----

--=-JssrcUMm9qV1s1RBkOGP--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
