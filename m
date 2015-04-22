From: Doug Ledford <dledford@redhat.com>
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
Date: Wed, 22 Apr 2015 16:58:59 -0400
Message-ID: <1429736339.121496.25.camel@redhat.com>
References: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
	 <20150421224601.GY5622@wotan.suse.de>
	 <20150421225732.GA17356@obsidianresearch.com>
	 <20150421233907.GA5622@wotan.suse.de>
	 <20150422053939.GA29609@obsidianresearch.com>
	 <20150422152328.GB5622@wotan.suse.de>
	 <20150422161755.GA19500@obsidianresearch.com>
	 <1429728791.121496.10.camel@redhat.com>
	 <20150422204637.GA29491@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-VQA/gkYPziMV8v3lRRct"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150422204637.GA29491@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>, Andy Lutomirski <luto@amacapital.net>, mike.marciniszyn@intel.com, infinipath@intel.com, linux-rdma@vger.kernel.org, awalls@md.metrocast.net, Toshi Kani <toshi.kani@hp.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Suresh Siddha <sbsiddha@gmail.com>, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Roland Dreier <roland@purestorage.com>, Juergen Gross <jgross@suse.com>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Borislav Petkov <bp@suse.de>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>, Davidlohr Bueso <dbueso@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Thomas
List-Id: linux-rdma@vger.kernel.org


--=-VQA/gkYPziMV8v3lRRct
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-04-22 at 14:46 -0600, Jason Gunthorpe wrote:
> On Wed, Apr 22, 2015 at 02:53:11PM -0400, Doug Ledford wrote:
>=20
> > To be precise, the split is that ipath powers the old HTX bus cards tha=
t
> > only work in AMD systems, qib is all PCI-e cards.  I still have a few
> > HTX cards, but I no longer have any systems with HTX slots, so we
> > haven't even used this driver in testing for 3 or 4 years now.  And
> > these are all old SDR cards, where the performance numbers were 800MB/s
> > with WC enabled, 50MB/s without it.
>=20
> Wow, I doubt any HTX systems are still in any kind of use.
>=20
> It would be a nice clean up to drop the PPC support out of this driver
> too. PPC never had HTX.

commit f6d60848baf9f4015c76c665791875ed623cd5b7
Author: Ralph Campbell <ralph.campbell@qlogic.com>
Date:   Thu May 6 17:03:19 2010 -0700

    IB/ipath: Remove support for QLogic PCIe QLE devices
   =20
    The ib_qib driver is taking over support for QLogic PCIe QLE
devices,
    so remove support for them from ib_ipath.  The ib_ipath driver now
    supports only the obsolete QLogic Hyper-Transport IB host channel
    adapter (model QHT7140).
   =20
    Signed-off-by: Ralph Campbell <ralph.campbell@qlogic.com>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

There you go.  It's been HTX only since 2010, and those cards were
already old then.  I think we should seriously consider deprecating and
then removing the driver.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--=-VQA/gkYPziMV8v3lRRct
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJVOAuTAAoJELgmozMOVy/d0LEQAMVVAGuJLGbahwXf7hHSTkRy
vEh/Pckd/ASMkXvSEaROZvUhuwAv59q5HnDcvf2+SOgFjf8D1M2gaCXRYB1Y+rEW
yfNK0wmubEDLw0wj8oh163X2/pzFtePJmYSVL486IMxkRrqSUllx+suvyOBStYu+
CUOMnwmef+KDMfvoNAoGAIyaz7OxBXGr9p4DZyHCu3FFU8QmHXpDOJ3HLiPIuylD
xdXrO1WeJ+eGYJJ9qzb+TSFjRsaXGkLXybE4B4PTm7wOFMDFvHftDaHBhk3D21u7
Icl0752jfUkXepELkmuj3j3TEWYNl/rjeAORP96T42cMmHSFapJuOYvdO6pMv7pE
78/evMJhFC/JLqbdzUbE5b6yMVEE6MKeH0lAvA/n+aGVURVD1yH5sG/iQk5m74+C
b4tlA2+vjjs4O6yFQnSrGCsPljaULe0TB/mgw9JVqI3e5Xf8tQzradTKSYw4MAYL
1Wf958c8eeTc0GEM/TJXFQJ5EX92uFgTrd1l/IWUVrGTMgvWvHITZ5ISGefMSLpk
/7M8hypKpXMaft22ljoAwoGrsChtGgc0k/h8/MQGkkAF9VLOiga635euFM9fESbd
l8WaVigHkWFco9O5gtBhlwObNCI1h9+2CXdGbDVmVlhcDFYbWFKoEx3IuqgL/A1q
cVkb0VlPI2SN5qomWpBc
=wa3i
-----END PGP SIGNATURE-----

--=-VQA/gkYPziMV8v3lRRct--
