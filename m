From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: Re: [GIT PULL] please pull infiniband.git
Date: Mon, 21 May 2012 13:39:56 +1000
Message-ID: <20120521133956.6168924f2c3b0bc072a77dbd@canb.auug.org.au>
References: <1337562868-9887-1-git-send-email-roland@kernel.org>
	<20120521120526.fcd34b38fa4d21fdfd28728b@canb.auug.org.au>
	<CAG4TOxPpNxFvR_8GkAJ6erDBHBUQzQe3ReFKnK6gBkfAYhRMeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_May_2012_13_39_56_+1000_29GEBJ.WLHKYe_ie"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxPpNxFvR_8GkAJ6erDBHBUQzQe3ReFKnK6gBkfAYhRMeQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--Signature=_Mon__21_May_2012_13_39_56_+1000_29GEBJ.WLHKYe_ie
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Roland,

On Sun, 20 May 2012 19:35:30 -0700 Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Sorry about that. Which commit in particular?  The vmalloc one?
> What's the error?

Yeah, the vmalloc patch - see my linux-next build error report.  Its just
missing an include.

--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org

--Signature=_Mon__21_May_2012_13_39_56_+1000_29GEBJ.WLHKYe_ie
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPubkMAAoJEECxmPOUX5FEM54P+QEnToJEOw0BqUm4n1fyVFwl
hpM+Yo/Ro/aK+4KNJoQ6QcS8g59ojKd6CZFNQg8wqZxC11bD3os6gB89cHMQWb73
E2HdfGN5V8sZtscUDf8UOAlfb/aMQemiG9wEjnhjd5Dn976dl6hskeMYTvYittQ/
OJD3e02AlTBRTqiDG/BH1QvXGyUJ3LR2jWv+acK6lFOHTA2PCR7nOlDZ3k1E9wWA
qrDtz9PGy+I2hvODapUnENmz1mWJofm+C85quACjDSyR6w7Cz9rtqcAVuaErE1f3
+q89aT85YCxz75P/iGydRKgTr2QSZ/bks5GlSueJOXJASWk3fFBG3L4CiO1AwAbG
sg+38QNqNxhe20dJQpAyR4YtNPCJHDrpuTflyANmbpvwY5Vq8Ch2xyvFRqnoA7CF
CYw5lWNucvrbZm85Dohd913wyFkcoxjmNWMFFsCFRq5MWz6IbZshBpFN2FCMDmC7
ctsgX0EIxz/28JHROBik6XEL3ANsyCjmRKVAL1fZdphFWABMybNCUuXonbROkOuI
xz87jkdLkFfzmSF4XZKDFNJSPe3C+g34sfZi7eCNBCkVoua2QHMNzaD0E5GAjs1s
9bpUziNACAJxuaTGSkDnPE/s7YvJSw1CxV1NE1lZ+wqSNGKA9K2uw0PsswN67TnD
bgsAp85xI8xAwNKbqiU/
=EJ04
-----END PGP SIGNATURE-----

--Signature=_Mon__21_May_2012_13_39_56_+1000_29GEBJ.WLHKYe_ie--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
