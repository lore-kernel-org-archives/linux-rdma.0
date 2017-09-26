From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared pull requests (was Re: Workflow for i40iw patch
 submissions)
Date: Tue, 26 Sep 2017 12:03:01 -0400
Message-ID: <6fa41141-cae5-da51-94ef-afe5bdec22bd@redhat.com>
References: <9DD61F30A802C4429A01CA4200E302A75B9FB085@fmsmsx116.amr.corp.intel.com>
 <1506179005.120853.67.camel@redhat.com>
 <20170925035910.GL25094@mtr-leonro.local>
 <5abacb7d-3e86-4e12-ce95-a8fe472a6a09@redhat.com>
 <20170925155749.GO25094@mtr-leonro.local>
 <7c01cef3-0471-8339-3498-1d9ec4f8a9d3@redhat.com>
 <20170926051349.GA1230@mtr-leonro.local>
 <20170926065600.GA6816@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2vGoDd0FOOuJgIsoF0CHgmp2vE3w2xSik"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926065600.GA6816-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2vGoDd0FOOuJgIsoF0CHgmp2vE3w2xSik
Content-Type: multipart/mixed; boundary="dFPponDVhIXM6KCqL5OCBI9sGPu6atKUX";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <6fa41141-cae5-da51-94ef-afe5bdec22bd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared pull requests (was Re: Workflow for i40iw patch
 submissions)
References: <9DD61F30A802C4429A01CA4200E302A75B9FB085-5FK+k9557ZBZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
 <1506179005.120853.67.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20170925035910.GL25094-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <5abacb7d-3e86-4e12-ce95-a8fe472a6a09-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20170925155749.GO25094-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <7c01cef3-0471-8339-3498-1d9ec4f8a9d3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20170926051349.GA1230-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <20170926065600.GA6816-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
In-Reply-To: <20170926065600.GA6816-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>

--dFPponDVhIXM6KCqL5OCBI9sGPu6atKUX
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/26/2017 2:56 AM, Leon Romanovsky wrote:
> On Tue, Sep 26, 2017 at 08:13:49AM +0300, Leon Romanovsky wrote:
>> On Mon, Sep 25, 2017 at 10:31:47PM -0400, Doug Ledford wrote:
>>> On 9/25/2017 11:57 AM, Leon Romanovsky wrote:
>>>> On Mon, Sep 25, 2017 at 10:53:01AM -0400, Doug Ledford wrote:
>>>>> On 9/24/2017 11:59 PM, Leon Romanovsky wrote:
>>>>>> On Sat, Sep 23, 2017 at 11:03:25AM -0400, Doug Ledford wrote:
>>>>>>
>>>>>> <...>
>>>>>>
>>>>>>>
>>>>>>> I want any shared pull requests to be based on nothing newer than=
 an
>>>>>>> rc2 kernel.  I branch my for-next branch at rc2, so if your pull
>>>>>>> request is on something later it will pollute my main for-next br=
anch
>>>>>>> to merge it.  I plan to merge my own -rc pull requests after rc2 =
into
>>>>>>> my for-next branch, so you won't be missing code that goes into l=
ater
>>>>>>> rcs if you base your work on my for-next branch, so that's a seco=
nd
>>>>>>> alternative starting point for your shared pull requests should y=
ou
>>>>>>> need it.
>>>>>>
>>>>>> From our experience, it is not feasible to demand shared pull
>>>>>> requests on "newer than an rc2 kernel".
>>>>>
>>>>> I said "nothing newer than an rc2 kernel".  Did you mean to leave o=
ut
>>>>> the nothing?
>>>>
>>>> Most probably I translated it incorrectly. I wanted to say that all
>>>> shared pull requests will be -rc2, -rc3, e.t.c. and probably will ne=
ver
>>>> be -rc1. Did you mean the same?
>>>>
>>>>>
>>>>>> The magic of shared pull request
>>>>>> is in the fact that it is based on the same origin for both trees.=

>>>>>
>>>>> Correct.  So, for instance, I'm opening up my for-next area today a=
nd it
>>>>> will be based on a clean v4.14-rc2.  What I'm then asking for is th=
at
>>>>> subsequent driver shared pull requests be based on a v4.14-rc2 tree=
=2E
>>>>> Your last shared pull request was mostly OK, but it was based on a
>>>>> v4.13-rc4 kernel and so it would have simultaneously brought in you=
r
>>>>> patches and also all the changes between 4.13-rc2 and 4.13-rc4.
>>>>
>>>> Why is it "undesired behavior"? Anyhow git request-pull to Linus wil=
l
>>>> filter all patches which already exist in Linus's tree and you will =
get
>>>> merge of -rc fixes for free in your for-next.
>>>
>>> You obviously have not been paying attention when Linus yells at me.
>>
>> I do, but probably we are understanding Linus's responses differently.=

>>
>> You probably mean the conversation after that pull request.
>>  * First round of RC fixes for 4.13
>>    https://marc.info/?l=3Dlinux-rdma&m=3D150039306716272&w=3D2

More than just that conversation.  There have been offline conversations
too.

>> He started to complain about empty merge commit with v4.13-rc1, and co=
ntinued with explanations
>> about difference between back and forward merges. From my point of vie=
w, my intention to base
>> shared pull request on latest -rcX is exactly forward (good) merge, be=
cause it ensures that
>> all our future submissions for net/net-next/rdma-rc/rdma-next are comp=
letely in sync and
>> ready to go.

This is why, when I submit a pull request for -rc, I also merge it into
for-next.  It keeps this up to date as you say, without needing to pull
in all of the -rc, so it gives Linus an easier history to look at.  It
does not, however, sync up the net side of things.

> And if we are talking about back-forward merges, the following merge is=

> a back one and it was mentioned by Linus as a bad type of merge which
> should be avoided:
>  * Merge tag 'v4.14-rc2' into k.o/for-next
>    https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git/co=
mmit/?h=3Dk.o/for-next&id=3D0d9c2ff1c9f7f8b339fc42ac9763b28c71f1c115
>=20
> Because your previous for-next was fully merged

It was...

> and new one was opened after
> -rc2

It was...

> and your initial pull request with fixes was accepted during in -rc1 to=
o,

It was...

> you was supposed simply reset your for-next to v4.14-rc2 tag
> git reset --hard v4.14-rc2) as a starting point of for-next.

I didn't think this would work on k.o (and it's why I did the merge),
but it does work.  The reason I didn't think it would work is that even
though v4.14-rc2 and my branch merged with v4.14-rc2 have the same final
image, their path to get there (as shown by git log --oneline
--topo-order) would be different.  As such, I expected the k.o git
server to kick it as a non-fast-forward update when I attempted to push
after having used git reset --hard v4.14-rc2.  But, it didn't, it took
it, and a git pull of the tree before the reset and after the reset was
totally non-eventful.  So, I won't do that next time.

> Thanks
>=20
>>
>>> This is something he specifically does *not* want, and if you send me=
 a
>>> shared pull request that is based on, say, -rc4, then I can't merge i=
t
>>> into my for-next branch and instead of I have to carry a separate bra=
nch
>>> and send a separate pull request just for that branch.
>>
>> I don't think so, but we can probably catch Linus at KS next month and=

>> ask him directly.
>>
>>>
>>> The reason is that Linus wants to be able to pull up gitk on my pull
>>> request and see the changes I am submitting for easy review.  If I me=
rge
>>> a shared pull request that also includes an update to the -rc level o=
f
>>> my tree, then all those -rc patches get mixed into the gitk ordering =
and
>>> it makes it hard for Linus to find just the patches he wants.  So, th=
is
>>> is a Linus issue, not so much my issue.  If he didn't care, I wouldn'=
t
>>> either, but this is the way it is.
>>>
>>
>> I don't know how gitk presents git history, but the following command
>> "git log --graph --no-merges -- drivers/infiniband include/rdma/ inclu=
de/uapi/rdma" works like
>> a charm and presents only RDMA related commits.
>>
>> Other replies from Linus about late submission, compiler warnings, tre=
e-wide changes,
>> request to separate pull requests, fix with strange name ("Add ...") a=
re completely unrelated.
>>
>> I read upto 19 Mar 2016, in that pull request Linus explained to us ho=
w we should create shared pull request.
>> Everything before is not relevant for shared pull requests.
>>
>> Thanks
>>
>>>
>>> --
>>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>     GPG Key ID: B826A3330E572FDD
>>>     Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57=
 2FDD
>>>
>>
>>
>>
>=20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--dFPponDVhIXM6KCqL5OCBI9sGPu6atKUX--

--2vGoDd0FOOuJgIsoF0CHgmp2vE3w2xSik
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZyno1AAoJELgmozMOVy/dT+UP+weErDPTePMa7DVhCyNqVGjI
AN5mAia6nyeuYwdixxmVkEHZk8JUeSuzgJtbT/16XGi1zj75SLEGywpSFhopPkGQ
KivynXj6JZF1SVa8+//1WH8D8mIQumz41fUL7iUyCZVq3up4t6+J7GsBHyH2HEzv
aAxJSGI3OGo7FsvKs5PYbimzEi8Lx3thboysxrT1b+UneO2wq5f1P+PJTZE3xcKb
mErLoiqkto4jctN1+9MfyzjmLPNpghINFnqQeyCji4stb7ImVJ2PXkD4QV3gZaUC
Bd9WvYqyKnq5bNKYjG/egOvWGN5tIRkBv0IP5FmjFqGuYeO6sydGELIxEozhxLtp
xwOt4FY78h7ylvNyC4O45xHzbVAE4WDoMN+yXRIEsq/9ykLx7p+O/UIJ144rDTzq
CRnYR19lllU76jdDjJTwuuHMy1oBVaJSaTQJBHL1SIe30Tw58OeWFyCU8/ypyrpI
pkxMq1iKqJySGCU9FkDgmzWfx3oVIzSFqRlGjttLrZEw86v9f2ugNkprnsqHc402
8EUvaetZlbo1SS/LUX+l1i/X3MOfvRZgpkAPxMZWDmkUAKRDT8cfMnrzri2a4DYx
Ytj6rp+0Q+RT4+DSP1NmMk8R58oUWELKAi9YJDbUqzHDeGsvQwtSi+g5unscuQSx
t1Ssb0CbCMi+YsEeiFfT
=8Kk5
-----END PGP SIGNATURE-----

--2vGoDd0FOOuJgIsoF0CHgmp2vE3w2xSik--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
