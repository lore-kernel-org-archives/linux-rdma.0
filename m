From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RESEND] qib:Fix concurrent access in the function,
 qib_init_iba6120_funcs
Date: Thu, 10 Mar 2016 21:52:45 -0500
Message-ID: <56E232FD.8000405@redhat.com>
References: <1457323126-19686-1-git-send-email-xerofoify@gmail.com>
 <32E1700B9017364D9B60AED9960492BC25A7C169@fmsmsx120.amr.corp.intel.com>
 <20160307204948.GI13396@leon.nu> <56DF3046.20406@redhat.com>
 <56DF5CB0.4040004@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0AfkAVbWb76kLxeTwmxdbE1E1cUQhv4lk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56DF5CB0.4040004-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: nick <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0AfkAVbWb76kLxeTwmxdbE1E1cUQhv4lk
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 03/08/2016 06:13 PM, nick wrote:
>=20
>=20
> On 2016-03-08 03:04 PM, Doug Ledford wrote:
>> [ Dropping linux-kernel, they already know what I'm going to write her=
e,
>> this is mainly for the linux-rdma folks ]
>>
>> On 03/07/2016 03:49 PM, Leon Romanovsky wrote:
>>> On Mon, Mar 07, 2016 at 04:34:04PM +0000, Marciniszyn, Mike wrote:
>>>>> This fixes concurrent access in the function, qib_init_iba6120_func=
s by locking
>>>>> around the calls to when setting up f_sendctrl and f_set_armlauch f=
unction
>>>>> pointers to the functions, sendctrl_6120_mod qib_set_6120_armlaunch=
 due to
>>>>> these functions needing to have their caller to hold the spinlock t=
hat is part of
>>>>> the qib_ibport pointer they are using and due to the lock not being=
 held by
>>>>> higher up functions in the caller stack we need to hold it in qib_i=
nit_iba6210 to
>>>>> avoid conncurrent access when setting up these function pointers.
>>>>>
>>>>
>>>> I'm not sure I agree.
>>>>
>>>> static struct pci_driver qib_driver =3D {
>>>>         .name =3D QIB_DRV_NAME,
>>>>         .probe =3D qib_init_one,
>>>>         .remove =3D qib_remove_one,
>>>>         .id_table =3D qib_pci_tbl,
>>>>         .err_handler =3D &qib_pci_err_handler,
>>>> };
>>>>
>>>> The only caller is the probe function, which naturally protects sinc=
e the device cannot be used until the probe returns.
>>>>
>>>> Are you actually having an issue with this older version of a qib ca=
rd?
>>>
>>> IMHO no,
>>> The author is famous developer - Nick Krause [1].
>>>
>>> [1]
>>> http://news.softpedia.com/news/Malevolent-Developer-Trolls-Linux-Kern=
el-Development-with-Lots-of-Broken-Patches-453709.shtml
>>
>> Guys, please quit feeding the trolls.  I reviewed Nick's patches when =
I
>> first took this job.  After deciding that they had a > 50% wrongness
>> value (meaning, even though the patches are trivial, more than half of=

>> them are *still* wrong on average), he is now in my killfile.  If you
>> truly feel the need to review his stuff, be aware you will have to
>> submit it yourself for me to even consider it as his patches aren't ev=
en
>> allowed on the patchworks server (not my doing, it was this way when I=

>> took this job).
>>
>>
> Doug,Mike,Seaan
> First I get you probably want to use some choice screw words at me

No, not really.  I'm not mad at you.

> but let's first a  few breaths and work at some of the work I
> pulled up from you over the last few months(their is more but I am only=
 counting times that have been merged by maintainers).
> Firstly honest  to god I have learned from my mistakes and do actually =
have some work to show for it if you do git --author=3D"Nicholas Krause"
> you should a few *actual* bug fixes for me.

I'm certain there are, I never said there weren't.

> Further more I am confused as Doug signed off on this commit from,54b9a=
96f10d9acb7b1ffd40e2e1736443eb7656d
> but won't take anymore of my patches currently,

Yes, as I stated in my initial email, I reviewed your patches for a
while.  I even took a few that weren't bad.  But, as I pointed out, the
number of bad ones outweighed the number of good ones, and it was taking
far too much of my time to sort out which patches were good and which
were bad.

> was that a mistake as you seemed fine with applied it when I send it.

It was fine when I applied it and it still is.

> If you would more proof then what about these patches just being merged=
 in the last few days by other maintainers into their trees:

[ snip other patches ]

These are irrelevant.  The issue isn't whether or not you *can* write a
good patch, and so examples of accepted patches don't negate the
argument.  It's whether or not your overall set of submitted patches are
worth the time it takes to sort the good from the bad, so to counter
that issue you would have to show that, say, 50 of your last 60 patches
were accepted, or at most needed a few revisions before being accepted.
 Your reject rate should be very low as a rejected patch means you are
patching things you don't understand.

Whenever you submit a patch for a piece of code that you don't
understand, then the person in my shoes has to take the time to
understand the code ourselves.  Sometimes we know the answer
immediately.  Sometimes we have to go read a bunch of code ourselves to
sort it out.  That becomes very time consuming.

This patch is a perfect example of the problem.  You spotted something
that seemed obvious: there are no locks around access to card registers.
 So you wrote a patch to lock around it.  However, the fact that this
has existed so long without reports of a problem should have been your
first clue that maybe this patch isn't needed.  Before you submitted the
patch, you should have double checked that concurrent access is in fact
possible.  Had you gone looking into the call chain, you would have seen
that the function in question is only called as a driver .probe routine,
and in the drive core code you would have seen that there is locking and
race prevention to make sure we never probe the same device more than
once, and so we can never be accessing the registers on one card more
than once in this function because the card won't exist in a usable
state for the rest of the driver to touch prior to this function
exiting.  At that point you would have thrown the patch away without
ever submitting it.  That's what you are supposed to do.

And if you do things right, by the time you submit a patch, you will
have already researched the problem well enough that you can say things
like "this shouldn't have been a problem and there is code in the driver
core to prevent it, but because the list manipulation code uses mutex Y
and the list delete code uses mutex X, it fails" (and presumably your
patch would be to the driver core to fix the mutex screwup).

My point being, you should *know* if it is a problem, not *think that it
might be* a problem, and you should be able to tell me *exactly* why it
is a problem.  If you send me patches like that, then I will start
reviewing your patches.  But if you just write patches that you don't
really know if they are good or not and are expecting me to figure out
if they are good or not, then I'm sorry, but I just don't have the time
to do that.

> In addition, Doug I am not trying to disagree with you what I did also =
2 years ago but horrible and wrong I am just trying
> to prove I have changed. If you are still not convinced I can see if I =
have any other patches that are lying around that
> have a review by tag on them from another kernel developer, I probably =
have a few.
> Further more I am willing to listen to any other outstanding concerns y=
ou have if you would like to list them, I get your=20
> probably still very upset but hopefully you can at put me on a very str=
ict lease. Again I totally understand if you disagree
> and would need more time but hopefully this will make you see otherwise=
=2E
> Nick=20
> P.S. To be honest I am about as upset at myself about the same as for m=
y ban from lkml.

I'm not upset or mad or anything like that.  And I don't know if you've
changed or not.  All I can do is look at what I see.  And what I see is
that you are submitting patches that you don't *know* if they are good
or not, you are simply submitting things that look good and hoping that
a maintainer will tell you they actually *are* good and take them.  I
simply don't have the time to put that level of inspection into the
patches you write.  I need you to start doing that investigative
research on your own and including the results of your research on the
cover letter to the patches you submit.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--0AfkAVbWb76kLxeTwmxdbE1E1cUQhv4lk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW4jL9AAoJELgmozMOVy/dVLgP/2l36cKs9rmAG+6HzFH5NPh8
5oKvsKQ4KbkFJMGR7QumfeQcIoreO5t1FggyQ/dLQ5V54tgw7RvzUU+Ap6pG6Umd
iPHHSeEMcN6QKUjxEqEGXOJ5z1tpwrjCfmXL7hkm3OvlBzQ5cEklH4xytptzmRJ9
FBUL8Iot910tGLHvrrGJIr4/YplltncXsz5ktWNo8Jsu5LyLT8HoeTxic5zRuFjB
lNd7Ncp6lxfDQFK7oJitbMbElbeoIZ5MQDxoY1bjZJSI008sbl5OWNDE+XGqOKRg
uFNNF5HFRjrynHXOO1ueKsx+rSkYyvefy/wgnzFSrSz81nRLbwqRr+VOspOnFt+4
e0DDvXuEgShW3y5ssIpvaj8MCwJrSFoyB7s8I2/N1vlM1qsPMhwWjLcicic8qzyq
4j/VypZ6kJjkMeSnYbPspFcJJsk6ZjPasdXCBJM/wk+znHlZXnA9eHMxFh8W/6Nn
apTul+UaWOWpFOMBbHb26s6XpXKcsuXgjYr6KoRHH8N90egCnd/rPl+meRHsrgAf
g4eBQHpOyfbA+kiAI2D6sceUrGCGdHXkLlK1IkpWR0Q73EjT2m6y9n4Cc1/bd6XM
dmYuThin4Ym1FXKb0ssNSG1L9IgP7XVMhFFHYd82pYviDEEleIGTP1qxHAG4Jksf
rTIAKR3VYVRgKgcr4EoR
=FDp8
-----END PGP SIGNATURE-----

--0AfkAVbWb76kLxeTwmxdbE1E1cUQhv4lk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
