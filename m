From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sat, 23 Jan 2016 00:01:04 -0500
Message-ID: <56A30910.9010002@redhat.com>
References: <56A2727B.8040809@redhat.com>
 <CA+55aFziXhmMRk3HqvrUtVv+SaUM0zu3=LKbxo0w9HZPVmDuyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="87Pvo71BQTWDLol76EGDOcDQJFM3jXfsq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFziXhmMRk3HqvrUtVv+SaUM0zu3=LKbxo0w9HZPVmDuyw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--87Pvo71BQTWDLol76EGDOcDQJFM3jXfsq
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01/22/2016 08:12 PM, Linus Torvalds wrote:
> On Fri, Jan 22, 2016 at 10:18 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>>
>> This is a rather large update, and it's not entirely complete.  I have=

>> some changes to merge for the staging/rdma tree too, but I wanted to g=
et
>> this set in first for dependency reasons, then I'll make a new branch
>> against Greg's staging tree, then send the changes relative to that.
>> Expect that pull request early next week.  Thanks.
>=20
> No Doug.
>=20
> The merge window closes this Sunday.

I obviously have my understanding of the development cycle here wrong.
I had thought that the merge window was 4 weeks with a following 8 weeks
of RC candidates resulting in roughly quarterly pace.  But you tagged
v4.4 on 1/10/16, so this Sunday is only 2 weeks.  That certainly changes
things.  I did not believe that the merge window was so short when I
sent this request.

> It's already damn late to send me anything at all,

See above about the 2 vs. 4 week misconception.

But also, really?  Even ignoring that misconception,  it's the merge
window.  And it has a deadline.  And if you give me a deadline, then
even though I don't try to cut it too close, I, generally speaking,
*will* use my available time if needed.  But from your description here,
there is an additional deadline in the merge window that is an
unwritten, unspoken, visceral thing that you feel.

Ok, so be it.  A little guidance on that would be appreciated.  Is the
deadline really 1 week after the merge window opens?  10 days?  4 days?
 I ask because this stuff is actually important in terms of planning.  I
had PTO and was off in Hawaii when the merge window opened.  We all have
personal lives, and schedules don't always line up with the merge
window.  Knowing how small the merge window *really* is is important for
me to be able to plan and prioritize actions when I return from
something like this.  So, for my future planning purpses, some
elucidation here would be appreciated.

> it is *much* too
> late to say "this is just part of it".

There were some issues of coordination between work being committed by
GKH and myself.  I needed to make the last things relative to what he
submitted already.  My branch with the code on it that I sent the pull
request for was based on 4.4-rc6 and therefore did no have GKH's work in
it.  I didn't like the idea of just blindly merging his branch into mine
so that his commits were there and I could make my follow on commits, so
it seemed I needed a new branch based upon either GKH's branch that he
submitted to you, or on your current master, to plop the last commits
into.  Given that I thought it was still a couple weeks to go to the
close of the window, Monday seemed reasonable.  I'll probably still
submit the deletes to you sometime tomorrow.

> This can all wait for 4.6, and maybe you'll have the pull requests
> lined up at the *beginning* of the merge window rather than trying to
> push them in whan I'm already trying to calm things down for the end
> of it.

Sure.  I can just merge it up to a 4.5-rc sometime then resubmit next
window.  However, I'm going to have to pull at least a few patches out
and send them separate as they are needed fixes for the code in tree
already.  But those are all -rc appropriate patches anyway so it doesn't
matter if they land by Sunday.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--87Pvo71BQTWDLol76EGDOcDQJFM3jXfsq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWowkQAAoJELgmozMOVy/dLwoQAIOoVKEtj7r5nB2iMLyfvr5y
a7eg7cFB314OuJaq1Wz4Krq4vDgFR2lyW5xa99mf9kStuKW3K+uxzg3TLbAU5XRu
9MiIKRE9x2lr9dbnl++29onvlpkZdDhs1BL1pSnHj+zyXY4QU/hAF35Y1Uu4jvPv
DCVlvETTWTRcTxloOmCLqHwc702+bi+KtSX+FLqSTVISsfIcc0CjCQfguVnag8lZ
gO9L1Nl/8MK2B8VHwXulfQbls/+Zt0M8N6GrOtltBfN1QqbTLFyFy0bjrphle76E
XK+GuTXL8/VJTt6sanwjyBIUENPylxBGBU5m9nH4eAy1kFrnIc3htNNJo1HI/TN6
ybDXp0cRIanPXvzVGztJqfLi4uuH3OB6afOZF7xznEZ56BN0XuPzwRWP5aAfnqwB
4GU9jKjGWli8uWxmifLKN8wA9I96UVhwFQCkTSvpYF6AIEm2pDvPB+67Oro4tml1
LQHAYnfcY2zYS9sdUQ7ZVXNCvKRBBQE8OcmYNFfvffn+Ywf1k1sV5vO6J2zYUhJ/
R62nkSBxD2cEG7noqp3IkNZcQ7tcLljGy+87GWScmr6BynkovbiS0VlPe/eTCkb7
zbh1P0dpsv07xiSCuctcGvjDmGKC74Dhm7vxw//N0c8zXvEDhYo7kcGgvkNGgEQV
kXc9+aMv0KaxpHDCyLnS
=GQop
-----END PGP SIGNATURE-----

--87Pvo71BQTWDLol76EGDOcDQJFM3jXfsq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
