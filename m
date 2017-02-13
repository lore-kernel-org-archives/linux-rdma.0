From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/8] IB/srp: Avoid that duplicate responses trigger a
 kernel bug
Date: Mon, 13 Feb 2017 07:54:32 +0200
Message-ID: <20170213055432.GM14015@mtr-leonro.local>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com>
 <20170210235611.3243-2-bart.vanassche@sandisk.com>
 <20170212170537.GE14015@mtr-leonro.local>
 <1486930017.2918.3.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YS7t75H5cNTCpbja"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1486930017.2918.3.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Feeley <Steve.Feeley-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--YS7t75H5cNTCpbja
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 12, 2017 at 08:07:13PM +0000, Bart Van Assche wrote:
> On Sun, 2017-02-12 at 19:05 +0200, Leon Romanovsky wrote:
> > On Fri, Feb 10, 2017 at 03:56:04PM -0800, Bart Van Assche wrote:
> > > diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> > > index 79bf48477ddb..4068d34f5427 100644
> > > --- a/drivers/infiniband/ulp/srp/ib_srp.c
> > > +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> > > @@ -1899,7 +1899,14 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp)
> > >  		scmnd = scsi_host_find_tag(target->scsi_host, rsp->tag);
> > >  		if (scmnd) {
> > >  			req = (void *)scmnd->host_scribble;
> > > -			scmnd = srp_claim_req(ch, req, NULL, scmnd);
> > > +			if (req) {
> > > +				scmnd = srp_claim_req(ch, req, NULL, scmnd);
> > > +			} else {
> > > +				shost_printk(KERN_ERR, target->scsi_host,
> > > +					     "NULL host_scribble for response with tag %#llx\n",
> > > +					     rsp->tag);
> > > +				scmnd = NULL;
> > > +			}
> > >  		}
> > >  		if (!scmnd) {
> > >  			shost_printk(KERN_ERR, target->scsi_host,
> >
> > You have the chance to print the message below together with your new
> > print, because scmd will be NULL.
> >
> > What about to do the following check "if (scmd && scmd->host_scribble)"
> > instead of your proposed patch?
>
> That approach would still trigger a kernel oops if a duplicate response is
> received because the second argument of srp_claim_req() must not be NULL.

I'm sure that I'm missing something, but how would it be triggered?
We will enter to call second srp_claim_req() function only if "req" is
not NULL.

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 79bf48477ddb..40e7f27c40bf 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1897,10 +1897,12 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp)
 		complete(&ch->tsk_mgmt_done);
 	} else {
 		scmnd = scsi_host_find_tag(target->scsi_host, rsp->tag);
-		if (scmnd) {
+		if (scmnd && scmnd->host_scribble) {
 			req = (void *)scmnd->host_scribble;
 			scmnd = srp_claim_req(ch, req, NULL, scmnd);
 		}
+		else
+			scnmnd = NULL;
 		if (!scmnd) {
 			shost_printk(KERN_ERR, target->scsi_host,
 				     "Null scmnd for RSP w/tag %#016llx received on ch %td / QP %#x\n",

>
> Bart.
> Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:
>
> This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.

--YS7t75H5cNTCpbja
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlihShcACgkQ5GN7iDZy
WKdtUw/8DL+homvnX3jq7Np+tC4bYH3/fHC9DOTZAYfGkT8TqdsBrjDIDolONWCy
FrPMMeQ96OVA+KLYIYvqEdAE2+LhFQStNuXYuVzwWE8x78CnLh6zxtsso48rDH9w
0zHBbUCSVq66y3ya9bwmeYkPTuCQeK6gX3R5Mz37LsMRuqvINzDo0aOsKSCe3wLV
yXOjvPQFFfxJ65D/n5/BAwe8OTmoVioGVboOLDqMK9SEmR/mcsKSx6AbRmsx6/26
f4zdDFWt/W+51auTJm8IYp10s0VsP6SkJLXkBo7xVn39wqkrit64D10TMfpteRNc
RmI+xzSiPKZdPcSc3HtUhagimB/Nwnv9AdlXFUdTTkT0lHaVa1rZWdAelocZ3VWR
bfGwdwyJ7M1pMoU/NnN24zkHhcDThjBlXLSbYA8tqb7jKdtl8PshvoMfylzvlUYi
ca4eZwoJ8XcuEmrO4J29UGbxM/kepJZsG679xsY0fQLxaBiHvOuOWBZgG2YbcC0G
EcxbC6z2oatnF8tMtJ+WScs7m5hqyuMdFTjEVwsDEEO+04+rw4bO9LsEZAN/6Uw+
YwfU2cLsROQ87tQsux0ORs+TcpA3dX9v1NYtbgGdp4wI54HMzmgFy7mU37KlFo+G
/e/jyGhFik0YEcHE+kHHeJBmu5awJ38FAg4PTm5JLEuQ5iVimYs=
=tx6n
-----END PGP SIGNATURE-----

--YS7t75H5cNTCpbja--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
