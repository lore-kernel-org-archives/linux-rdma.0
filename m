From: Sasha Khapyorsky <sashak@voltaire.com>
Subject: [ofa-general] Re: [PATCH] 'ibcheckportwidth' : Exit if LWS is 1X
Date: Sat, 19 Sep 2009 21:08:26 +0300
Message-ID: <20090919180826.GJ13667@me>
References: <829ded920909152042y227a709u6e74ee05d6ff05@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <general-bounces@lists.openfabrics.org>
Content-Disposition: inline
In-Reply-To: <829ded920909152042y227a709u6e74ee05d6ff05@mail.gmail.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: Keshetti Mahesh <keshetti.mahesh@gmail.com>
Cc: OFED mailing list <linux-rdma@vger.kernel.org>, OFED mailing list <general@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

On 09:12 Wed 16 Sep     , Keshetti Mahesh wrote:
> Fix: Modify ibcheckportwidth to exit if LWS is 1X instead of processing
> next lines.
> Trivial: ibcheckportwidth man page cosmetic change

Again, the patch is malformed. Please verify the patches before
submission.

>=20
> Signed-off-by: Keshetti Mahesh <keshetti.mahesh@gmail.com>
> ---
> infiniband-diags/man/ibcheckportwidth.8 =A0 =A0 =A0| =A0 =A02 +-
> infiniband-diags/scripts/ibcheckportwidth.in | =A0 =A02 +-
>=20
> diff --git a/infiniband-diags/man/ibcheckportwidth.8
> b/infiniband-diags/man/ibcheckportwidth.8
> index 85c06fc..c368467 100644
> --- a/infiniband-diags/man/ibcheckportwidth.8
> +++ b/infiniband-diags/man/ibcheckportwidth.8
> @@ -4,7 +4,7 @@
> =A0ibcheckportwidth \- validate IB port for 1x link width
>=20
> =A0.SH SYNOPSIS
> -.B ibcheckport
> +.B ibcheckportwidth
> =A0[\-h] [\-v] [\-N | \-nocolor] [\-G] [\-C ca_name] [\-P ca_port]
> =A0[\-t(imeout) timeout_ms] =A0<lid|guid> <port>
>=20

This chunk appears already in the previous patch.

> diff --git a/infiniband-diags/scripts/ibcheckportwidth.in
> b/infiniband-diags/scripts/ibcheckportwidth.in
> index 32c5c5e..60a0892 100644
> --- a/infiniband-diags/scripts/ibcheckportwidth.in
> +++ b/infiniband-diags/scripts/ibcheckportwidth.in
> @@ -103,7 +103,7 @@ function blue(s)
> =A0}
>=20
> =A0# Only check LinkWidthActive if LinkWidthSupported is not 1X
> -/^LinkWidthSupported/{ if ($2 !=3D "1X") { next } }
> +/^LinkWidthSupported/{ if ($2 =3D=3D "1X") { exit } }

Applied (by hands). Thanks.

Sasha

> --
> 1.6.4.2
>=20
> --
> Keshetti Mahesh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
