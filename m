From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] [RFC] IB/hfi1: Fix port ordering issue in a multiport
 device
Date: Wed, 11 Jan 2017 09:12:52 +0200
Message-ID: <20170111071252.GV7218@mtr-leonro.local>
References: <148409267200.13402.16060755922068447437.stgit@tstruk-mobl1.ra.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wxIXENaY2CYUgF8u"
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <148409267200.13402.16060755922068447437.stgit@tstruk-mobl1.ra.intel.com>
Sender: linux-pci-owner@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, dennis.dalessandro@intel.com, ira.weiny@intel.com
List-Id: linux-rdma@vger.kernel.org


--wxIXENaY2CYUgF8u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 10, 2017 at 03:57:52PM -0800, Tadeusz Struk wrote:
> Some hardware have multiple HFIs within the same ASIC. In some devices the
> numbers labeled on the faceplate of the device don't match the PCI bus
> order, and the result is that the devices (ports) are probed in the opposite
> order of their port numbers. The result is IB device unit numbers are in
> reverse order from the faceplate numbering. This leads to confusion, and
> errors.

Can't you recognize such device at the initialization phase?
This is definitely specific HW implementation bug/issue/limitation.

> We can fix this by enforcing the correct port order at module load time.
> To reorder the ports to match the numbering labels on the back of the
> device we need to delay registering devices with the ib_core until we
> receive a probe for the affected devices, reorder them and start
> initialization in the correct order later. We use a timer with 1 second
> timeout. On hfi1 probes devices are ordered and stored in a list.
> Each hfi1 probe updates the timer. When the timer timeouts all devices are
> initialized and registered with ib_core in the right order.
> When there will more than one second time gap between hfi1 probes,
> the timer will be update in each call so there is no danger that a device
> will be "missed".
>
> A new module param called port_reorder is introduced to cover users, who
> already prewired their clusters in the 'invalid' order. The default
> behavior does not change and results in devices ordered in the PCI bus
> order. Port_reorder=1 is used to apply special reordering to these devices.

I always had an impression that module parameters are rarely beneficial
in upstream kernel for driver modules and adding them for new driver
code should be explicitly prohibited in CodingStyle guide.

You are adding new module parameter which will be with us forever to fix
special HW bug/implementation in some legacy installations. It will be
insane to add such thing to upstream kernel, errata and out-of-tree
implementations are best places for such things.

Thanks

--wxIXENaY2CYUgF8u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh12vMACgkQ5GN7iDZy
WKfakA//e66PTutXEHUMznuovRZCXZUp/wklPWHguGB9XbrBV7t8Z9xM2jVlo/yn
6o2loiGZmMMAN8zxrcTghJcfIs7fCkpsXbOF1DPdxEjFnj8O68D86psVrDc3JhdJ
rLQ3QW5CfxeCE6UK69QhAG8kz5fN8HYBUDKhc2qhyn8xLpcBtDOvZLBVEiFpqlQp
ykGIlcm3ovHd1FU/SV2IyOh74LDOn3u1l9vFZk9T96uvLjvYIfQrdT1B8GwZ+gy1
xQOvCzFtwQMJvlx3FrH9GygmTwsufEJLMEWFIq8gaRu7O0ZKUhjVnfGp8c6yD9/E
OIlegZvcxyO/k3KUFHhjnX1ETsGfpeaajTEnnVxQxrSDBcaql9FSTP3Y008rwp5A
ON1VJpZdcrGY/RDK6lIs+zIu0wxE+TGye2wzeXRuYTAzzr/uTcqSkOhT6/MoPRaD
4eniS///igPEqdImrunTRPew8qwJNwA7O3+ZQpBsNLntase3ZUXItj/dFxLVHpfr
dqV75zt/9FDWDiWIAhRR4JfyGUtDmkCF6znpOxJbSzbRvl03YZDyJuTdr0X2PIxi
ra0ac5y1D9RlLetRyc+2yUZtAd6pZwrey+SbGx+nCD0l3V6kkv82A2FLecQwRV4j
Ddthc3gDvZBhW1xQ8kfa6kWmxJG2aulY2Poh0Wl3E4frFmVtg/E=
=blXo
-----END PGP SIGNATURE-----

--wxIXENaY2CYUgF8u--
