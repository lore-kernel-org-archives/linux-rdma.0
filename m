From: David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] PCI: Add no-D3 quirk for Mellanox ConnectX-[45]
Date: Fri, 4 Jan 2019 14:44:01 +1100
Message-ID: <20190104034401.GA2801@umbus.fritz.box>
References: <20181206041951.22413-1-david@gibson.dropbear.id.au>
 <20181206064509.GM15544@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181206064509.GM15544@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: davem@davemloft.net, saeedm@mellanox.com, ogerlitz@mellanox.com, tariqt@mellanox.com, bhelgaas@google.com, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, alex.williamson@redhat.com, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, sbest@redhat.com, paulus@samba.org, benh@kernel.crashing.org
List-Id: linux-rdma@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 06, 2018 at 08:45:09AM +0200, Leon Romanovsky wrote:
> On Thu, Dec 06, 2018 at 03:19:51PM +1100, David Gibson wrote:
> > Mellanox ConnectX-5 IB cards (MT27800) seem to cause a call trace when
> > unbound from their regular driver and attached to vfio-pci in order to =
pass
> > them through to a guest.
> >
> > This goes away if the disable_idle_d3 option is used, so it looks like a
> > problem with the hardware handling D3 state.  To fix that more permanen=
tly,
> > use a device quirk to disable D3 state for these devices.
> >
> > We do this by renaming the existing quirk_no_ata_d3() more generally and
> > attaching it to the ConnectX-[45] devices (0x15b3:0x1013).
> >
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > ---
> >  drivers/pci/quirks.c | 17 +++++++++++------
> >  1 file changed, 11 insertions(+), 6 deletions(-)
> >
>=20
> Hi David,
>=20
> Thank for your patch,
>=20
> I would like to reproduce the calltrace before moving forward,
> but have trouble to reproduce the original issue.
>=20
> I'm working with vfio-pci and CX-4/5 cards on daily basis,
> tried manually enter into D3 state now, and it worked for me.

Interesting.  I've investigated this further, though I don't have as
many new clues as I'd like.  The problem occurs reliably, at least on
one particular type of machine (a POWER8 "Garrison" with ConnectX-4).
I don't yet know if it occurs with other machines, I'm having trouble
getting access to other machines with a suitable card.  I didn't
manage to reproduce it on a different POWER8 machine with a
ConnectX-5, but I don't know if it's the difference in machine or
difference in card revision that's important.

So possibilities that occur to me:
  * It's something specific about how the vfio-pci driver uses D3
    state - have you tried rebinding your device to vfio-pci?
  * It's something specific about POWER, either the kernel or the PCI
    bridge hardware
  * It's something specific about this particular type of machine

> Can you please post your full calltrace, and "lspci -s PCI_ID -vv"
> output?

[root@ibm-p8-garrison-01 ~]# lspci -vv -s 0008:01:00
0008:01:00.0 Infiniband controller: Mellanox Technologies MT27700 Family [C=
onnectX-4]
	Subsystem: IBM Device 04f1
	Physical Slot: Slot1
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr+ Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 473
	NUMA node: 1
	Region 0: Memory at 240000000000 (64-bit, prefetchable) [size=3D512M]
	Capabilities: [60] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s unlimited, L1 unli=
mited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 0.000W
		DevCtl:	Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 512 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 8GT/s, Width x16, ASPM not supported
			ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 8GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- =
ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, OBFF Not Supp=
orted
			 AtomicOpsCap: 32bit- 64bit- 128bitCAS-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+, LTR-, OBFF Disabl=
ed
			 AtomicOpsCtl: ReqEn-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Compl=
ianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete+, Equaliza=
tionPhase1+
			 EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
	Capabilities: [48] Vital Product Data
		Product Name: 2-port 100Gb EDR IB PCIe x16 Adapter  =20
		Read-only fields:
			[PN] Part number: 00WT039
			[EC] Engineering changes: P40057
			[FN] Unknown: 30 30 57 54 30 37 35
			[SN] Serial number: YA50YF58P080
			[FC] Unknown: 45 43 33 46
			[CC] Unknown: 32 43 45 41
			[VK] Vendor specific: ipzSeries
			[MN] Manufacture ID: 532X4590060204=20
			[Z0] Unknown: 49 42 4d 32 31 39 30 31 31 30 30 33 32
			[RV] Reserved: checksum good, 0 byte(s) reserved
		End
	Capabilities: [9c] MSI-X: Enable- Count=3D128 Masked-
		Vector table: BAR=3D0 offset=3D00002000
		PBA: BAR=3D0 offset=3D00003000
	Capabilities: [c0] Vendor Specific Information: Len=3D18 <?>
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Device Serial Number ba-da-ce-55-de-ad-ca-fe
	Capabilities: [110 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+=
 ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 04, ECRCGenCap+ ECRCGenEn+ ECRCChkCap+ ECRCC=
hkEn+
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
	Capabilities: [170 v1] Alternative Routing-ID Interpretation (ARI)
		ARICap:	MFVC- ACS-, Next Function: 1
		ARICtl:	MFVC- ACS-, Function Group: 0
	Capabilities: [1c0 v1] #19
	Kernel driver in use: vfio-pci
	Kernel modules: mlx5_core

0008:01:00.1 Infiniband controller: Mellanox Technologies MT27700 Family [C=
onnectX-4]
	Subsystem: IBM Device 04f1
	Physical Slot: Slot1
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr+ Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 473
	NUMA node: 1
	Region 0: Memory at 240020000000 (64-bit, prefetchable) [size=3D512M]
	Capabilities: [60] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s unlimited, L1 unli=
mited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 0.000W
		DevCtl:	Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 512 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 8GT/s, Width x16, ASPM not supported
			ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 8GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- =
ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, OBFF Not Supp=
orted
			 AtomicOpsCap: 32bit- 64bit- 128bitCAS-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+, LTR-, OBFF Disabl=
ed
			 AtomicOpsCtl: ReqEn-
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, Equaliza=
tionPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [48] Vital Product Data
		Product Name: 2-port 100Gb EDR IB PCIe x16 Adapter  =20
		Read-only fields:
			[PN] Part number: 00WT039
			[EC] Engineering changes: P40057
			[FN] Unknown: 30 30 57 54 30 37 35
			[SN] Serial number: YA50YF58P080
			[FC] Unknown: 45 43 33 46
			[CC] Unknown: 32 43 45 41
			[VK] Vendor specific: ipzSeries
			[MN] Manufacture ID: 532X4590060204=20
			[Z0] Unknown: 49 42 4d 32 31 39 30 31 31 30 30 33 32
			[RV] Reserved: checksum good, 0 byte(s) reserved
		End
	Capabilities: [9c] MSI-X: Enable- Count=3D128 Masked-
		Vector table: BAR=3D0 offset=3D00002000
		PBA: BAR=3D0 offset=3D00003000
	Capabilities: [c0] Vendor Specific Information: Len=3D18 <?>
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Device Serial Number ba-da-ce-55-de-ad-ca-fe
	Capabilities: [110 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+=
 ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 04, ECRCGenCap+ ECRCGenEn+ ECRCChkCap+ ECRCC=
hkEn+
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
	Capabilities: [170 v1] Alternative Routing-ID Interpretation (ARI)
		ARICap:	MFVC- ACS-, Next Function: 0
		ARICtl:	MFVC- ACS-, Function Group: 0
	Kernel driver in use: vfio-pci
	Kernel modules: mlx5_core


The problem is manifesting as an EEH failure (a POWER specific error
reporting system similar in intent to AER but entirely different in
implementation).  That's in turn causing the device to be reset and
the call trace from there.  There are bugs in the EEH recovery that
we're pursuing elsewhere, but the problem at issue here is why we're
tripping a hardware reported failure in the first place.

Given that, the trace probably isn't very meaningful (it's from the
recovery path, not the mlx or vfio driver), but fwiw:

[  132.573829] EEH: PHB#8 failure detected, location: N/A
[  132.573944] CPU: 64 PID: 397 Comm: kworker/64:0 Kdump: loaded Not tainte=
d 4.18.0-57.el8.ppc64le #1
[  132.574052] Workqueue: events work_for_cpu_fn
[  132.574083] Call Trace:
[  132.574100] [c0000037f54d38c0] [c000000000c9ceec] dump_stack+0xb0/0xf4 (=
unreliable)
[  132.574147] [c0000037f54d3900] [c000000000042664] eeh_dev_check_failure+=
0x524/0x5f0
[  132.574300] [c0000037f54d39a0] [c0000000000bf108] pnv_pci_read_config+0x=
148/0x180
[  132.574348] [c0000037f54d39e0] [c000000000731694] pci_read_config_word+0=
xa4/0x130
[  132.574393] [c0000037f54d3a40] [c00000000073aa18] pci_raw_set_power_stat=
e+0xf8/0x300
[  132.574438] [c0000037f54d3ad0] [c000000000743450] pci_set_power_state+0x=
60/0x250
[  132.574486] [c0000037f54d3b10] [d000000013561e4c] vfio_pci_probe+0x184/0=
x270 [vfio_pci]
[  132.574531] [c0000037f54d3bb0] [c00000000074bb3c] local_pci_probe+0x6c/0=
x140
[  132.574577] [c0000037f54d3c40] [c00000000015aa18] work_for_cpu_fn+0x38/0=
x60
[  132.574615] [c0000037f54d3c70] [c00000000015fb84] process_one_work+0x2f4=
/0x5b0
[  132.574660] [c0000037f54d3d10] [c000000000161190] worker_thread+0x330/0x=
760
[  132.574803] [c0000037f54d3dc0] [c00000000016a4fc] kthread+0x1ac/0x1c0
[  132.574842] [c0000037f54d3e30] [c00000000000b75c] ret_from_kernel_thread=
+0x5c/0x80
[  132.574894] EEH: Detected error on PHB#8
[  132.574926] EEH: This PCI device has failed 1 times in the last hour and=
 will be permanently disabled after 5 failures.
[  132.574981] EEH: Notify device drivers to shutdown
[  132.575011] EEH: Beginning: 'error_detected(IO frozen)'
[  132.575040] EEH: PE#fe (PCI 0008:00:00.0): no driver
[  132.575193] EEH: PE#0 (PCI 0008:01:00.0): Invoking vfio-pci->error_detec=
ted(IO frozen)
[  132.575253] EEH: PE#0 (PCI 0008:01:00.0): vfio-pci driver reports: 'can =
recover'
[  132.575514] EEH: PE#0 (PCI 0008:01:00.1): Invoking vfio-pci->error_detec=
ted(IO frozen)
[  132.575592] EEH: PE#0 (PCI 0008:01:00.1): vfio-pci driver reports: 'can =
recover'
[  132.575634] EEH: Finished:'error_detected(IO frozen)' with aggregate rec=
overy state:'can recover'
[  132.575684] EEH: Collect temporary log
[  132.575706] PHB3 PHB#8 Diag-data (Version: 1)
[  132.575734] brdgCtl:     0000ffff
[  132.575756] RootSts:     ffffffff ffffffff ffffffff ffffffff 0000ffff
[  132.575790] RootErrSts:  ffffffff ffffffff ffffffff
[  132.575933] RootErrLog:  ffffffff ffffffff ffffffff ffffffff
[  132.575973] RootErrLog1: ffffffff 0000000000000000 0000000000000000
[  132.576014] nFir:        0000808000000000 0030006e00000000 0000800000000=
000
[  132.576048] PhbSts:      0000001800000000 0000001800000000
[  132.576076] Lem:         0000020000080000 42498e367f502eae 0000000000080=
000
[  132.576111] OutErr:      0000002000000000 0000002000000000 0000000000000=
000 0000000000000000
[  132.576159] InAErr:      0000000020000000 0000000020000000 8080000000000=
000 0000000000000000
[  132.576327] EEH: Reset without hotplug activity
[  132.606003] vfio-pci 0008:01:00.0: Refused to change power state, curren=
tly in D3
[  132.606062] iommu: Removing device 0008:01:00.0 from group 0
[  132.636000] vfio-pci 0008:01:00.1: Refused to change power state, curren=
tly in D3
[  132.636057] iommu: Removing device 0008:01:00.1 from group 0
[  137.196696] EEH: Sleep 5s ahead of partial hotplug
[  142.236046] pci 0008:01:00.0: [15b3:1013] type 00 class 0x020700
[  142.236156] pci 0008:01:00.0: reg 0x10: [mem 0x240000000000-0x24001fffff=
ff 64bit pref]
[  142.236932] pci 0008:01:00.1: [15b3:1013] type 00 class 0x020700
[  142.237030] pci 0008:01:00.1: reg 0x10: [mem 0x240020000000-0x24003fffff=
ff 64bit pref]
[  142.238763] pci 0008:00:00.0: BAR 14: assigned [mem 0x3fe200000000-0x3fe=
23fffffff]
[  142.238940] pci 0008:01:00.0: BAR 0: assigned [mem 0x240000000000-0x2400=
1fffffff 64bit pref]
[  142.239021] pci 0008:01:00.1: BAR 0: assigned [mem 0x240020000000-0x2400=
3fffffff 64bit pref]
[  142.239112] pci 0008:01:00.0: Can't enable device memory
[  142.239417] mlx5_core 0008:01:00.0: Cannot enable PCI device, aborting
[  142.239476] mlx5_core 0008:01:00.0: mlx5_pci_init failed with error code=
 -22
[  142.239539] mlx5_core: probe of 0008:01:00.0 failed with error -22
[  142.239590] vfio-pci: probe of 0008:01:00.0 failed with error -22
[  142.239631] pci 0008:01:00.1: Can't enable device memory
[  142.241612] mlx5_core 0008:01:00.1: Cannot enable PCI device, aborting
[  142.241654] mlx5_core 0008:01:00.1: mlx5_pci_init failed with error code=
 -22
[  142.241716] mlx5_core: probe of 0008:01:00.1 failed with error -22
[  142.241762] vfio-pci: probe of 0008:01:00.1 failed with error -22
[  142.241800] EEH: Notify device drivers the completion of reset
[  142.241835] EEH: Beginning: 'slot_reset'
[  142.241856] EEH: PE#fe (PCI 0008:00:00.0): no driver
[  142.241884] EEH: Finished:'slot_reset' with aggregate recovery state:'no=
ne'
[  142.241918] EEH: Notify device driver to resume
[  142.241947] EEH: Beginning: 'resume'
[  142.241968] EEH: PE#fe (PCI 0008:00:00.0): no driver
[  142.241996] EEH: Finished:'resume'
[  142.241996] EEH: Recovery successful.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAlwu1n4ACgkQbDjKyiDZ
s5JX9Q/8CA/rISAhvU4Eq8gRDp77ckrWfRTHTZ4TRQx0KbHhpL7JrEMHDWopU3D3
iLLefExzSFMVEnbhyxrdHUE/lcDBQcnw7cJ/6C415///1m6rWbRrOasf7QGxflid
wfRfZBYHO+qHss5LuTzbxp3V3dMRUHe97f0vL45LIY533OkiKwxJWn+Mty6wYX1Q
4MP4CjWZArZt7yImxBi1Pco/FPJekU9DsyuQ8I0IdDJiUOIi3RiYx5QZt+TrZahK
XLnL001L7gvw8cbdoColwT4fLXRndge1wRQRtfoJwqerHhkL+HpR5pnxkR6v7zPb
NuCkhF/4FdvgRiK9cgBMMW26WwZGMu1lXQfz0yH7j4txBr1BeBSVy898HJxFgbHP
R+8i5/NwnJHtSCv1H9kBvmvydY1nwxMaQx0YUM6mRsw5PiKgfn09Bv8AtHB+4zvU
jSibfAlJWTobkchhw+TcNyL28tSvi6DPqiAmJhJayOpEtlInWTKOQVLBhoWftXRT
AQyu2pZ6WxKhp6KlG+cM9at5V+TuNHMueLHbg1OTlFkUja6ll+J377tYVpM+Yais
kUBfD0M2sEkz/FsQw9gJ1ppeSpB7jMs9We3TeWyAujRxYZaDrgVnIv6qSwZU4YWQ
f9cQn1boZ/yWex2LXGUGnaYzfa/6AIRJESoKZciPBVQ/h5fn//g=
=Dv4q
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
