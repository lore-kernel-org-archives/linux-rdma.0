From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Prepared RDMA Tree for 4.7
Date: Fri, 13 May 2016 12:31:55 -0400
Message-ID: <9e5233c8-6641-7f6b-3825-1b67eb70c05b@redhat.com>
References: <20160512174406.GB11827@leon.nu>
 <9dbc023f-e442-843a-ab68-eec38ca1d6b7@redhat.com>
 <20160513042217.GD11827@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nSotl1kNB706sKUEiL7xWBLWFG2Uo3GCL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160513042217.GD11827-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nSotl1kNB706sKUEiL7xWBLWFG2Uo3GCL
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/13/2016 12:22 AM, Leon Romanovsky wrote:
> On Thu, May 12, 2016 at 10:01:17PM -0400, Doug Ledford wrote:
>> On 05/12/2016 01:44 PM, Leon Romanovsky wrote:
>>> Hi Doug,
>>>
>>> I prepared the base tree [1] with patches sent to RDMA mailing and pa=
ssed review.
>>
>> You can't know that.  The reason I say that is because they have to pa=
ss
>> my review as well, and that's usually an implicit thing.  If I review
>> them and they have already passed list review and they pass my review,=

>> then I include them.  If they don't pass my review (which isn't often =
if
>> the other people on the list have already spoke up, but does happen),
>> then I ask for revisions.  If you take them without an explicit review=

>> from me, then you don't know if I'll ask for a revision or not.  It's
>> premature.
>=20
> Yes, I don't know for sure, but you can see that patches which I chose
> have no dispute over them and have no reasons do not to be accepted.

That's not true.  You chose some of your own patches that I'm not sure
I'm going to accept.  The ib_addr module build patch among them.

>> Most, there was a linux-next build failure that I'm sure is related to=
 a
>> change I hadn't had a chance to look into yet but looked fishy to me
>> (the move to put ib_addr into ib_core looks like it's broken, but I
>> hadn't delved into the code to verify it...the linux-next build failur=
e
>> from tonight makes me thing that it is).
>=20
> It is caused by **not merged and delayed** topic branches.

The reported failure from Stephen was with *your* tree.  If there are
any **not merged and delayed** topic branches then they are in your own
tree.  When you put together your own tree, if you can't do so in a
fashion that passes testing, don't act like that's someone else's fault,
that's *your* tree and *your* responsibility.

> Both topic/fix_core and
> topic/rdwa-rw-api touched drivers/infiniband/core/Makefile and created =
merge
> conflict.
>=20
> The merge commit is here [1] and the simple fix is
> diff --cc drivers/infiniband/core/Makefile
> index 2c6dc6b,26987d9..f0a5276
> --- a/drivers/infiniband/core/Makefile
> +++ b/drivers/infiniband/core/Makefile
> @@@ -8,9 -8,9 +8,9 @@@ obj-$(CONFIG_INFINIBAND_USER_MAD) +=3D     ib
>   obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=3D       ib_uverbs.o ib_ucm.o =
\
>                                           $(user_access-y)
>=20
> - ib_core-y :=3D			packer.o ud_header.o verbs.o cq.o sysfs.o \
> + ib_core-y :=3D			packer.o ud_header.overbs.o cq.o rw.o sysfs.o \
> 				device.o fmr_pool.o cache.o netlink.o \
> -                               roce_gid_mgmt.o addr.o
> -                               roce_gid_mgmt.o mr_pool.o
> ++				roce_gid_mgmt.o addr.o mr_pool.o
> ib_core-$(CONFIG_INFINIBAND_USER_MEM) +=3D umem.o
> ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) +=3D umem_odp.o umem_rbtr=
ee.o
>=20
> Based on your methodology such merge failures are unavoidable and I'm
> not feeling well with your conclusion that topic/fix_core broke the
> build.

The tree Stephen tested was *your* rdma-next, and it was the result of a
merge of *your* topic/rdma-rw-api and *your* topic/fix_core.  This has
*nothing* to do with my tree and is all about your own merge failure.
When I merge topics and they don't build properly, I fix up my own tree,
I don't blame someone else.

>>> I believe that it will save you a lot of work and time if you use it
>>> as a base for next merge window submission (4.7).
>>
>> Not really.  I still have to review the patches, and I still have to
>> update patchworks, and when I'm sorting through patchworks is when I g=
et
>> the patches to include.  The incremental time to grab the patches out =
of
>> patchworks and run git am -s on the bundle is negligible.  The real ti=
me
>> is in reading the patches, and this doesn't save me any of that time.
>=20
> I'm not working with patchworks, so I can't save here, but IMHO it stil=
l
> valuable and save time:
> 1. Separated by topics

Which I do myself anyway.

> 2. ROB tags

Which patchwork collects anyway.

> 3. cleanpatch + checkpatch before merging

Which I don't always do, but I expect patch submitters to do.

> 4. We (Intel and Mellanox) already run their test regressions on the up=
stream code
> and we will run it on **almost** (pending your acceptance) latest ->nex=
t branch.
> So the bugs will be caught before sending pull request to Linus.

You're making a big leap of faith that what you have pulled together
will represent even close to the next ->next pull request.  That isn't
justified.  See below...

>>> The topics which were added:
>>>  * topic/fix-core

Which includes one patch I haven't determined I will take yet.

>>>  * topic/hfi1

Which has less than half of the hfi1 commits my current for-next tag
has, I'm sure Intel will be appreciative of all those lost commits.

>>>  * topic/i40iw

Your branch has 25 commits and mine has 27.  Again, I'm sure Intel will
appreciate the lost commits.

>>>  * topic/ipoib

This topic branch doesn't exist, but ipoib-device-address does, however,
I haven't decided to take that patch just yet, so it's probably a good
thing that you didn't include it in rdma-next even though you say you
did.  But if I can't trust the list of topic branches to be correct,
that's another issue.

>>>  * topic/iw_cxgb4

Both of our branches have 26 commits, but I know mine has one that yours
doesn't, so now I need to search through yours to see which it has that
mine doesn't.

>>>  * topic/iwcm

This shouldn't have been a topic, it's only one commit, but I have it.
It was in one of my misc topics.

>>>  * topic/nes

This is only one commit, and I haven't pulled it yet.  But mine has
three other commits you are missing.

>>>  * topic/rdma-rw-api

This is similar to mine.

>>>  * topic/srp

And this is similar.

>> The help is appreciated though ;-)
>=20
> Thanks,
> Will you support my effort to continue publish ->next tree?

I'll give you the same advice Linus gave me in 1994 when I started to
publish my own 1.2.13+ linux kernel tree: I don't care what you publish.
 You are free to publish anything you want.  That's the beauty of open
source.

As for what I'll use, I'll simply point out these facts:

When I helped you get your kernel.org account, I told the kernel.org
people that it was so that both Dave Miller and I could pull the exact
same *commits* from your tree for patches that might have merge
conflicts between our trees if submitted separately.  This if for things
like changes to the mlx5 offsets file.  Even if Dave and I both take the
exact same patches, that still throws a merge issue when Linus merges
the two trees.  The only way for Linus to avoid seeing that at all is if
Dave and I pull the exact same commits from your tree.  This merge cycle
was pretty easy, there were only two commits that we would likely need
to share.  But, instead of putting the tree up with those two commits in
a topic branch that each of us could merge, you sent the patches to the
list, and we both had to commit our own commits for these patches.  I'm
going to have to mention that when I send my pull request to Linus
(although, the mlx5 IB changes this cycle are simply non-existent, so I
could just drop them instead).  So this branch that I expected from you,
I didn't get.

I didn't help you set up your account because I had any intention of
pulling other branches from you.  You are free to publish whatever you
want, but I still must do my own work.  I'm accountable for things like
missed patches and crappy merges.  I prefer to be accountable for things
I actually did, not things other people did.

I would suggest you keep doing what you are doing.  Pulling the branches
that you guys care about together and running them through your internal
test/regression stuff is valuable, no doubt.  It might even save me time
when I get around to taking a patch series as you might have caught some
build/test issue and a new version of the series can be sent to the
mailing list before I include the final series in my tree.  That all has
value.

But ultimately, I will pick up the patches myself and I will do as I
said when I first started doing this job and track them in patchworks.
And what you think rdma-next will be, is not necessarily what it will in
actuality be.  And I will expect that you will actually publish the
topic branches in the future that were the reason we set up your k.o git
repo in the first place.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--nSotl1kNB706sKUEiL7xWBLWFG2Uo3GCL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNgF7AAoJELgmozMOVy/dAawP/2s4NTOe+dHP9QuLRSKJEnkm
QVJzCSibntFt2t/PnytAdcHsrVSzvteXDTvFwxfE6HYcAaoqmhM4QQYewoMcbV2I
RHtzALjw/OjVAjpEyB9S4Ihe4luRADQMo5+vrcc0Z3XGKi5HGiXUokmJeS2tFsQN
0f8VpJLuX5+T/GMZmsSZxEO8I9+SZaP4JOOftnqLJK22pcZYORSDpCyPGZoFsh+D
DiYNwa2L9eIUclweYGw9yLmmVK2egZBLkxzii15c8xWvKqWOR1BabJaeReR8Gq0o
UZ76JW4Vk2XENzg9uoIkNgtup+etMP/bGee6WjoZjkwdv0u2dBOAwLZYBS8QzhVh
p7PDvy4JWVxAqz8IC1iW3zCfARFf1cgNggycMPxl+Nad3UdR+M6e790KYVO9iqrT
8wCKMPDyZqPrwFgfhyaJ4plLKP+Y9rfrAcH4OJ51ngIdOBv5B08asMsxEnjOGaUK
mohW1fyTrtcN8BZAKS4B7ngLkXxRxHLEB0X7WHqh/x07bIl6XHzfy7wE6922UTLK
C5nDwdaGxf+PeyQPr/ukhsQY8GpUomlDdKPhGyMy9Z09xRnluX8Z1SMjOrh2HITP
i2iZv05pWE6HreCygQQDNnzRMdyfVW0P81fA928tcfAvPCu0eQ2+8iSVKaYhR+pY
d+vbbgxr9Q3Wh2N+MwUV
=7vto
-----END PGP SIGNATURE-----

--nSotl1kNB706sKUEiL7xWBLWFG2Uo3GCL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
