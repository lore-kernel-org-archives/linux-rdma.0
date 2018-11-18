From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH iproute2-next v3] rdma: Document IB device renaming option
Date: Sun, 18 Nov 2018 13:05:35 +0200
Message-ID: <20181118110535.GJ24359@mtr-leonro.mtl.com>
References: <20181104191122.11979-1-leon@kernel.org>
 <14063C7AD467DE4B82DEDB5C278E8663BE61B8E2@FMSMSX108.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oyqLL/JqMvClXZi1"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <14063C7AD467DE4B82DEDB5C278E8663BE61B8E2@FMSMSX108.amr.corp.intel.com>
Sender: netdev-owner@vger.kernel.org
To: "Ruhl, Michael J" <michael.j.ruhl@intel.com>
Cc: David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org


--oyqLL/JqMvClXZi1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 16, 2018 at 08:10:35PM +0000, Ruhl, Michael J wrote:
> >-----Original Message-----
> >From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> >owner@vger.kernel.org] On Behalf Of Leon Romanovsky
> >Sent: Sunday, November 4, 2018 2:11 PM
> >To: David Ahern <dsahern@gmail.com>
> >Cc: Leon Romanovsky <leonro@mellanox.com>; netdev
> ><netdev@vger.kernel.org>; RDMA mailing list <linux-rdma@vger.kernel.org>;
> >Stephen Hemminger <stephen@networkplumber.org>
> >Subject: [PATCH iproute2-next v3] rdma: Document IB device renaming
> >option
> >
> >From: Leon Romanovsky <leonro@mellanox.com>
>
> Hi Leon,
>
> After looking at this and Steve Wise's changes for the ADDLINK/DELLINK,
> it occurred to me that the driver that handed the name to ib_register_device()
> might be interested in knowing that this name change occurred.
>
> Are there plans to include a some kind of notify mechanism so drivers can
> find out when things like this occur?

At least for device rename, I don't see any real need for such event,
because drivers are not supposed to rely on names.

I would say that it is probably driver bug to rely on device name
during its execution.

>
> Is this something that should be done?

I think yes, we can extend ib_event to support more events than now,
but should we?

>
> Thanks,
>
> Mike
>
> >[leonro@server /]$ lspci |grep -i Ether
> >00:08.0 Ethernet controller: Red Hat, Inc. Virtio network device
> >00:09.0 Ethernet controller: Mellanox Technologies MT27700 Family
> >[ConnectX-4]
> >[leonro@server /]$ sudo rdma dev
> >1: mlx5_0: node_type ca fw 3.8.9999 node_guid 5254:00c0:fe12:3455
> >sys_image_guid 5254:00c0:fe12:3455
> >[leonro@server /]$ sudo rdma dev set mlx5_0 name hfi1_0
> >[leonro@server /]$ sudo rdma dev
> >1: hfi1_0: node_type ca fw 3.8.9999 node_guid 5254:00c0:fe12:3455
> >sys_image_guid 5254:00c0:fe12:3455
> >
> >Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> >---
> >Changelog:
> >v2->v3:
> > * Dropped "to be named" words from example section of man
> >---
> > man/man8/rdma-dev.8 | 15 ++++++++++++++-
> > 1 file changed, 14 insertions(+), 1 deletion(-)
> >
> >diff --git a/man/man8/rdma-dev.8 b/man/man8/rdma-dev.8
> >index 461681b6..7c275180 100644
> >--- a/man/man8/rdma-dev.8
> >+++ b/man/man8/rdma-dev.8
> >@@ -1,6 +1,6 @@
> > .TH RDMA\-DEV 8 "06 Jul 2017" "iproute2" "Linux"
> > .SH NAME
> >-rdmak-dev \- RDMA device configuration
> >+rdma-dev \- RDMA device configuration
> > .SH SYNOPSIS
> > .sp
> > .ad l
> >@@ -22,10 +22,18 @@ rdmak-dev \- RDMA device configuration
> > .B rdma dev show
> > .RI "[ " DEV " ]"
> >
> >+.ti -8
> >+.B rdma dev set
> >+.RI "[ " DEV " ]"
> >+.BR name
> >+.BR NEWNAME
> >+
> > .ti -8
> > .B rdma dev help
> >
> > .SH "DESCRIPTION"
> >+.SS rdma dev set - rename rdma device
> >+
> > .SS rdma dev show - display rdma device attributes
> >
> > .PP
> >@@ -45,6 +53,11 @@ rdma dev show mlx5_3
> > Shows the state of specified RDMA device.
> > .RE
> > .PP
> >+rdma dev set mlx5_3 name rdma_0
> >+.RS 4
> >+Renames the mlx5_3 device to rdma_0.
> >+.RE
> >+.PP
> >
> > .SH SEE ALSO
> > .BR rdma (8),
> >--
> >2.19.1
>

--oyqLL/JqMvClXZi1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJb8Ud/AAoJEORje4g2clinjz4P+gLR5lb/kROqgMAiJjjafE1E
Cnb8H0rmWNpIDOyTtZ4qqSWeB2gunZtcRxfcT5f5utwj3p1/v1g46uCWuAYRxCMt
OCCK2daM3s3txYgncc696IhOiq+nF2cd/75MM2LR75cdmdKr0br8pVnU6Xb03UCE
g/clxpP6mhvGeGTDGsbw2tqBpyvRbbCPMUzJV0fJKUezO2scLRkBs/IngWubVvES
zAZfeeb1VwdLt4FUny7NjSvUqP3VNsGuZzJNGUe5c3AwdHBsqiZLzByHLkU2NDXl
haOBzWgPb6eT4GXYvu1ewuPurmhfDvTggeeeAJO1WOQLGkQ3c8JIHg+APgoI5inR
BdQYlZ4jFhkEOI0p89gmDEaZnsqxCh1rGujZK23Y82zuDT+AFQHjzP2NuFIIIyUx
Ap6DwHZA+DOeSke4FQF1/50OE9z7eCfEK0WCkOCThhY7HP7Wak8zs3o3g37/JbGj
0e6cRiKOaByCI8Gu2wK40TqhmKlSRwDN3nGy3BFW27+D04MjrAHj6a3/88oKlWr5
BsyWYWZoL9Bo8uhp4S0tZCCAJBzyAbsqSWkzlUzLF7Y8b24gyQgo+/VJu97BL1kT
yaoT+Ho6eaoH7LBjycayxPJPAeAXSItUsmqHgiDTwQCTcPdnofyir4H+FLbzqjpV
iZp20JW8EeHdJ+EiWGpL
=TDhE
-----END PGP SIGNATURE-----

--oyqLL/JqMvClXZi1--
