From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Tue, 14 Jul 2015 23:05:06 -0400
Message-ID: <55A5CDE2.4060904@redhat.com>
References: <559F8BD1.9080308@dev.mellanox.co.il> <20150713163015.GA23832@obsidianresearch.com> <55A4CABC.5050807@dev.mellanox.co.il> <20150714153347.GA11026@infradead.org> <20150714155340.GA7399@obsidianresearch.com> <55A53CFA.7070509@dev.mellanox.co.il> <20150714170808.GA19814@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QnLHnJ7PFswNMJdfR739hmmD3sAmL0Hrl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150714170808.GA19814-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QnLHnJ7PFswNMJdfR739hmmD3sAmL0Hrl
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/14/2015 01:08 PM, Jason Gunthorpe wrote:
> On Tue, Jul 14, 2015 at 07:46:50PM +0300, Sagi Grimberg wrote:
>> Which drivers doesn't support FRWR that we need to do other things?
>> ipath - depracated
>=20
> We have permission to move this to staging and then RM it, so yay!

Correct.

>> mthca - soon to be deprecated
>=20
> This one I have a problem with. There is alot of mthca hardware out
> there, it feels wrong to nuke it.. If we can continue to support the
> FMR scheme it uses transparently, that would be excellent.
>=20
> I'm not hearing a strong reason why that shouldn't be the case...

I'm not so sure about deprecating mthca either.  There are still a
number of people I know that like to buy cheap SDR/DDR switches on EBay
and pair them with cheap mthca cards and have cheap 10/20GBit/s home
networks.  We have a couple people inside Red Hat that occasionally tell
people what to look for on EBay to do just this.

>> ehca - Not sure what is going on there. they only have phys_mr
>>        anyway, which just lost its only caller in the kernel
>=20
> I thought it supported fmr:
>=20
> drivers/infiniband/hw/ehca/ehca_main.c: shca->ib_device.alloc_fmr      =
     =3D ehca_alloc_fmr;
> drivers/infiniband/hw/ehca/ehca_main.c: shca->ib_device.map_phys_fmr   =
     =3D ehca_map_phys_fmr;
> drivers/infiniband/hw/ehca/ehca_main.c: shca->ib_device.unmap_fmr      =
     =3D ehca_unmap_fmr;
> drivers/infiniband/hw/ehca/ehca_main.c: shca->ib_device.dealloc_fmr    =
     =3D ehca_dealloc_fmr;
>=20
> ?
>=20
> I'm not sure what the status of ehca is, but I somehow suspect any
> remaining users are going to be on an old vendor kernel forever..

Nothing of note has been done on ehca for a long time, and I wouldn't be
surprised if there is some bit rot in this driver.  We need to speak
with IBM, but I think it's a candidate for future removal.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--QnLHnJ7PFswNMJdfR739hmmD3sAmL0Hrl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVpc3iAAoJELgmozMOVy/dgUoQAKNeDxNXFJGUl7oRRd5AVmMr
bhYexuOYwJHFNOcU70ShFxI7d2x70YxQaBd37yjxVDHuVNqhgxIdj2O6ELjIibu+
ZYhnMke25drfzY90M3CgC8zljx4P5bnmq9XjEjSMkI+vltPerd/aJj9T6S+xhmKs
8wufubOGsOvEhf+4QvdqFQzqRC+h46+Au0/haaOZTMqptyVnvZH+5bJx6h7YPv2s
p5e7Byo1KSL5LMRqrE8kZZRqHTYqJFq82jJTuyi1O4oAhPMK2JyPbnAbE6R2HGIU
4a2JzZHg+OVb0ldkPfxXT9BHg39bytoz1NWrR87jHvrTgKsAOSzhwYUxQcGZcB7Y
uFj4C1ojAmbHnuQma1jGazxv9OgYO4Kmmp02EtVPqv/Nr1epjvkEe6//ziMKtno/
E1gYiJVtUMQZu0l41r6gTYyLLJ1D1R5NeDEc5zuvJhWeYjaE9gC6mbnOtU+peC5O
bEYjZuycFQ588KDkDhQfr1dxHVkFOxO3hqXDIHsbtCzMqicP8REGJoju5rIcd0CT
MxuFKTiTCAe08K6UikCKYF2uObJq7pcNbqIaDxWD9J0fLg7IHylCwAl1+Q6POR4k
n2hOSaX+cH0DChtdDH5gtqkcTyfee2jJGyd114G0De6PgOI8CrF8JsThcdbp8IUn
+LMZMvl+OHD0yCL76H+K
=1ts2
-----END PGP SIGNATURE-----

--QnLHnJ7PFswNMJdfR739hmmD3sAmL0Hrl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
