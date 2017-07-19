From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Wed, 19 Jul 2017 18:05:08 -0400
Message-ID: <6b6d3dba-8eac-ef75-ef23-6e4e469670b6@redhat.com>
References: <1500393061.23761.1.camel@redhat.com>
 <CA+55aFyMw63bV+KOOiP9MbXF=BU8mHYEzBYsNH=xrVWxO=rzKg@mail.gmail.com>
 <1500404869.23761.9.camel@redhat.com>
 <CA+55aFxYrrWO0NFJLzMiSQxPKMcoLUD=xA0e-g01riFfX5-Vug@mail.gmail.com>
 <CAANLjFr9DxfoR_H5rp1ag_fC5AqxDJ5ZEj52wF-W2eGjof6iqg@mail.gmail.com>
 <1500486883.23761.14.camel@redhat.com> <1500496830.2494.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="knxTh7Hekl5FulBuHNmUJk2NSNJcC9DMm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500496830.2494.5.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org" <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--knxTh7Hekl5FulBuHNmUJk2NSNJcC9DMm
Content-Type: multipart/mixed; boundary="pJqIeSBMUxp8BVrsMM1af3e3XGJF233Hk";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>,
 "robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org" <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <6b6d3dba-8eac-ef75-ef23-6e4e469670b6-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
References: <1500393061.23761.1.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <CA+55aFyMw63bV+KOOiP9MbXF=BU8mHYEzBYsNH=xrVWxO=rzKg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <1500404869.23761.9.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <CA+55aFxYrrWO0NFJLzMiSQxPKMcoLUD=xA0e-g01riFfX5-Vug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <CAANLjFr9DxfoR_H5rp1ag_fC5AqxDJ5ZEj52wF-W2eGjof6iqg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <1500486883.23761.14.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> <1500496830.2494.5.camel-Sjgp3cTcYWE@public.gmane.org>
In-Reply-To: <1500496830.2494.5.camel-Sjgp3cTcYWE@public.gmane.org>

--pJqIeSBMUxp8BVrsMM1af3e3XGJF233Hk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/19/2017 4:40 PM, Bart Van Assche wrote:
> On Wed, 2017-07-19 at 13:54 -0400, Doug Ledford wrote:
>> On Tue, 2017-07-18 at 21:42 -0600, Robert LeBlanc wrote:
>>> On Tue, Jul 18, 2017 at 1:26 PM, Linus Torvalds
>>> <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>>>> On Tue, Jul 18, 2017 at 12:07 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
>>>>> wrote:
>>>>>
>>>>>
>>>
>>> I'm trying to understand why merges are being done instead of
>>> rebases.
>>> Since we don't want to include other people's work, it seems that it
>>> is cleaner to do a rebase. This is more for my education with using
>>> Git with such a large project rather than me suggesting something
>>> useful. (I dropped Linus from this part of the thread so as not to
>>> bother him with an off-topic conversation).
>>
>> Rebases change the history of a patch.  If I commit a patch on July
>> 7th, and then rebase on July 20th, the patch gets rewritten with the
>> new date.  In addition, they get new commit hashes.  So if someone
>> pulls my tree on the 9th, sees the commit hash for their patch, and
>> then references it in an email or a bug report, then I rebase on the
>> 20th, the old commit hash is gone and will be replaced with a new one.=
=20
>> Finally, if someone pulls my tree on the 8th, and then again on the
>> 22nd, and they don't know I've rebased it, the pull will attempt to pu=
t
>> all of the new hashes on top of the old hashes for the same commits.=20
>> It creates a ton of merge work that is error prone.  Sometimes chunks
>> get added twice, stuff like that.
>>
>> There are a few things you can do to get around this, and I sometimes
>> use those tricks.  I've declared on-list that my github repo is subjec=
t
>> to being rebased at any time, so people know this.  I also have my
>> github repo as the source for my 0day testing.  So, I can push to
>> github, wait for 0day test results, and if there was a problem, I can
>> fix it using a rebase of whatever patch was broken, repush to github,
>> and repeat until 0day testing passes, and only then do I push to my
>> kernel.org repo, which is taken to be involate and rebases are
>> forbidden.  But even there, if I *really* have to, I can rebase by
>> deleting the branch I originally created and creating a new branch wit=
h
>> the rebase on it under a different name.  That prevents someone from
>> accidentally pulling the rebase on top of a previous pull.  But I
>> *really* try to avoid that.
>=20
> Hello Doug,
>=20
> Rebases do not only change the commit ID of a patch but can also change=
 the
> patch itself. If e.g. a patch (a) that was posted on the linux-rdma mai=
ling
> list contains two changes and a patch (b) contains only one of two chan=
ges,
> if the rdma tree gets rebased on top of a tree that has patch (b) then =
the
> rebase will modify patch (a) such that only the changes that were not i=
n
> patch (b) remain. git will neither complain about this nor report it.

This is no different than if you run git am on patch (b) and then patch
(a) on the same branch, except the change will be lost in the "conflicts
existed when applying the patch, please apply and resolve then commit
the result".  In this case patch (a) will loose the exact same data that
git dropped out during a rebase.

> Since
> a rebase can modify a patch it also invalidates any testing and reviews=
 for
> that patch.

The same can be said of the situation I listed above.  It's up to my
discretion to determine if the change is significant enough to warrant
going back and getting new reviews.  If the issue is that there was a
typo in a patch that caused a build error, I'm not going to invalidate
reviews for that.

> This why Linus hates rebases and why nowadays Linus refuses to
> accept any pull requests of trees that have been rebased. I hope I
> misunderstood you but if you are routinely rebasing branches with patch=
es
> that come from the linux-rdma mailing list please stop doing this.

Routinely?  No.  What I really use it for is when I'm taking a stack of
patches into either their own branch or directly onto my branch, if I
run into problems in the build test phase, then I'll rebase to fix the
build issues.  But that's limited to the stack I just took, so it all
happens as part of the "review, integrate, build, test" cycle for that
day's work.  By the time I leave for the day and push it to k.o (or at
worst come in the next morning and check 0day status and then either
fixup or push to k.o), it won't be rebased any more.  And if I split my
day's work up into different stacks, then once one stack is pushed to
k.o, that stack won't be rebased even if later stacks that same day need
rebasing to build/work properly.

> A model that some other kernel maintainers (e.g. Jens Axboe) follow is =
as
> follows:
> * Maintain one branch per pull request that will be sent to Linus, e.g.=

>   for-4.13/block. Never rebase this branch, never rewrite its history a=
nd
>   only merge Linus' branch into this branch if absolutely necessary.
> * Every time a patch has to be applied, use "git am" to apply it to the=

>   appropriate branch. Complain on the mailing list if "git am" complain=
s.
>   Add the maintainer Signed-off-by and edit the patch if this is consid=
ered
>   necessary.
> * Maintain a for-next branch that is the result of merging all branches=
 that
>   will be sent to Linus. Resolve any merge conflicts if necessary. Ensu=
re
>   that this branch is included in Steven Rostedt's linux-next tree and =
that
>   it gets tested by the zero-day testing infrastructure.

This is fairly similar to what I do.  I really only use rebases as part
of my internal fixups for build issues in a given day's/stack's
integration, which, BTW, is in line with what Linus says in the email
you linked to.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--pJqIeSBMUxp8BVrsMM1af3e3XGJF233Hk--

--knxTh7Hekl5FulBuHNmUJk2NSNJcC9DMm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZb9eUAAoJELgmozMOVy/dDIwP/igF1o8ciII+isjQpTIskcvu
lAbudDfPPSX4rry5q5Jm4m791LHtz5Nzdh2Q6E6kbcUTt8GCYeFR8PrZ+mqUGW2E
89fMFnp8uAAV2rVdrPXE/yQeX1A3zOVtGW6TFDkbO62Q6fOjAlAB5G2Q+3ooEwah
7zy6xb4pD16/MANOM41sKk1pCeLyQSKmA21x2Xy434i/hbnJcfYQ15eBwS3jnTe7
1MwizRQez0iq35T6SRfhxFNnCt55SvOOvh0Tmt3pHlLVvsxWATGQ/65CYN30wmDt
UhAlQYvBCG6dVpfN1oEx0ckBHHCpXfF+wlDgmnJM2ivruYSRHKikWyK7lMXWNE8P
esfDRCWMTd94ts1LIJKOouUV0TluVulfy+yLO5QR/OL4TEh2tOM2Q+jPlElyjrhy
Mnd3FkFLfz0fD6DOAOSc+BWPjfQW+IzlkGBqhBziiz/xzpPmpYjbFuJM+6uub9in
QkCtZOos2neCVqxGfOblewW0ouHatw9dstwwW2SefeSIwu6aVX6LEyRtv/s+U04A
cWzapDgWXzL0NY9oyafSu4HY7Z8v9kdZnfIam+wxwkeX3VnPdl9wAVkwd+2a+Fhi
noS5NZOt3TlbWtITI+wdkRzsHtq1MUlujYD5Gp2vgPMzydygTi/0ZXMedpBBAZ2p
1dUFD3RLuuA5mJp+FWho
=UtTF
-----END PGP SIGNATURE-----

--knxTh7Hekl5FulBuHNmUJk2NSNJcC9DMm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
