From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 3/9] Revert "IB/mlx4: Return EAGAIN for any error
 in mlx4_ib_poll_one"
Date: Fri, 2 Sep 2016 14:03:13 -0400
Message-ID: <aa325795-a120-6dee-a102-6aaa903be617@redhat.com>
References: <1472371118-8260-1-git-send-email-leon@kernel.org>
 <1472371118-8260-4-git-send-email-leon@kernel.org>
 <20160828171758.GA11719@obsidianresearch.com> <20160828182613.GP594@leon.nu>
 <20160828182813.GB12783@obsidianresearch.com> <20160828183500.GQ594@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CNrib9dvOlTENIiBDHtS3APHnXt5HQklG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160828183500.GQ594-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CNrib9dvOlTENIiBDHtS3APHnXt5HQklG
Content-Type: multipart/mixed; boundary="CbDtUweaHtESXUpLpgt1sl3XXMVuqgGfl";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <aa325795-a120-6dee-a102-6aaa903be617-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 3/9] Revert "IB/mlx4: Return EAGAIN for any error
 in mlx4_ib_poll_one"
References: <1472371118-8260-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1472371118-8260-4-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <20160828171758.GA11719-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> <20160828182613.GP594-2ukJVAZIZ/Y@public.gmane.org>
 <20160828182813.GB12783-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> <20160828183500.GQ594-2ukJVAZIZ/Y@public.gmane.org>
In-Reply-To: <20160828183500.GQ594-2ukJVAZIZ/Y@public.gmane.org>

--CbDtUweaHtESXUpLpgt1sl3XXMVuqgGfl
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/28/2016 2:35 PM, Leon Romanovsky wrote:
> On Sun, Aug 28, 2016 at 12:28:13PM -0600, Jason Gunthorpe wrote:
>> On Sun, Aug 28, 2016 at 09:26:13PM +0300, Leon Romanovsky wrote:
>>> On Sun, Aug 28, 2016 at 11:17:58AM -0600, Jason Gunthorpe wrote:
>>>> On Sun, Aug 28, 2016 at 10:58:32AM +0300, Leon Romanovsky wrote:
>>>>> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>>
>>>>> By Mellanox HW design and SW implementation poll_cq never
>>>>> fails and returns errors, so all these prints are to catch ULP bugs=
=2E
>>>>
>>>> Eh? How can a ULP cause poll_cq to get errors?
>>>>
>>>> Are you sure these are not driver bugs?
>>>>
>>>> Why can't you just print and discard the broken CQ entry?
>>>>
>>>> What should use ULP do when it get EINVAL? You say poll again is
>>>> not correct, so you suggest a full QP tear down?
>>>
>>> See patches 4 and 6, they completely removed these EINVALs.
>>
>> So the commit message is still wrong.
>>
>> Why do we need this revert? Just squash it and mark it fixup the
>> original.
>=20
> We need this revert, because the original commit is wrong and as was pr=
esented
> by Sasha Levin in his talk about automatic creation of stable trees [1]=
, he needs
> this information to ensure that this commit won't be in stable tree by =
mistake.
>=20
> [1]
> https://lcccna2016.sched.org/event/7JW4/automating-the-creation-of-stab=
le-trees-sasha-levin-verizon-labs

I didn't see the presentation at this link, but I'm not sure I agree
with your statement here.  There should be no difference, effectively,
between a commit to revert a bad commit, and a commit to fix a bad
commit that uses a Fixes: tag referencing the original commit.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--CbDtUweaHtESXUpLpgt1sl3XXMVuqgGfl--

--CNrib9dvOlTENIiBDHtS3APHnXt5HQklG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXyb7hAAoJELgmozMOVy/d0WAP/00hM6zQkw7hBM0qyVqhWBCj
JKJQMBs4xbHobV7krJH5MN5zIxfgHpp06vBnhrNpyCVOIznlKsqJE0rBtBZVdHUu
6EZzybsv22dxp5iOUUNkjYdrRoxvqSoG6Ot1XVioZZBUJfpea1OgX13uIi2ARlLW
OpIza+sEwkepkbR/D5PtKSx76ZZEmQmuDymMw5bv2uUIxs3vSkARX4dY5gBX+EII
C0p/JZwNo49O86MtcSWfvApN/wZljcgkIK9YKa1Kxiw4Ajde5Qa9rpTYkrvZDc3R
7BGjaEF+QAfIrxEVukG6lBoLePfH2KoJX/AJKwXYmhA/1NNsSpOvwnZ5orJrBm4z
EM0Rhv1kHDOCehWkT5j+h5PJrYIVASvZ4QQ5pV44ojIwkbqVL5N1N6y3VJd/p42C
iIIsIvsV+1//lgArObZLZRyKWKYDdiREw+mzB+SDLDCmZEmNRDjNkmo/v4Fv5qhC
jRpHEhJvsjwry3+tDi19R9X8Tfp1lTEit6hqA5h0iJ21/CARWUQu5DUE6OHxPgna
GT6wBHJBiHh7zVId1/cO1TBrys0NWs9U36C+95cE7wxGwbySIo1gZPD5tWwjKTtc
pNrLSZzTSIVpW8QgiScnoiXBQPJUqBgML/nc2KyXQ+jA/gX+7vwPhYy0NmgS9ik+
By77GWGOpePTfbEGY30j
=VLMl
-----END PGP SIGNATURE-----

--CNrib9dvOlTENIiBDHtS3APHnXt5HQklG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
