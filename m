From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: VERBOSE flags
Date: Sun, 18 Sep 2016 16:35:37 -0400
Message-ID: <0a26585a-2e54-1c24-d212-0e2469afb8d8@redhat.com>
References: <CALq1K=KfU+N87pyfjfSd=G-thpyR0mjzuuxQ8eTuqrc2Mb+yZQ@mail.gmail.com>
 <77cd1f09-fa39-6f75-6c01-c7ef18909f30@redhat.com>
 <CALq1K=+0S-YnXQo5Hvc3bdOBNuEpowdSMYJThdmHqMNwOu8z1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="R5wmoO5CwvcS61rV1Un15NqFbGc5qKdjT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALq1K=+0S-YnXQo5Hvc3bdOBNuEpowdSMYJThdmHqMNwOu8z1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--R5wmoO5CwvcS61rV1Un15NqFbGc5qKdjT
Content-Type: multipart/mixed; boundary="6h1klBFvraCPsqpLDQ3pjfX7I9qI0iI3e";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <0a26585a-2e54-1c24-d212-0e2469afb8d8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: VERBOSE flags
References: <CALq1K=KfU+N87pyfjfSd=G-thpyR0mjzuuxQ8eTuqrc2Mb+yZQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <77cd1f09-fa39-6f75-6c01-c7ef18909f30-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <CALq1K=+0S-YnXQo5Hvc3bdOBNuEpowdSMYJThdmHqMNwOu8z1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CALq1K=+0S-YnXQo5Hvc3bdOBNuEpowdSMYJThdmHqMNwOu8z1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--6h1klBFvraCPsqpLDQ3pjfX7I9qI0iI3e
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/14/2016 2:37 AM, Leon Romanovsky wrote:
> On Wed, Sep 14, 2016 at 9:17 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> On 9/14/2016 1:27 AM, Leon Romanovsky wrote:
>>> Hi Doug,
>>>
>>> Can you please respond to my questions to this patch [1]?
>>>
>>> Thanks
>>>
>>> [1] https://patchwork.kernel.org/patch/9302591/
>>>
>>
>> I don't appear to still have that email.  But I know what I came up wi=
th
>> at the time.
>>
>> The debug information was in the mlx5 entry point for post_send.  That=

>> means you can create a sysfs entry that allows you to enable or disabl=
e
>> the debugging, and then make two different mlx5 post_send entry points=
=2E
>> When debugging is enabled, you simply change the entry point for
>> mlx5_post_send to mlx5_post_send_debug, where mlx5_post_send_debug is
>> essentially nothing but mlx5_post_send; dump_wqe.  The unconditional
>> branch will be highly optimized by the CPU, so no real loss on it.  An=
d
>> when not in debug mode, there is zero penalty.  In short, make use of
>> the entry pointers to make this configurable but also zero penalty on
>> the hot path in the non-debug case.
>=20
> I did it in similar way to Intel's HFI driver and had in mind future
> consolidation of all
> these verbose flags for whole subsystem.
>=20
> I proposed topic (debuggability) in mini-summit to talk about it.

OK, but if the hfi1 driver does this similar to what you were doing,
then I think we should change it too.

Essentially, given that all IB devices have a set of function pointers
that are registered and stored on a per device basis, there is no reason
that the core code can't be modified to present
/sys/class/infiniband/debug/<list of specific entry points we wish to
have possible debug functions for> and if the user wants to debug a
specific entry point, they set it to 1 when it's normally 0.  Then
drivers can optionally register debug versions of their entry points,
and in the core if the user tries to enable debug on an entry point, and
the driver registered a debug variant for that entry point, we start
using it.  Then we can drop the CONFIG_*_DEBUG options out of all of the
drivers.  That would be my preference.  I don't want any compile time
options because you never will be running a debug kernel when you need
it.  Per device, run time selectable so that you get 0 overhead in the
normal case is what I would like to see.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--6h1klBFvraCPsqpLDQ3pjfX7I9qI0iI3e--

--R5wmoO5CwvcS61rV1Un15NqFbGc5qKdjT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX3vqZAAoJELgmozMOVy/d4yQP/3oh/PGvAaxF0roP5mjTTtqr
G3xV4nRMydrihgTcuSEJvhjuBRim5645iDoXDNacecPmJa4XmQrUwsUd4o74W1Hc
fNHD/ih6XtwwD0DYvdKbxTVgcUzr87WewB9Bsz7uc09i6Ll9OIGXuYmRljS+2+rT
pFAMp8aU8wbouhgpSnkOhXxTm6kCKvrlCNv1qymSdrjoM5WAFObiRExxBXTu6H2P
nKGB16NiYgCTSJYs02VL4aZ5sCQPltSxaUT4XUUy6Z2RahTqubV54ukdre8Q+yF7
QsNL5XTEIQVtKmnWQTMXHQU6SIZO0Qpo3ApxhQRxwsrbwJ1cHfJL8IvrMUoLMt33
04xvl7YIx3GAmxqdAPHK9dNkgx8eaDzuWQnZ53qF2rWZPQkZLSf61WGOA1n4FCdA
W4zpIGNVU0ssEwFzqzAjnWCkUPD+Wu6kQ1vrujwdxjlYuWTbgBvRF7/oVOP4KDsE
6gCtPowcFEmP4BEwAFdo9WaKOYgRSaVpEpn65hpgKgrStb5jU3JVcwEEd+6iWolk
JgkVn+GPNBKYQEgEU0J2Sdh4KE0oI19JGG+JaP2HhnTW00Bgj9S/oyQIpVgAZprs
VtHCfMNzOA4RnCk0OjH7tYvFG58Hx4CPimxGa/mTgYfRmm9ZkzMJAvOBqrlgYDir
rX5ohC9Ar4mvsCd5uFWX
=OO1P
-----END PGP SIGNATURE-----

--R5wmoO5CwvcS61rV1Un15NqFbGc5qKdjT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
