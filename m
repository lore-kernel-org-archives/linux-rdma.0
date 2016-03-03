From: Doug Ledford <dledford@redhat.com>
Subject: Re: SRPt oops with 4.5-rc3-ish
Date: Thu, 3 Mar 2016 10:24:50 -0500
Message-ID: <56D85742.20401@redhat.com>
References: <56C0A6C3.3010903@redhat.com>
 <1456630639.19657.47.camel@haakon3.risingtidesystems.com>
 <56D274F8.9070804@sandisk.com>
 <1456634828.19657.84.camel@haakon3.risingtidesystems.com>
 <56D27C5E.6090405@sandisk.com>
 <1456635624.19657.92.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="THsVnAcSojdMCwSPGIQEwh2KmkUEdBudV"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456635624.19657.92.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--THsVnAcSojdMCwSPGIQEwh2KmkUEdBudV
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 02/28/2016 12:00 AM, Nicholas A. Bellinger wrote:
> On Sat, 2016-02-27 at 20:49 -0800, Bart Van Assche wrote:
>> On 02/27/16 20:47, Nicholas A. Bellinger wrote:
>>> On Sat, 2016-02-27 at 20:18 -0800, Bart Van Assche wrote:
>>>> On 02/27/16 19:37, Nicholas A. Bellinger wrote:
>>>>> This is a fairly recent srpt shutdown regression, right..?
>>>>
>>>> Hi Nic,
>>>>
>>>> My patch series to make TMR handling synchronous fixes what Doug
>>>> reported. If you want I can rebase and repost that patch series.
>>>>
>>>
>>> There aren't even any TMRs being processed, so I don't see how that h=
as
>>> anything to do with it.
>>>
>>> >From the logs, this OOPsen is related to some manner of recent srpt
>>> configfs se_node_acl + se_session active I/O shutdown regression.
>>>
>>> So short of sitting down and reproducing myself on v4.5-rc code,
>>> commit 59fae4de's removal of ib_create_cq() + ib_comp_handler callbac=
k
>>> usage look like a good place to start the investigation.
>>>
>>> It would be useful to first find out what changes introduced this
>>> regression, and how far back Doug is able to reproduce.
>>
>> As I wrote before, this patch series works 100% stable on top of my mo=
st=20
>> recent LIO core patch series, a patch series I have also made availabl=
e=20
>> on github. So what Doug ran into is a LIO core bug and not an ib_srpt =
bug.
>>
>=20
> Active I/O shutdown with srpt has not always triggered this OOPs.
>=20
> There is a reason why this is happening now, and it needs to be
> identified.
>=20
> Either you can help out doing that, or not.  Either way, I'm certainly
> not going to let you hack up LIO TMR code, when there even aren't signs=

> ABORT_TASK and friends are occuring in Doug's particular shutdown case.=

>=20

Sorry I didn't notice this thread had picked back up, I was off on other
stuff.

I can't say if this is new or not.  We added some new testing, that had
considerably more luns in use and more transfers taking place, and while
I was rebooting some actively used servers, I saw this issue.  It might
exist on earlier kernels, I would have to try them to know for sure.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--THsVnAcSojdMCwSPGIQEwh2KmkUEdBudV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW2FdCAAoJELgmozMOVy/dkuoQAJ/u+t3O5HuwDi2tkYn2GLzM
DOA1nFbwK0W+lvn9PZo2FNOXTRAZOve0ylNJUqPVWYPOVVPUm4Y8rhHgA/qN6dZo
eJYp/DAtqMpIcKOAJl3KVmDnW5Law3t1S1HTm8uBe+WQb+YEdTz9khSGqmvhukil
qgl8N3OMWNQYeo3H9bGqxbUol3suaTouI9XdcQg8khNP/5PqMtxZb+ZBWKE71Dgt
F/nzSnmaB1zs6/trnERJRW/uJPWpj7+E+pHSxfO7pJkzLB2bq8vrrMWWhROQrmPl
KwTIC0W5ldS/sXhIuSy3wZs6RxfQOH6mIPkwXfIK5g1gowDDaHFEYwglv+t60pnm
V+vnc85Vm4d/9Xo9x6rfm1+nfy9fB2rU3RWdCTTk2o+QjLTRhfvj47Jam2FG2HKi
kbob+fDKAgHfuTpHgE1j9I//mACVK6ACVITrZxaAt5JVy/1oRxrGkX54M2KuW09H
oTXl+DJxOxNhCkdH4MY++hu2IkZyresnyv+2oGWgy+nyreCEtLIGuEoPG7Dq9Lx7
WYpzYJ1VOhb22VTjfZaYiCStj1KTC2MdwPRxzhX0pfvY93xciz8gS0tBDZom6Stm
Ug/6tX5wq7Pt+xHcUIz/1l1RaNDYUv3Yxh56vRqMvohKW2zWJ/hsEt5RTFd++J+Z
/DyALJvdgZXtFpbGQukx
=+t9B
-----END PGP SIGNATURE-----

--THsVnAcSojdMCwSPGIQEwh2KmkUEdBudV--
