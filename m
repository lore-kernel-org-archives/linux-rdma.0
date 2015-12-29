From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] Generic InfiniBand transport done in software
Date: Tue, 29 Dec 2015 11:37:08 -0500
Message-ID: <5682B6B4.60306@redhat.com>
References: <CAG9sBKO=fP2Xd=JXK7hvzGFRLQmh1dF+mWDxdnhU+TqFg7YD1Q@mail.gmail.com>
 <20151222181905.GA742@phlsvsds.ph.intel.com>
 <CAG9sBKNOu+d-5f6FYTXCyTGjJU-md4dW3MFMB2-UDgRFafRdBw@mail.gmail.com>
 <20151223200727.GA6886@phlsvsds.ph.intel.com>
 <CAG9sBKNkeA2Op-OTJ_MQ=pC3BQ7=_tB4g6oV=fwDOJ7gs_y+fQ@mail.gmail.com>
 <20151224161415.GA674@phlsvsds.ph.intel.com>
 <CAG9sBKNBDC=YymoYMLjW+RceChQXfNMXcc8UzJJVhqBuW5jGAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sB2a7e4Paw0vCSxJdoEnp51Ak1D96rftW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKNBDC=YymoYMLjW+RceChQXfNMXcc8UzJJVhqBuW5jGAQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sB2a7e4Paw0vCSxJdoEnp51Ak1D96rftW
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/27/2015 12:54 PM, Moni Shoua wrote:

>> Yes it is specific to Intel *now*, that doesn't mean it should stay th=
at
>> way. Rdmavt could, and in my opinion should, be extended to support
>> soft-roce. I don't think replicating the same thing is a great idea.
>>
> But you post *now* a so called generic driver so it must now fit any
> possible driver (including Soft RoCE)

This is incorrect.  This isn't some public API that we are exporting to
user space.  Nor is it an API that out of tree drivers are using.  This
is a purely kernel internal API for use by a limited number of drivers.
 As such, it need not be finalized before it is submitted or used.  It
can be taken one piece at a time, and if, at some point, it is
determined that there are shortcomings to the API, it can be updated in
place with all of the drivers that use it in a single patch or patch
series.  So a finalized design prior to putting code in place is
specifically *not* needed.

>> As to the location, where do you think it should go. drivers/infiniban=
d/sw
>> makes the most sense to me, but open to suggestions.
>>
>> And for the question of why publish when it's not ready, the better qu=
estion
>> is why not?  Is it not good to see the work in progress as it evolves =
so the
>> community can provide feedback?
>>
> What kind of a feedback you expect when I don't have an idea about
> your plans for rdmavt
> Interfaces, flows, data structures... all is missing from the
> documentation to rdmavt.

They released it so that you can start hooking SoftRoCE into it.  As you
hook it in, if it needs changes to work with SoftRoCE, simply make the
changes needed and move on.

I think Dennis' point, and I agree with him, is that you are over
complicating the issue here.  This need not be a highly designed item,
it needs to be a functional item, and we can build it as we go.  If you
have to make changes to rdmavt in order to hook up SoftRoCE, that's
fine, post them to the list, they will get reviewed.  As long as the
change doesn't break or otherwise negatively impact qib and/or hfi1,
then it should be fine.  If it does, then I'm sure Intel will work with
you to find a solution that doesn't negatively impact them.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--sB2a7e4Paw0vCSxJdoEnp51Ak1D96rftW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWgra0AAoJELgmozMOVy/dmVsP/jzJR3AmQ/w7wOAqHTCJK3w3
2ONbXc/T5LF0qbRklx7Hr+fYwbjcKQYg5A9MMfqvielnfzu1v9KQHwwRZ6rPUkwL
N5p2dTT2sRcHl2tibV9c31yyrP+ZYuWuMMtzAx1wGKz5XwgHGob/2Bm9Sl4CCVJ/
103XB34N2iCl9GpdAOsDCSMcjWb9m0J8Nkb0I+9lzz1/D8m027dz8Yq3AOyBSXyG
UfNhvK8BUXCwLfwt9GIUURNwcKqQ8CGrxZgB+QOfqi/nEsX2loeiV2lEyjDCfFVi
FEpsiTHetCHvbqPX0wc6+oVgs5b4FHcCwr/JeW5wvvwDL3IVnc/zl5BA8GFyQ+cL
HW9qHacTSlvyiMruPvr6yWcQyV1HpiZ0VrabP3SMDDCX8rOdV/TFDgGpgClY3cg/
bSUZjpTOk9GpLHfj7MxK08CBE9fKWeJLzUJOCosnqehESejNCOehoSZHKVUEwVIE
zwgayRuco5f5YxFF2LDdgM13ySijIIwJK3vJO6+j503rjR/EYzYS89uatm/SHhJH
V9SUhxLZmQ1/xkMvToaALm679/CzzF50uDKbrpERFfu2FnTdVjOwG9WYg8vZdFDT
dI40qjZ+HsYyE+9oRRDQAQmOn0KarBejhlQkJR2ip6NvhKq2H4OX1jXpKMJVIUp+
beTBMgzdE9wzIBDYHTlA
=7T0z
-----END PGP SIGNATURE-----

--sB2a7e4Paw0vCSxJdoEnp51Ak1D96rftW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
