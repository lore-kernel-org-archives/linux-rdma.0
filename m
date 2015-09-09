From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Tue, 8 Sep 2015 22:50:42 -0400
Message-ID: <55EF9E82.70405@redhat.com>
References: <1441729478-19375-1-git-send-email-dledford@redhat.com>
 <CA+55aFzi+hhHuNcHjne_yYO+Dt4Gdkzs-U5y3fAJ8BDYWw4y=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3LTOliWp6IvAxpLe1UCJ7TaobsDto7dx3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFzi+hhHuNcHjne_yYO+Dt4Gdkzs-U5y3fAJ8BDYWw4y=Q@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3LTOliWp6IvAxpLe1UCJ7TaobsDto7dx3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 09/08/2015 08:21 PM, Linus Torvalds wrote:
> On Tue, Sep 8, 2015 at 9:24 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
>>
>> Matan Barak (5):
>>       net: Add info for NETDEV_CHANGEUPPER event
>=20
> Why the hell is this coming in through the infiniband tree? Especially
> with the networking tree having done the same thing differently?

Because the tree isn't buildable, let alone testable, without it.

> I see that Stephen Rothwell reported this almost two weeks ago, and
> informed you.

Yes, and he said he had a merge fixup and that it would carry forward.
I'm not real clear on how Stephen's stuff works, but when I'm told "I
can carry this going forward, no further action is needed on your part",
I took that at face value.

> The commit you send me, though, has been rebased since then, BUT IT
> STILL EXISTS.

Because I still need to be able to test.  Originally you had said you
wanted the root of my pull requests to be based on something clean, such
as a known stable rc point or some such.  But if I have to pull from
net-next in order to keep working on what I'm working on, that was a
no-no as I understood things.  Unfortunately, overlap between the net
tree and the rdma tree is an all too common occurrence and so I'm going
to need to work out a workflow that satisfies all the various parties in
regards to it.  Suggestions welcome.

> The commit is wrong, and you knew about it. So tell me, why the hell
> should I pull this shit?

I expected it to get fixed up properly by the merge commit Stephen was
carrying.  I haven't seen any good documentation on exactly how his tree
works and what actions I might take and whether they will break it or
keep it from doing what it was supposed to do, but since the fixup was
there and meant to take care of this, I left things as they were.  I
supposed I could have rebased and replaced that patch with the one in
Dave's tree.  Would that have been preferable?

> Oh, yes, I can fix it in the merge. This is not a "I can't resolve
> this pull request" email. Resolving it in favor of the existing
> networking infrastructure is easy.
>=20
> This is a "why should I even bother?" email.

Well, I expected it to be handled without much effort on your part and
the existing network infrastructure to be the final version.

> The two different commits have very similar logic, somewhat similar
> names, but the details are different. Both were written by somebody
> with a "mellanox.com" address.
>=20
> One huge glaring difference is that one of them went through the
> networking maintainer, which matters a great deal since this is a
> networking notifier.

Sure, I agree.

> I did the pull, did most of the resolve, but then decided that I don't
> even want to merge this considering how questionable it was.
>=20
> This needs a good explanation, because for now this pull request is dea=
d to me.

Is further explanation necessary, or have I answered your questions?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--3LTOliWp6IvAxpLe1UCJ7TaobsDto7dx3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV756CAAoJELgmozMOVy/dhSgQALOoJefGF3TCjU0hNE1auNgM
0/5mdYmsjKqpS/2acSLFPmqaKxnm9Uywo84b3olQaOBFx3cf4b1yYFElM8hra0hE
PWoH/oWPwCsAFGRjeCo9ytcSpHn2rELDrRpW1I+Y/Ib1AC6miaXt2Omw6SQ9ONNY
SM/Yq1eF2wjxRMF3GGDNZ+Pupq8c5qytVUH30oiR7DOUbnu230opPYJnlMEyuo41
bds0bZzva5XsWpEvAJbr4VSB8FdVlLahKZyqBUMPlpTb7VjWLnufFwlNVzwwgL+k
uCJY78KHOcmr/3JNVBUwQH1ytWZKLEFYPeQgGASxcf2C0wrQRXXiB87s6iYIemQ5
iE5V4KVMhoTZa+v4xRTNjLE+9uuz5dc9mOZQ6jZ8Y5R7MsCtIq1wY4T48xk4rI7Q
SXOzYwWzNaYuy1O7BCzn/1gjfyDwtk33QsUcl6yzxokiPxey68kEuykpvL//aNsv
vKDLGDZoq0/az8eoqQuntHiEPt+igT9wJfSfPgoWLflP4C4JIRnIqCMKoC7zt2FY
4SeUxflzLKpG5U1RB5KlSQp8x6GpKVbWnFukQiLMCv8Bns3p03AhOufiUuKIpv01
hZlSSjHuK8l0YTuFrjpZ9MUJiIS/0A9cnojbpJ2RkGsKyR5TY13jgUJ/GG9ialJn
zqqLTutnew+eUBHoU12P
=61sE
-----END PGP SIGNATURE-----

--3LTOliWp6IvAxpLe1UCJ7TaobsDto7dx3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
