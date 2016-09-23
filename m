From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V3 6/6] RDMA/core: Unify style of IOCTL commands
Date: Fri, 23 Sep 2016 13:32:54 -0400
Message-ID: <669b7bcf-14e6-ea13-4f67-ab6f702bab7c@redhat.com>
References: <1472988635-31463-1-git-send-email-leon@kernel.org>
 <1472988635-31463-7-git-send-email-leon@kernel.org>
 <1473166808.2465.9.camel@intel.com> <20160907070109.GC3639@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HkwhHxWhm0uSUMRXoIstIMP6Tkb09WjPE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160907070109.GC3639-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HkwhHxWhm0uSUMRXoIstIMP6Tkb09WjPE
Content-Type: multipart/mixed; boundary="f56mE5ABHhQreKav6x4cNxrbuQ9IWTrD7";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <669b7bcf-14e6-ea13-4f67-ab6f702bab7c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V3 6/6] RDMA/core: Unify style of IOCTL commands
References: <1472988635-31463-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1472988635-31463-7-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1473166808.2465.9.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> <20160907070109.GC3639-2ukJVAZIZ/Y@public.gmane.org>
In-Reply-To: <20160907070109.GC3639-2ukJVAZIZ/Y@public.gmane.org>

--f56mE5ABHhQreKav6x4cNxrbuQ9IWTrD7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/7/2016 3:01 AM, Leon Romanovsky wrote:
> On Tue, Sep 06, 2016 at 01:00:12PM +0000, Dalessandro, Dennis wrote:
>> On Sun, 2016-09-04 at 14:30 +0300, Leon Romanovsky wrote:
>>> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>
>>> MAD and HFI1 have different naming convention, this patch
>>> simplifies and unifies their defines and names.
>>>
>>> As part of cleanup, the HFI1 _NUM() macro and command indexes
>>> were removed. It has a potential to break applications which use
>>> these defines directly, while shouldn't.
>>
>> Please be explicit. It's not that it has potential. It *will* break
>> applications which use these defines directly.
>=20
> Yes, you are right.
>=20
> Doug,
> What do you expect from me? Respin?

No, I reworded the commit message myself:


    RDMA/core: Unify style of IOCTL commands

    MAD and HFI1 have different naming convention, this patch
    simplifies and unifies their defines and names.

    As part of cleanup, the HFI1 _NUM() macro and command indexes were
    removed (controversial). This will cause intentional (and arguably
    unnecessary) breakage to the PSM user space library.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--f56mE5ABHhQreKav6x4cNxrbuQ9IWTrD7--

--HkwhHxWhm0uSUMRXoIstIMP6Tkb09WjPE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX5WdGAAoJELgmozMOVy/dexwQAIhQthZXD8mdC4O1xXxhy6bC
k5XO/9hH3i+pzU8HtOmHFsL3RaxoIhXfpda1juCfgxVk4gwxyvHjOkLiwyeAlFB1
H5F9Zx14mmEb3XYEvhjsb2UO8W5f7oq3eKA2mDSqyk4hFgMBLJ1wGITiNfwjT7gd
UC9PmL3jnmEnxF69+yfKW7hvL5x5giFFzk9X5QscWuoRr3ChnxOewSNQTG4iCgR0
i/JasxbyT8Xi0hjnrASL19nwENJ+b/STs9s6zTDRtXdxpxFIEjEC977u8fdFJFEV
k4Zyllvp5J+M05t3wcQXdoBaS51Ha+3fvXaisXyfM3i96X8U+9RQP/uyfGYQYpHt
ncDWIV1ukfyaRCDmXG2MZKU08XStPK29ohXgnOJdZL6fjcMpKNY/uFvZ1O4Dzvmc
Aq+zRTl83elbkl0ugmdXE+DjbbnOHfL54Q09O+Rlc7/OTF3UP6NZD/xCRYN3+hWp
/CL/mb5+yUD0IoRsyi7PA06z2q4xu7T3U/uQboU2C3NLaGnuk9O8WS41kuBK4iaf
Jjov3ZCfgW8WZz9kQ15H9agS83jl99+4qxzeofvUB6rypMOqhcANE7Qtotu7MKBD
hh39Cl8IJITR33lp40HNWgCKNsI6f1nWmSHcAG65NzSTnJeIRFURg9grWorGkaXo
B6gauhOm6ZMTvINO1v6m
=pj3g
-----END PGP SIGNATURE-----

--HkwhHxWhm0uSUMRXoIstIMP6Tkb09WjPE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
