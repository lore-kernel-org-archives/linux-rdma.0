From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ib/cm: Change reject message type when destroying cm_id
Date: Fri, 15 May 2015 12:40:34 -0400
Message-ID: <1431708034.29187.14.camel@redhat.com>
References: <1431632941-3430-1-git-send-email-sean.hefty@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-cT0vBD0Cv6ymf81G2P45"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431632941-3430-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ted Kim <ted.h.kim-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-cT0vBD0Cv6ymf81G2P45
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-05-14 at 12:49 -0700, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ted Kim <ted.h.kim-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>=20
> Problem reported by: Ted Kim <ted.h.kim-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>:
>=20
> We have a case where a Linux system and a non-Linux system are
> trying to interoperate.  The Linux host is the active side and
> starts the connection establishment, but later decides to not go
> through with the connection setup and does rdma_destroy_id().
>=20
> The rdma_destroy_id() eventually works its way down to cm_destroy_id()
> in core/cm.c, where a REJ is sent. The non-Linux system
> has some trouble recognizing the REJ because of:
>=20
> A. CM states which can't receive the REJ
> B. Some issues about REJ formatting (missing comm ID)
>=20
> ISSUE A: That part of the spec says, a Consumer Reject REJ can be
> sent for a connection abort, but it goes further
> and says: can send a REJ message with a "Consumer Reject"
> Reason code if they are in a CM state (i.e. REP
> Rcvd, MRA(REP) Sent, REQ Rcvd, MRA Sent) that allows
> a REJ to be sent (lines 35-38).
>=20
> Of the states listed there in that sentence, it would
> seem to limit the active side to using the Consumer Reject
> (for the abort case) in just the REP-Rcvd and MRA-REP-Sent
> states. That is basically only after the active side
> sees a REP (or alternatively goes down the state transitions
> to timeout in which case a Timeout REJ is sent).
>=20
> As a fix, in cm-destroy-id() move the IB-CM-MRA-REQ-RCVD case
> to the same as REQ-SENT.  Essentially, make a REJ sent after
> getting an MRA on active side a timeout rather than Consumer-
> Reject, which is arguably more correct with the CM state
> diagrams previous to getting a REP.
>=20
> Signed-off-by: Ted Kim <ted.h.kim-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Sean, a few questions:

Are you proposing for 4.1-rc?
I assume this passed testing on the linux/non-linux setup?
Was it tested in a similar situation on linux/linux setup?  How do we
handle this specific rej scenario?
Did you intend to add an ISSUE B: section to the commit message?

> ---
>  drivers/infiniband/core/cm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
> index e28a494..346243e 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -862,6 +862,7 @@ retest:
>  		cm_reject_sidr_req(cm_id_priv, IB_SIDR_REJECT);
>  		break;
>  	case IB_CM_REQ_SENT:
> +	case IB_CM_MRA_REQ_RCVD:
>  		ib_cancel_mad(cm_id_priv->av.port->mad_agent, cm_id_priv->msg);
>  		spin_unlock_irq(&cm_id_priv->lock);
>  		ib_send_cm_rej(cm_id, IB_CM_REJ_TIMEOUT,
> @@ -880,7 +881,6 @@ retest:
>  				       NULL, 0, NULL, 0);
>  		}
>  		break;
> -	case IB_CM_MRA_REQ_RCVD:
>  	case IB_CM_REP_SENT:
>  	case IB_CM_MRA_REP_RCVD:
>  		ib_cancel_mad(cm_id_priv->av.port->mad_agent, cm_id_priv->msg);


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-cT0vBD0Cv6ymf81G2P45
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVViGCAAoJELgmozMOVy/dYUcP/jvYkwqLvwXvlYCdx0qGhzgo
D7joRV0CnkXF1JaQni6iazE2Yvu7Xk1Qwq+tYauviiBlwxZZCW5nby6suodiErEQ
SUJUgoPY+lxZVXevFz8Ah5dgNVrIzdKIwyUzYkvc5HR9BdKKh3303yIFIFzRwKMV
pLGzsGjKDOCLDBQqO/zNSg9ibKwUmQswJWfZYpPYNZbcr4lWG9uFlpxJEL5DPBBb
JzbBE9WIG0vX7G6t46o3ZmxRe6zrNeurDG/7CGOQMo8u8ghmBWkaaOQIQ/ZWDE3g
namPsB9d971MSR3x/h/44S1mhMq1e/XUlfsdOARl7oc23KpZ3W3v4Rs18SJAF4VP
aEN5zKEGIrWYNKPBq9dxbo8T2Xh4pW+ykmBy+qYp/geAigPAx0Mjlmxdhml4IYYA
KZ1omijjo9LhOB8piYnA51Dy7qQUCOPcMmcAFucgqCbUnY2lmYgFQq0IFhOeVM/L
rNNAlMzSLNpDHDIyZ6OS9qEedFzYCCr9w0GCmkAfvpJbvge17KMTykjmTj//hc+j
tiOL+jjadXWSdAEfeko0NPNSHn1qXCoh2vduyxY5eeXBOuR7cTBhstdtOeYdigph
jWyHhq31fBznOiRdtURlAR6PbM1lcrrsewAzeha5mMrdMkQrfPIZlE35AbxYG1Jv
NHJ7cJ1VOEo88nr+3fWw
=rNZv
-----END PGP SIGNATURE-----

--=-cT0vBD0Cv6ymf81G2P45--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
