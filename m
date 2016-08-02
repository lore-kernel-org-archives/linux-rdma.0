From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 0/5] Reduce RDMA RW API SGE limit
Date: Tue, 02 Aug 2016 12:05:08 -0400
Message-ID: <1470153908.18081.3.camel@redhat.com>
References: <75fc8647-16a6-5a89-400f-f5f418a8d6eb@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-0gKy30deRpabn+kWOsC/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <75fc8647-16a6-5a89-400f-f5f418a8d6eb-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-0gKy30deRpabn+kWOsC/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-07-21 at 13:02 -0700, Bart Van Assche wrote:
> Hello Doug,
>=20
> The five patches in this series modify the RDMA RW API slightly. This
> is=C2=A0
> needed to avoid that the SRP and iSER target drivers submit RDMA=C2=A0
> requests with an SGE list that exceeds the queue pair limits. The=C2=A0
> ib_srpt changes in this series have been tested but the ib_isert
> changes=C2=A0
> not yet.
>=20
> The changes compared to v3 of this patch series are:
> * Split the single QP SGE limit into separate READ and WRITE SGE
> limits.
> * Added a comment in ib_srpt.h that explains where the SGE limit
> comes
> =C2=A0=C2=A0=C2=A0from.
>=20
> Changes compared to v2:
> * For RDMA READs, limit SGE back to dev->attrs.max_sge_rd for iWARP.
>=20
> Changes compared to v1:
> * max_send_sge is now stored in struct ib_qp. This greatly simplifies
> =C2=A0=C2=A0=C2=A0=C2=A0this patch series.
> * An unneeded initialization that I had added to
> rdma_rw_init_one_mr()
> =C2=A0=C2=A0=C2=A0=C2=A0has been left out again.
> * Corrected "Fixes" tag in the patch description where needed.
>=20
> The individual patches in this series are:
>=20
> 0001-IB-core-Make-rdma_rw_ctx_init-initialize-all-used-fi.patch
> 0002-IB-core-RDMA-RW-API-Do-not-exceed-QP-SGE-send-limit.patch
> 0003-IB-srpt-Limit-the-number-of-SG-elements-per-work-req.patch
> 0004-IB-srpt-Simplify-srpt_queue_response.patch
> 0005-IB-isert-Remove-an-unused-member-variable.patch
>=C2=A0

Thanks Bart, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-0gKy30deRpabn+kWOsC/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoMS0AAoJELgmozMOVy/dH7kQAL66BqduUUfmrOZ8DUoz4Vom
0Q1bXVZPPQB8nJU/xIgBCN9XSZcIOUzJGrXC9ok7JDVxruFNuC+b1m0gtu6lb6SR
gXLkxN0ksK7X38Qm4y072aFXMqzuWu35YzqD/63A/fMutuBwNXQwKpZwYmdokGpE
xOMR69xpqFWmnEp51zf2zjK+Fi5cvGua9OC2Fm6PLnNxpwEQ4ni4kw+PyTTWCVS1
4lHqxpCebTkz8D12TdPdFXyNuCFmHFqeAneQNNRXyqUJEmmmYTE1l1tN9qMBsU9K
MWyz6IZ3GAkQQeRGaUJDiRTAHBNvnOv/tvoWP8TWBoFZpWA0qTYyWsPEsR/wMrNU
kv1KRy6mfk9fh9WQN9I0D3T/ZXFAXUw37J3ThvWyU1VgMuckrTw8Ro5IqDUKi7gj
C4xf4I3I7hRyU1j91oVn67xGIz0/iTjOPL34JBcU0mxGqcnPN4/IzaNiHCyrEqAK
7yMl4Ou0cVm006iSNUcv2vXIrm8sd7tRLJZt8EEyiAhOznfwZItp37KUhGTlE3lM
JA1kUewwR/N9rjpC1mR/8CQSDE6dwyf13+O8QW37+VsvEEzQPS5FRhWUlkkm9vet
cALk0TQITrVSs4mp0sSojtbaAKwx4e+zdHcRtm/F1Z5pAqqIKiKhAJRhIunlnuXV
ikLR3i4inLLOvIeJb2sy
=+ECd
-----END PGP SIGNATURE-----

--=-0gKy30deRpabn+kWOsC/--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
