From: 'Leon Romanovsky' <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [RDMA PATCH 16/16] i40iw: Adding queue drain functions
Date: Mon, 11 Apr 2016 07:50:37 +0300
Message-ID: <20160411045037.GF20252@leon.nu>
References: <1460046664-552-1-git-send-email-mustafa.ismail@intel.com>
 <1460046664-552-17-git-send-email-mustafa.ismail@intel.com>
 <20160408004638.GD20252@leon.nu>
 <20160408184448.GA12292@mustafai-MOBL>
 <018b01d191e4$21771b80$64655280$@opengridcomputing.com>
 <570AA8D0.2060404@grimberg.me>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gdTfX7fkYsEEjebm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <570AA8D0.2060404-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Mustafa Ismail' <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--gdTfX7fkYsEEjebm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 10, 2016 at 10:26:08PM +0300, Sagi Grimberg wrote:
> I do understand Leon when he sees 3 copies of this code, but all these
> copies are looking into the raw queue so I'm fine with it.

Despite the fact that I understand the reasoning behind this specific
implementation, it makes me wonder when will we see common implementation
for this type of queues?

We saw 3 similar implementations, in near future, we will get another
one and I believe that it won't stop there.

--gdTfX7fkYsEEjebm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXCy0dAAoJEORje4g2clinB3oQAIclXzyu0BdeazalHv3VPz23
JjOIBtcggHpDL4nnOUiHTKgg0AY2yzmcKrNB800c1Red3LwmMuTltmvsanoE7L4z
ve9Ghq3UMQaOY4iIRMCwiO3uA7XWkV2XtSdY1VcIhaunb8S1dGJhwp9nkHHZ+0r+
7nXootvsg3TEtTMcRnQNHb8yQi8yXRVXB0B2k0Yvw6JNrRYMpikoHDP20/+P3HA7
ab9FkvbCzciWW+hRkKLB1iHCN4P6RhQ+q/rWnfxj5HcwFKpqT5+ZMUDsTx+gNdkm
QOE/2LDMAsPm909pGVJikPCo6siYRoTEskLUjRJH+Fxl0+M52D4+SR/BuIE8tXmI
ZxPQOUuu3AcrHUGuMe4B5SB2oOUnMgIj4ZQL/tbT6NCCFGphhrjroInA7gm5gmd2
iT3DeUnN2nHHxPntnGNAPAeFFhXW5wmUe6Emv1HnAd2avD0A2WZam/UOARDEeAME
l9SpMOKhVn4RIMXTDA8v6Z+re44JR+rvvwyarDWw3fC7v/dCCQe0EzsfdWfzXzHz
9jkMg/rglClrVMCPaTIwxnpnZ+SVPKhX/y5tetJ8fWJxM24RWroBDybiX/gL5JE7
CDURwSOTLsitrYKzm5Xtcl3LIlpzk5PB8eA1WlkD5SrOyL8NjPpOvL3T/nvx3rB8
QBcKZvodKDO3IhrfPhCU
=gFrA
-----END PGP SIGNATURE-----

--gdTfX7fkYsEEjebm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
