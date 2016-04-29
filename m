From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V1 0/2] mlx5_core: mlx5_ifc updates
Date: Fri, 29 Apr 2016 13:56:07 -0400
Message-ID: <f31784f8-080d-6a5c-2396-8eecc831416e@redhat.com>
References: <1460563864-22931-1-git-send-email-saeedm@mellanox.com>
 <CALzJLG__o56edSf__To-BM6jakuwP7zAAEEQH8LQNTKp-2LRDQ@mail.gmail.com>
 <20160415.172254.1148340547086083909.davem@davemloft.net>
 <20160418151205.GO6349@leon.nu> <5722BBD1.3030005@redhat.com>
 <20160429050752.GB774@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rMSxpguJr8CBGoEWMH6bjblOnK6unAguC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160429050752.GB774-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rMSxpguJr8CBGoEWMH6bjblOnK6unAguC
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/29/2016 01:07 AM, Leon Romanovsky wrote:
> On Thu, Apr 28, 2016 at 09:41:37PM -0400, Doug Ledford wrote:
>> On 04/18/2016 11:12 AM, Leon Romanovsky wrote:
>>> On Fri, Apr 15, 2016 at 05:22:54PM -0400, David Miller wrote:
>>>> From: Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>>>> Date: Fri, 15 Apr 2016 20:10:07 +0300
>>>>
>>>>> On Wed, Apr 13, 2016 at 7:11 PM, Saeed Mahameed <saeedm-VPRAkNaXOzXQFizaE/u3fw@public.gmane.org=
m> wrote:
>>>
>>> Hi Doug,
>>> Can you please take this patchset in addition to Dave? It will save
>>> our list from many kbuild errors.
>>
>> Dave, did you pull this from Leon's git repo, or apply patches and
>> generate new, unique commit hashes?
>=20
> Doug,
> We sent IFC changes before I had a tree, so Dave took it as separate
> commits. The coming release submission will be based on my tree.

The point of my question was that if we both take in patches, we
generate diffs with different commit hashes, and that technicall
represents a merge (although if the patches are identical, they should
auto-merge).  Linus had requested we pull from the same tree so we both
get the same commit hashes, then no merge conflicts since git will
recognize the commits as being *exactly* identical.  Right now, the only
way to accomplish that is for me to pull net-next and base my for-next
on net-next.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--rMSxpguJr8CBGoEWMH6bjblOnK6unAguC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXI6A3AAoJELgmozMOVy/dk2IQAJPC0wcxh+jXvpjzXI/og7gf
AWOWUTnZi5syt6DyQz7QERnUjW4p1l/+MbAjjtDYJlV4RtGrTa3koBGybr6vvJub
PILJI3sLaRu+VLIiNw0RDFjoN1B5DvHnjnh0Yfna1C9Bo068y0tRZn+upvhMFuhn
okvZpejsmqO8mA6d3RSlO49HIhpzS9zZVYb8gnfP9RtbvgNodRrdSlEtvCwodMfw
zXqqlT7h+OVdWSC9Of3gFOqLzo/ik1Fillm1J3ve6NgybS9C9GfCMIATJ0VlU9TK
+oSr0+ryyVDOYS+gQh21NbheR5nCOHdi7MtUSJmcKdTgrLYLPCqwcqdWpF7VukRB
N/opRTnOgwZ6IoMVpAoKC6Yt9lYtDtfPD+w8Wz99UfeLDGgkHSfZEEcDMbCJ4ZSA
CpqrrjnQ6848B/sm/pzbzan7aSwfGCHSe7XZnqOOd5xWxriTN+KrEqDVnaTGKA8V
1IJJEExT+G1dRLkDDx/dzm9k5Xk0HrDJ6sffFHusaanYMI7zFGX40i0YqBl6Nik1
vr+fZHIaq9ptkaahGEuNJTQLCkHj7qalOUeHqC3BGdYP650mMK0xrhnpHUccYSUg
7DkywxiADzJWP26LtR6akTwSwD4bMAF3G+eHjPqsgwe0buFuZyLabxRwTRI/moh+
QjZoIcm8UcAd9Gz2g6MI
=k01F
-----END PGP SIGNATURE-----

--rMSxpguJr8CBGoEWMH6bjblOnK6unAguC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
