From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Fri, 26 Aug 2016 13:53:03 -0400
Message-ID: <a4e3d830-71e5-76b1-927d-4e3b52a19ac5@redhat.com>
References: <e5da14cf-fd5a-895e-5fad-9020b6a7efb1@redhat.com>
 <20160826144415.GC594@leon.nu>
 <3aee5577-9600-db32-db7f-4fb39afdc429@redhat.com>
 <20160826171638.GD594@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="32GlGJqWM1AtLcQFBpoNLJiscicNmnfvu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160826171638.GD594-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--32GlGJqWM1AtLcQFBpoNLJiscicNmnfvu
Content-Type: multipart/mixed; boundary="LKWFJPAu9H7JWQEnSPjG3mAtbbouhkeJV"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <a4e3d830-71e5-76b1-927d-4e3b52a19ac5-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
References: <e5da14cf-fd5a-895e-5fad-9020b6a7efb1-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20160826144415.GC594-2ukJVAZIZ/Y@public.gmane.org>
 <3aee5577-9600-db32-db7f-4fb39afdc429-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20160826171638.GD594-2ukJVAZIZ/Y@public.gmane.org>
In-Reply-To: <20160826171638.GD594-2ukJVAZIZ/Y@public.gmane.org>

--LKWFJPAu9H7JWQEnSPjG3mAtbbouhkeJV
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/26/2016 1:16 PM, Leon Romanovsky wrote:
> On Fri, Aug 26, 2016 at 12:12:07PM -0400, Doug Ledford wrote:
>> On 8/26/2016 10:44 AM, Leon Romanovsky wrote:
>>> On Thu, Aug 25, 2016 at 03:29:12PM -0400, Doug Ledford wrote:
>>>
>>> Hi Doug,
>>>
>>> These two patches were supposed to be carried by us [1] and I explici=
tly
>>> said that. Especially, the last patch in this series is wrong. Please=

>>> revert it. The proper patch is [2] and it was supposed to be sent rig=
ht
>>> after our shared code.
>>>
>>>> Yuval Shaia (2):
>>>>       IB/mlx4: Make function use_tunnel_data return void
>>>>       IB/mlx4: Return EAGAIN for any error in mlx4_ib_poll_one
>>>
>>> [1] https://www.spinics.net/lists/linux-rdma/msg38580.html
>>> [2]
>>> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/comm=
it/?h=3Dtopic/mlx-fixes&id=3Dd5a1c56c3a49db6369b36aa04fbeabc7653ae107
>>>
>>
>> I saw your request to carry it, but then never heard anything again fr=
om
>> you.  The fix that the original patch implements is still valid and wa=
s
>> something I wanted to get into 4.8, where as your patch is being held
>> for 4.9 and goes down a different path to solving the issue.  IMO, the=

>> patch from Yuval is fine for 4.8, and if you want to apply yours to 4.=
9,
>> that's fine too.  I don't see a need to revert the existing patch.  Fr=
om
>> what I can tell, the existing patch will work fine and do what Yuval
>> intended, it just won't do what you intend to do in 4.9.  Please corre=
ct
>> me if I'm wrong.
>=20
> By our HW design and SW implementation poll_cq never fails and returns
> errors, so all these prints are to catch ULP bugs. In case of such bug,=
 Yuval's
> patch will cause to reentry (EAGAIN) and kprints storm again and again.=

> It is undesired and misleading behaviour.
>=20
> We targeted our patch to 4.9, because it is not actual fix, but help to=

> ULP developers and there is no real need to hurry up.
>=20
> Will it be acceptable by you, if I revert Yuval's patch before sending
> our version for 4.9?

Just post your version now.  I have another pull request for 4.8-rc,
I'll merge in your version into the next pull request.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--LKWFJPAu9H7JWQEnSPjG3mAtbbouhkeJV--

--32GlGJqWM1AtLcQFBpoNLJiscicNmnfvu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXwIH/AAoJELgmozMOVy/dS2oP/izwwDOTnHSenzlT+WuGNV1x
Avjz1vqFiGe9fV865QhvUDHnlRUBU9f6ZWTHH3ihbHCrrCqVZJJXGFrzpYfZ2dLf
TG/UIRSzgKOO7uAQS0ncIkvmHZacYgH2O0tfziNFLUYxO+GyAgYdwZ94JWEwo+Sx
JfEZ3dz+qzjN1bXVR7UgWJKcFnSlv6vwB2taNuovC3VCPr93jYne2AAuqbhqkbHd
fkqDiywDrvnEETs6GV86MQNwIfYxJr6HyHDtyuGBs84d2lgB4d1WLYd6nsh2mvB6
EdAmGUWCP+C14RzcGzMhAR8gwBL5dZBi+8xVFjJ132tAHoDs3Y7egZncGQWt2YjI
EqYGkV/zP6xwutnd7a9ey4z7FWDc7tJ8oC7spoZjm+hJoxEw7lE5eE2CrOjoxv2A
l7IuShFiNxhzzXeNYmKdsSQcksPydA0FjtZXW4pAFxuAqqS3Letm6gfUpeRBIZtG
sVqUTe8SJAw4x5U5yKUJOKbV7/QwGJyC8p21Cc24i2oZKam09VOqKp80jKXe4q76
pw9PnSIYo7By5GJJOMpkTvrgPy2WC6CRoSyKwhjt3yxaZawBXjIPWQbpYH1U40FW
1pfhn8usX0DuiR3VIk2YWv28JnJ0jq1tvLbkrWtK0Mwg/IsqwZBHW69C/ZCqqhN6
31bN6oQVVN/vz+gfYh0T
=9ckN
-----END PGP SIGNATURE-----

--32GlGJqWM1AtLcQFBpoNLJiscicNmnfvu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
