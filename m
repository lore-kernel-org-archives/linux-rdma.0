From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 17/50] IB/hfi1: add PSM driver control/data path
Date: Fri, 31 Jul 2015 10:19:25 -0400
Message-ID: <55BB83ED.2010705@redhat.com>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
 <20150730191859.25256.28987.stgit@phlsvslse11.ph.intel.com>
 <20150730194041.GA28754@obsidianresearch.com>
 <32E1700B9017364D9B60AED9960492BC25777DA0@fmsmsx120.amr.corp.intel.com>
 <55BA9A38.2030401@redhat.com> <20150731073158.GA2485@infradead.org>
 <20150731082207.GT17109@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IQI67pR1h9SS9sQJCpUXAI38tu7EsfJ1T"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150731082207.GT17109-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IQI67pR1h9SS9sQJCpUXAI38tu7EsfJ1T
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/31/2015 04:22 AM, Al Viro wrote:
> On Fri, Jul 31, 2015 at 12:31:58AM -0700, Christoph Hellwig wrote:
>> On Thu, Jul 30, 2015 at 05:42:16PM -0400, Doug Ledford wrote:
>>> I have no problem with this code.  That Al finds the user space ABI f=
or
>>> this driver to be bizarre is neither here nor there to me.  Sure, thi=
s
>>> file does not exhibit normal file API behavior.  Who cares?
>>
>> Everyone who cares about filesystem semantics does.
>>
>> A NACK from me for a this features, and b) for trying to sneak it in
>> after a negative comment without cc to -fsdevel and Al.
>=20
> FWIW, the lack of comments appears to have tripped Doug, judging by his=

> "another option would be to drop the write function altogether and just=
 make
> all commands come through writev/write_iter and if you only have one co=
mmand,
> you only send one element".
>=20
> The thing is, ipath and qib (and AFAICS this one as well) have write(2)=
 and
> writev(2) take different and completely unrelated sets of commands.  On=

> the same file.  IOW, the effects of
> 	writev(fd, &(struct iovec){buf, len}, 1)
> and
> 	write(fd, buf, len)
> are not even remotely similar.  _That_ is the gratuitous weirdness I'd =
been
> unhappy with.  And yes, it is gratuitous - it's trivial to have separat=
e files
> for separate command sets.

Yes, admittedly I did think that the command sets were the same.
However, even with them not being the same, I still don't care.  This is
a private driver interface.  Nothing uses it but libpsm or libpsm2, both
of which are the mated user space libraries that implement the user side
of this interface.  It generally isn't intended for anyone else to use.
 If this were a public API, I would care.  It isn't.  All that *really*
matters here is that their kernel driver and user space library speak
the same language.

As for separate files, that presents its own issues, and for little to
no benefit.  Again, this isn't a public API.  It threw you for a loop
because it isn't what you expected.  But that hardly matters, you aren't
writing a user space application to work with the thing.  It is,
however, exactly what the existing library expects.

> If you drop ->write() in there, you certainly lose the weirdness - alon=
g with
> one of those command sets.  Sure, having individual iovecs correspond t=
o
> separate datagrams is fine; tons of drivers are like that.  qib and ipa=
th
> are unique, though, in having *two* command sets overloaded on the same=
 file,
> with write() vs. writev() acting as selector (BTW, single-element AIO
> going like writev(), not like write()).

It sounds weird to someone who isn't used to it, but sounds perfectly
fine to someone used to it.  If this were a public API, I would care,
but this is Intel's private communication channel between their kernel
driver and their user space library.  I find it hard to justify telling
them they need to re-engineer both their kernel driver and their library
because a disinterested third party finds their particular means of
organizing their communications "weird".

> PS: I'm back after several weeks of being sick (recipe for fun: start w=
ith
> 40C in shade, get completely soaked in serious rain, then have half an =
hour
> cab ride, with AC set to ~15C) and while I'd managed to get the mailbox=

> down to relatively sane size, I might have easily deleted more than I s=
hould
> have.  If there had been anything important sent my way and I don't rep=
ly to=20
> it by Saturday, please resend.
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--IQI67pR1h9SS9sQJCpUXAI38tu7EsfJ1T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVu4PtAAoJELgmozMOVy/djgAP/jmviKpJzt1agmtc02Gk/zai
EUyv+r+VPPxAZcg6jVz6rfUeddfjE59LHjnu2C/IZ70ZRLgTPWE1y/xnjpL9h1xj
LYwWn2qfIiC6IfpCoJYMV0fwAMWQE7ohaAEk2dQw1SYVoq0v6WkBmiumSC2R9gwt
W1EyeF9GHNv2jPsfJw3XZ+7RAC4HUEZW9NCUulSS+SVg114/8wV6kuv/Yylv0WhB
d1F9CtUijDNimhOB0x3A6c8KU4CkjVIm2UPH015kKMyBoXl5wARsojuV8JEAmdg1
vpWtnS7EON4+WF74UFkVEpE+8smEh5uNGLBTMDhobkKc79nZ0RoJWaWy2XqOqbLr
1+Qo6RtHsHhtGe35gdglanz6/zIrtsZ2S//rzj+xQiVY+XGR4OahvGRwsRW+JqYH
zDV7DiYmEvhHC2jQwFCFRYhEwPRV0mGQXoQzoH5DSP5XhFsDKHoZ/f5QmszIbZdY
SjlGMUn+uz4d9zzFSqvYcaZM4lzOdbZwsZ5wSmP4EkNZC0UT2bYAJEHZFmp2PyGI
R8rho5NfVlqVsewod3FVlTn2ZMj5BI1QIIepbjQhLbIX4MaPgxYasHP7PlLU7CAZ
nhHQ/w5nfplhVOw9b4nNNRbl1Wmgxix9h0Nvam/bs0HbLCpH0wulJeM00PdFworv
vdfLBHi9Wmf3YX9VCsPG
=X0Xi
-----END PGP SIGNATURE-----

--IQI67pR1h9SS9sQJCpUXAI38tu7EsfJ1T--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
