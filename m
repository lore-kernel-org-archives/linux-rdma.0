From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 00/15] staging/rdma/hfi1: Initial patches to add
 rdmavt support in HFI1
Date: Tue, 22 Dec 2015 23:21:56 -0500
Message-ID: <567A2164.50604@redhat.com>
References: <20151214172509.11576.19722.stgit@phlsvslse11.ph.intel.com>
 <20151221061214.GD3860@phlsvsds.ph.intel.com>
 <20151221220235.GA14142@kroah.com>
 <20151222001943.GM3860@phlsvsds.ph.intel.com>
 <20151222010148.GB2145@kroah.com>
 <20151222191508.GO3860@phlsvsds.ph.intel.com>
 <20151223022757.GA5562@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fKRFv05pQQF21rjIaNQHUbB9MWvhRqRv1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151223022757.GA5562-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fKRFv05pQQF21rjIaNQHUbB9MWvhRqRv1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/22/2015 09:27 PM, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org wrote:
> On Tue, Dec 22, 2015 at 02:15:08PM -0500, ira.weiny wrote:
>> On Mon, Dec 21, 2015 at 05:01:48PM -0800, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org w=
rote:
>>> On Mon, Dec 21, 2015 at 07:19:43PM -0500, ira.weiny wrote:
>>>> On Mon, Dec 21, 2015 at 02:02:35PM -0800, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org=
 wrote:
>>>>> On Mon, Dec 21, 2015 at 01:12:14AM -0500, ira.weiny wrote:
>>>>>> Greg, Doug,
>>>>>>
>>>>>> As mentioned below, these patches depend on the new rdmavt library=
 submitted to
>>>>>> Doug on linux-rdma.
>>>>>>
>>>>>> We continue to identify (and rework) patches by our other develope=
rs which can
>>>>>> be submitted without conflicts with this series.  Furthermore, We =
have, as much
>>>>>> as possible, placed fixes directly into rdmavt such that those cha=
nges can be
>>>>>> dropped from hfi1.  But at this point, we need to know if and wher=
e these are
>>>>>> going to land so that we can start reworking as appropriate.
>>>>>>
>>>>>> Therefore, I would like to discuss plans to get hfi1 under the sam=
e maintainer
>>>>>> to work through this transitional period.
>>>>>>
>>>>>> Basically, At what point should we stop submitting patches to Greg=
 and start
>>>>>> submitting to Doug?
>>>>>>
>>>>>> Should we consider the merge window itself as the swap over point =
and submit
>>>>>> changes to Doug at that point?  If so, should we continue to submi=
t what we can
>>>>>> to Greg until then (and continue rebase'ing the series below on th=
at work)?  Or
>>>>>> given Gregs backlog, should we stop submitting to Greg sometime pr=
ior to the
>>>>>> merge window?
>>>>>>
>>>>>> That brings up my final question, at the point of swap over I assu=
me anything
>>>>>> not accepted by Greg should be considered rejected and we need to =
resubmit to
>>>>>> Doug?
>>>>>
>>>>> If Doug accepts the library changes, let me know that public git co=
mmit
>>>>> and I can pull it into the staging-next branch and you can continue=
 to
>>>>> send me staging patches that way.
>>>>
>>>> Won't this cause a conflict during the merge window?
>>>
>>> No, git is good :)
>>>
>>>> How do we handle changes which affect both qib and hfi1?
>>>
>>> I don't know, now this gets messy...
>>>
>>
>> Agreed and this is what we are worried about.
>>
>> Can we do what Dan and Doug have proposed in the past and have Doug ta=
ke over
>> the staging/rdma sub-tree?
>>
>> http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2015=
-November/081922.html
>>
>> I think the upcoming merge window is a reasonable time for him to do t=
hat.
>=20
> Ok, but keeping on top of all of the generic staging patches that come
> in is a tough thing to do, that's up to Doug, if he is ready for it...

I'm not worried about that.  Patchworks makes the workflow reasonable.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--fKRFv05pQQF21rjIaNQHUbB9MWvhRqRv1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWeiFkAAoJELgmozMOVy/dCacP/j0UuumgV1RkCUBjGBal67hF
KBy1DQVwbo/Pjk474wScvVXTllkwHSdStwioah1UxyhAif7sPIjCpOPlsmRWXx4n
KaAuC/OlO5AsDyPSJ+7f7kxvE5BEDyXlvIf/1fBDrSI54rS+gJBz2vxXRBrnvDxT
tt00zFlqncK7fKPZeWvxLjR0ZvgOguaN+YqIiaE1VAk/VvwUKDUDcI8xdFee6GiW
uSDJYtgK+uzibx57i0VPsICsZRxgRjfI61RfcsiOBEJ2KfTQwJozHpKyqJ+tYcoN
YD3zzQIPyYsSv9z6dIDDShHebnEHxU3rsWaqMlil8s3KFezP8CXSWBVza2EucWAc
knD8pG8o8tAo0qUpNSl1+tjay/vO8UVki+92ErkLVETOxYfOjNeUGRVdHzfWrnPw
A2mMSqGk2gFGrB+xDDCFWbEiu4WCNWdEJgU71NjCmwnQGHE+yFwKwzyKxIxX5a+w
s6Nijs0mjgj7zjOhPwyHh4qAdGzI8/yYRJ4vWEXanZaDJV88TiGr7qHYKpoexT8Z
buNoWX/+r6xnvlF+tBfTYtbuI+96sULX0wuKCe4XDO7OVKtl5FE/1UwFVoq3tcix
cqNHX2BYHxXxFqA9pF0cIQoZqJCi0QKOEbUhODLhL+XG0APK6N135qO1oB+DnII5
q+W2GB6ShIICTD0U8X7X
=2ekc
-----END PGP SIGNATURE-----

--fKRFv05pQQF21rjIaNQHUbB9MWvhRqRv1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
