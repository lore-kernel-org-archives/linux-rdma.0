From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] IB core: Display 64 bit counters from the extended
 set
Date: Wed, 16 Dec 2015 11:44:13 -0500
Message-ID: <567194DD.9020103@redhat.com>
References: <20151211182532.332343651@linux.com>
 <20151211182543.329283794@linux.com>
 <20151211235630.GG7855@phlsvsds.ph.intel.com>
 <20151212000047.GA9961@obsidianresearch.com>
 <566EEE69.5080906@dev.mellanox.co.il>
 <alpine.DEB.2.20.1512151351050.3509@east.gentwo.org>
 <20151215195554.GA28167@obsidianresearch.com>
 <5670717F.9090701@dev.mellanox.co.il>
 <20151215212035.GD28167@obsidianresearch.com>
 <56708961.1040505@dev.mellanox.co.il> <56708A19.8030403@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wMLTPGA0Fla8hTBKP1lL9xjXOEhRW1AOC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56708A19.8030403-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wMLTPGA0Fla8hTBKP1lL9xjXOEhRW1AOC
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/15/2015 04:46 PM, Doug Ledford wrote:
> On 12/15/2015 04:42 PM, Hal Rosenstock wrote:
>> On 12/15/2015 4:20 PM, Jason Gunthorpe wrote:
>>>> The unicast/multicast extended counters are not always supported -
>>>>> depends on setting of PerfMgt ClassPortInfo
>>>>> CapabilityMask.IsExtendedWidthSupportedNoIETF (bit 10).
>>
>>> Yes.. certainly this proposed patch needs to account for that and
>>> continue to use the 32 bit ones in that case.
>>
>> There are no 32 bit equivalents of those 4 "IETF" counters ([uni
>> multi]cast [xmit rcv] pkts).
>>
>> When not supported, perhaps it is best not to populate these counters =
in
>> sysfs so one can discern between counter not supported and 0 value.
>>
>> I'm still working on definitive mthca answer but think the attribute i=
s
>> not supported there. Does anyone out there have an mthca setup where
>> they can try this ?
>=20
> Yes.
>=20
>=20

=46rom my mthca machine:

[root@rdma-dev-04 ~]$ lspci | grep Mellanox
01:00.0 InfiniBand: Mellanox Technologies MT25208 InfiniHost III Ex
(Tavor compatibility mode) (rev 20)
[root@rdma-dev-04 ~]$ perfquery
# Port counters: Lid 36 port 1 (CapMask: 0x00)
PortSelect:......................1
CounterSelect:...................0x0000
SymbolErrorCounter:..............0
LinkErrorRecoveryCounter:........0
LinkDownedCounter:...............0
PortRcvErrors:...................0
PortRcvRemotePhysicalErrors:.....0
PortRcvSwitchRelayErrors:........0
PortXmitDiscards:................0
PortXmitConstraintErrors:........0
PortRcvConstraintErrors:.........0
CounterSelect2:..................0x00
LocalLinkIntegrityErrors:........0
ExcessiveBufferOverrunErrors:....0
VL15Dropped:.....................1
PortXmitData:....................2470620192
PortRcvData:.....................2401094563
PortXmitPkts:....................6363544
PortRcvPkts:.....................6321251
[root@rdma-dev-04 ~]$ perfquery -x
ibwarn: [29831] dump_perfcounters: PerfMgt ClassPortInfo 0x0; No
extended counter support indicated

perfquery: iberror: failed: perfextquery

So, no extended counters on this device.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--wMLTPGA0Fla8hTBKP1lL9xjXOEhRW1AOC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWcZTdAAoJELgmozMOVy/ddEEP/3u2HMbuBjUFUyR2hTqcSX+f
ARxMPLks8R/IooQLRG1gHZcmOCwmSUrZzpdhJN/8Kwa8oWA1P/s37ZagjUpv+2QE
c65RHWHET9AmMNVMdrJ4dkOSOkXlv7AIfqjpoYsYeAhmrebQJ8yXQbJ5QZV9V1iL
Biw6hVXi6aoPi4HsSUI09qBteyK7Ze8WGSfKk+hijs4zMR7xuRMdHE82DwrwpxnT
ZfR1yRa5jJdksTp1mEByu61gwjs98jF7XJxVD7OlJ790MjFmoUk4cFTHGoCI1/EQ
PweXq7XFe6YIoF0miiHagirEWsmS1rszBbiaOxvQLhfUwUB+/L3whEYqnTPoe+nE
m0KJ6xY5gCgBKlRnfhGUEPD4v19BCyHomos/ezzdhqBpB77ZoXOQw5KhyLUJ2mHN
bkjm3MgwILsQTbzgD76YYWOGLorBkuMacNZaK11d26+wh8JV6x8T08jg5reOQGle
/Nzs76Jp1x/dVHZkr17Ka0Qj6kflKhWEcl+8VxwXe7JFV7Z/W8zI7Lyyw5n92Mut
YOOLdLKF/cxcYfw1bduNnigpRPlYBGXELILSoxjDI+8in5C5rxOMhuvP2gQif+RC
jIF/rJiUt42u/09h3DjDknxMva3DgMEcXf/MwS9dxiFynEzWIRGXs7FQMpaUJfAj
v6fzXF6D7ywa4DN9jVD5
=Nu2L
-----END PGP SIGNATURE-----

--wMLTPGA0Fla8hTBKP1lL9xjXOEhRW1AOC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
