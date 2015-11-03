From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V4
Date: Mon, 2 Nov 2015 22:14:06 -0500
Message-ID: <5638267E.3020408@redhat.com>
References: <1442157215-22341-1-git-send-email-hch@lst.de>
 <5631839B.30300@redhat.com> <56318B37.20207@redhat.com>
 <20151029115114.GA18466@lst.de> <56360148.8060608@mellanox.com>
 <20151101180609.GC13943@kroah.com> <5637EFC8.4010300@redhat.com>
 <20151102233726.GA18251@kroah.com> <5637F97C.5090205@redhat.com>
 <20151103004922.GA22926@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="osBsNovpTCq57eN60iner7iT5SsWQUEXX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151103004922.GA22926-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--osBsNovpTCq57eN60iner7iT5SsWQUEXX
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/02/2015 07:49 PM, Greg Kroah-Hartman wrote:
> On Mon, Nov 02, 2015 at 07:02:04PM -0500, Doug Ledford wrote:
>>> so overall it still benifits being in the
>>> staging tree, so a few minor breakages every once in a while should b=
e
>>> easy for you to fix up, _if_ they happen.
>>>
>>> Again, I don't know of any recent api change that has caused any
>>> problems in a long time, but the VFS developers really hate having to=

>>> touch lustre code, and I don't blame them, so sometimes that codebase=

>>> breaks.  That will not affect your drivers at all, so I wouldn't worr=
y
>>> about this.
>>
>> Yes.  I get that.  And I understand that.  But because of Lustre, you
>> have made a global policy that effects all staging drivers without
>> legitimate cause, proudly broadcast that policy at a conference, even
>> answered a question from Christoph confirming that policy, and now in
>> this email thread where I object to that policy you say "It doesn't
>> really happen anyway, don't worry about it.'
>=20
> No, it's not "because" of lustre, it's been that way since day one when=

> we started the staging tree.  Christoph was just annoyed that someone
> was trying to tell him otherwise.  And he is right.

No, he's not.  As I've already pointed out, the policy is only
appropriate for neglected drivers.  I don't care if the policy was
applied to everything in staging, whether neglected or not, from day
one.  It was evidently bad from the beginning.  I'm calling it out.
I've even provided justification for calling it out.

So far, your only response has been "That's the way it's always been,
and that's the way it is", which does nothing to justify the status quo
but stands only to argue that it is the status quo and therefore should
remain such.  Inertia is a poor argument.

>> But the person who quoted
>> you (Christoph) is the author of one of the API changes that *did* bre=
ak
>> the RDMA drivers in the staging tree and he fixed them up when I asked=

>> him to.  Christoph then later quoted you and his interaction with you =
at
>> conference to indicate he didn't have to.
>=20
> He didn't have to.  He was being nice.

Again, I disagree.

>  That's your job to fix them up
> if you want the code in staging.

As I pointed out in an earlier email, allowing deprecated drivers to
simply break defeats the whole purpose of deprecating them in the first
place.  Moving the burden of keeping them running from the person doing
a core API change to the maintainer just because they are now deprecated
and in staging makes no sense.  That just serves to overload the
maintainer.  And it's not like I want to work on those drivers any more
than anyone else.  I'm simply trying to follow a process that allows for
an orderly removal with some sort of ability for end users to have a
chance to push back if they need to.  I'm having a hard time
understanding why this deprecation procedure should be so maintainer
responsibility heavy.  Regardless though, I'm almost certain not to
follow this specific deprecation process again in the future because of
how you are suggesting it should be handled.

>> And what I'm telling him, and
>> you since you are the person he's quoting to justify not fixing up
>> things, is that I don't care what you say, when it comes to those
>> drivers that I moved into staging, if he wants me to take his core
>> patches, then he needs to make sure they don't break those drivers I
>> moved into staging.
>=20
> Nope, not true.  If you don't like this, I'll gladly just delete the
> drivers from staging, sorry.

Maybe you should be more clear about your intention here.  Under
precisely which actions of mine will you resort to retaliatory deletion
of code, and which code?

>  You don't get a "free ride" in staging at
> all.

I'm not sure what you are calling a "free ride".  Certainly, if what I
asked Christoph for is a "free ride", then drivers in the core kernel
get "free rides" all the time.  As such, I didn't ask for anything
unusual or out of the ordinary.  Because of the reasons I stated in my
previous email, I asked for the drivers I moved to staging to be treated
the same as any other driver would be.  Equal treatment is hardly a
"free ride".

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--osBsNovpTCq57eN60iner7iT5SsWQUEXX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWOCZ+AAoJELgmozMOVy/d+6EP/jGES/SfZ9himBr9UXxx+tGg
fzBJ+neNwfkp7Lr2/sFSwMX+xX11GLkxNNAMqKsy5W64IJxeSl8MGBiqQkuq+aQN
S33n/ruIb5hHSji2towkohAZ/1TZ+micgG2BpbWgiGtDMc3c7CeWzD33mhHx45Aw
8QAyuVqk+5MPVZqUOxBG+3L/4z6TqBVB9APF+2M8/ao2lAj0jvLk/8vYRu13Q+mG
i0IP3YXVZe1xNYeneA96ckGke0mK0c7QQu1dproy5W55B6PDbpOduOGrJNnnwU25
iW/LSgLifrccGmwKUlFmYMd7A05UqreOP+SZmUt/IWd53p0GMp2VnoCL0LB23RSv
/8l/sDFPY/UGkOHC/jbXKBFQsRDINPJNUZhiI/GUgBWX/tSDnBVFy22O7VoI7tdk
so/pDx/4xFz0eXHlHBJdXARf/BS9v8warJjBjZZQkd7yuAcgIfGvIZ0n1VWZOIO4
PvRyAj8sil0uPQdUJpPRXpLGT38GDdNcz9evt42Nv+Kiue8zN9lXypVEnUR39YRT
dW2j/gEiVhDRx2nyqzpDJYK26sZ7I8gnuMEY0DtyT5UW/b25r5WtixjGWJbXK+uP
8t5Xn6M3wQ/uvU0kFAkVcbwzR2yfyuVwq72GmUlDYDv3++uxFkxBBYVmAcCisvPQ
z2LV4Xq6uKLLtSuqkCCl
=DHhz
-----END PGP SIGNATURE-----

--osBsNovpTCq57eN60iner7iT5SsWQUEXX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
