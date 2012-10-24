From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/4 for opensm] /etc/init.d/opensmd: Improve systemd integration
Date: Wed, 24 Oct 2012 10:48:52 -0400
Message-ID: <5087FFD4.1070105@redhat.com>
References: <505C7D44.9060500@acm.org> <20121024132726.GB18591@calypso> <5087FC29.4030303@redhat.com> <5087FF1F.20907@acm.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE435D8190C80E75A3969210D"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5087FF1F.20907-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE435D8190C80E75A3969210D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/24/2012 10:45 AM, Bart Van Assche wrote:
> On 10/24/12 16:33, Doug Ledford wrote:
>> On 10/24/2012 9:27 AM, Alex Netes wrote:
>>> On 16:44 Fri 21 Sep     , Bart Van Assche wrote:
>>>>   start () {
>>>> +    if [ -e $pidfile ]; then
>>>
>>> On opensm segfault (happens one in a while :), pidfile won't be
>>> removed, so
>>> you won't be able to start the opensm again. I guess that same thing =
can
>>> happen on warm reboot.
>>
>> The stop action in the script should handle cleanup for you.  If it's
>> called, and a pid file exists, but the pid is not running, it should
>> remove the pid file and the subsystem lock file so that a clean start
>> works.
>=20
> Hello Doug,
>=20
> Do we really need the lock file ? On some Linux systems (Ubuntu) the
> /var/lock/subsys directory does not even exist.
>=20
> Bart.
>=20

It's an old holdover from LSB compliance.  *I* don't personally care one
way or another, but it's supposed to be there for ancient scripts that
look there to find out if a service is running.  Probably none of those
ancient scripts look for opensm as it wasn't around back when they were
written and the "new and improved" way of checking a service in LSB is
to run the init script with the status command.  But, that's why I have
it there.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigE435D8190C80E75A3969210D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQh//UAAoJELgmozMOVy/dmLEQAIkheGf2qgCueGFc25Cvo8/l
4oL7QjGLnGvTTPmzwJNEocgMEF3xLsNfbqomId7hH/LK+D4gK/iCr0QUr2SRJ7K0
BBiDXe7GXCCQaj7rlpGKDWZLqCOgIVIjPdOLhLdhLcY3SS7+P3jCCdSUsnBKt4O4
87IgKS3JIcd3km+WJULpfoVKlbqZ9dan1Q7QlnSQKh5anYteMD3aCJsm0FChG7MK
EuILPQK3ntcNft72DuXxyBFHTNGExYTNpeU/y4vRuUolXrD8unZ7w1VsnoYYDMj2
xJmCENAlVorif/vgRXBG/FtBiQa4BcYFxWU6pdeTv/3GBMdGjC838KVZw5J2cUSu
aCet0QRlzhY1fU9QhBJvKZIBuDz3JPodejvHtrvcsnAym0u/HuKEyTPxOyzuyiV/
9kVUh99fhlUKdyt7uz/ODE+Oow4uQYjt1lzaqD+BdRCXvLmXVuDh+bvZq8R0mrWH
s2FpjvLeMePbxxoysA0q19NViywBlwDRSa/53YyM05fdDSnw6rcW2F/iPqmdHUZL
gGriMdghDysTG2pC8jAcTrC+jVyic6kSnJowOr9Lcog57358TgbjT0u/sroRkb66
ziieLsbkLs3E3IuvxE84Kpzl8NBd6GIed5UQNEElsQqH1qkZzFComkwDy8h3fgKE
xsk04z06CTzUiU3Ex3m9
=AeN5
-----END PGP SIGNATURE-----

--------------enigE435D8190C80E75A3969210D--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
