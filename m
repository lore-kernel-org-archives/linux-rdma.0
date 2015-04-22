From: Doug Ledford <dledford@redhat.com>
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
Date: Wed, 22 Apr 2015 15:10:41 -0400
Message-ID: <1429729841.121496.15.camel@redhat.com>
References: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
	 <20150421224601.GY5622@wotan.suse.de>
	 <20150421225732.GA17356@obsidianresearch.com>
	 <20150421233907.GA5622@wotan.suse.de>
	 <20150422053939.GA29609@obsidianresearch.com>
	 <20150422152328.GB5622@wotan.suse.de>
	 <20150422161755.GA19500@obsidianresearch.com>
	 <1429728791.121496.10.camel@redhat.com>
	 <20150422190520.GL5622@wotan.suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-dCjLMPsKMR7z2C2qa+3g"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150422190520.GL5622@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Andy Lutomirski <luto@amacapital.net>, mike.marciniszyn@intel.com, infinipath@intel.com, linux-rdma@vger.kernel.org, awalls@md.metrocast.net, Toshi Kani <toshi.kani@hp.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Suresh Siddha <sbsiddha@gmail.com>, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Roland Dreier <roland@purestorage.com>, Juergen Gross <jgross@suse.com>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Borislav Petkov <bp@suse.de>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>, Davidlohr Bueso <dbueso@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
List-Id: linux-rdma@vger.kernel.org


--=-dCjLMPsKMR7z2C2qa+3g
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-04-22 at 21:05 +0200, Luis R. Rodriguez wrote:

> > > I'd also love to remove the driver if it turns out there are actually
> > > no users. qib substantially replaces it except for a few very old
> > > cards.
> >=20
> > To be precise, the split is that ipath powers the old HTX bus cards tha=
t
> > only work in AMD systems,
>=20
> Do those systems have PAT support? CAn anyone check if PAT is enabled
> if booted on a recent kernel?

I don't have one of these systems any more.  The *only* one I ever had
was a monster IBM box...I can't even find a reference to it any more.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--=-dCjLMPsKMR7z2C2qa+3g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJVN/IxAAoJELgmozMOVy/du3IP/0Jpym1XlEaHbs8VPW5eIUeo
nBmjI+u83HHMdlRCxRUmVK0gPTaenrb1DrJamOd7pLPJpUnjHkwtJXDWCwUabtws
Thf2UfXuTto2vVsrAeTjh7F2d/rZALxpbkUFVtbD+gnXY+ahLNaR483X1YxUQJdW
E6mm/C8HYt1ULIPO8b3I6yCzTZ9T6JLliSL0P5A5KTTbCM4jp6U58MHH/Bchsydr
EtsEe22MViZGecr1vk/gXS0cFSGrQZDIExiNHlBPf+N1OlxXRCoub3yz9DcwTSAR
Fe3poICUtYsy3TYUjYyj48AvrJr3bvgenAlwMYVmA2aqd3DEzDj9sQ6s+fMWjp/R
vg5PAuxxqMvcv7hXi4mGfuB1Z9HnK9aP3Hp2sds6eK9rj2Gd2WQmqWlgMgVbHk/i
3G/NIZJjg3dobC2kZJuphNUgh7Exp1v9pVHjSnf4yekcGXsLDqiX6XOJ38z7vmkO
KtyMT//On8RxbCHB05pOf22zts5skuD8Z37kEAiV3taJt3r2Jh6tXXdv3LaR/E4o
dXk8DDKoyht5lKTfPk8CcGqtwQZGNwaBk0qQQ2i4D8oPbMd7Pf/REDxZx1uMF0MS
dEZolMpUfGkamtS/bmiY3vCwOKHWSeT8+MwVqbiue2MX8zO02o4c8sIElHDWJoSj
q/f0BgRKCKwzM3R8zPr2
=MKRB
-----END PGP SIGNATURE-----

--=-dCjLMPsKMR7z2C2qa+3g--
