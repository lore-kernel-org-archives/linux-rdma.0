From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/srpt: Revert "Convert to percpu_ida tag allocation"
Date: Thu, 7 Apr 2016 17:00:31 -0700
Message-ID: <5706F49F.9020500@redhat.com>
References: <57055BC6.7070402@sandisk.com> <5706E548.3080002@sandisk.com>
 <1460072224.18732.67.camel@haakon3.risingtidesystems.com>
 <5706F0E8.5020705@sandisk.com>
 <1460073123.18732.80.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="xm4m6jrRJ9bWLOb7s51bUh1t2vtgtG33U"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460073123.18732.80.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xm4m6jrRJ9bWLOb7s51bUh1t2vtgtG33U
Content-Type: multipart/mixed; boundary="HLG7VkgwI2Wv2kfoHuPD7FOG3rHleApsE"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>,
 Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <5706F49F.9020500-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/srpt: Revert "Convert to percpu_ida tag allocation"
References: <57055BC6.7070402-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> <5706E548.3080002-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
 <1460072224.18732.67.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
 <5706F0E8.5020705-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
 <1460073123.18732.80.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
In-Reply-To: <1460073123.18732.80.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>

--HLG7VkgwI2Wv2kfoHuPD7FOG3rHleApsE
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 4/7/16 4:52 PM, Nicholas A. Bellinger wrote:
> On Thu, 2016-04-07 at 16:44 -0700, Bart Van Assche wrote:
>> On 04/07/2016 04:37 PM, Nicholas A. Bellinger wrote:
>>> On Thu, 2016-04-07 at 15:55 -0700, Bart Van Assche wrote:
>>>> That patch causes the ib_srpt driver to crash as soon as the first
>>>> SCSI command is received. This means that that patch was untested.
>>>> Hence revert it. The shortcomings of that patch are as follows:
>>>> - It makes the ib_srpt driver use I/O contexts allocated by
>>>>    transport_alloc_session_tags() but it does not initialize these
>>>>    I/O contexts properly. All the initializations performed by
>>>>    srpt_alloc_ioctx() are skipped.
>>>> - It swaps the order of the send ioctx allocation and the transition=

>>>>    to RTR mode which is wrong.
>>>> - The amount of memory that is needed for I/O contexts is doubled.
>>>> - srpt_rdma_ch.free_list is no longer used but is not removed.
>>>>
>>>> Revert commit 0fd10721fe36 and thereby fix the following kernel cras=
h:
>>>>
>>>> kernel BUG at drivers/infiniband/ulp/srpt/ib_srpt.c:1439!
>>>> invalid opcode: 0000 [#1] SMP
>>>> Workqueue: target_completion target_complete_ok_work [target_core_mo=
d]
>>>> RIP: 0010:[<ffffffffa052ef37>]  [<ffffffffa052ef37>] srpt_queue_resp=
onse+0x437/0x4a0 [ib_srpt]
>>>> Call Trace:
>>>>   [<ffffffffa052f009>] srpt_queue_data_in+0x9/0x10 [ib_srpt]
>>>>   [<ffffffffa04f1ee2>] target_complete_ok_work+0x152/0x2b0 [target_c=
ore_mod]
>>>>   [<ffffffff81071ea7>] process_one_work+0x197/0x480
>>>>   [<ffffffff810721d9>] worker_thread+0x49/0x490
>>>>   [<ffffffff8107878a>] kthread+0xea/0x100
>>>>   [<ffffffff8159b172>] ret_from_fork+0x22/0x40
>>>>
>>>> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>>>> Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
>>>
>>> I've already asked you not to revert the patch [ ... ]
>>
>> But why not to revert that patch? Your patch was completely untested a=
nd=20
>> makes the ib_srpt driver unusable. I think the regular approach for su=
ch=20
>> patches is to revert them and to rework these in a later kernel versio=
n.=20
>> Linus, please let me know if you disagree.
>=20
> Because I'm actively working on a bug-fix for the regression, and it's
> -rc2 in a target driver that hardly anyone cares about.

I care about this driver.  It's what we use internally for all of our
SRP testing as we don't have and of the big DDN arrays that provide an
SRP targets, so we built our own so we could test our clients.

> If the regression is not addressed before v4.6-rc6, then by all means
> revert the original patch.
>=20
>=20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>    GPG Key ID: 0E572FDD
  Red Hat, Inc.
  100 E. Davie St
  Raleigh, NC 27601 USA


--HLG7VkgwI2Wv2kfoHuPD7FOG3rHleApsE--

--xm4m6jrRJ9bWLOb7s51bUh1t2vtgtG33U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJXBvSfAAoJELgmozMOVy/d47sP/i1BkMYYHgyNdC9oVuRqlI+K
j/0/pFD+Iw7hJXGXFTMjaEfEJwB16gMSI38LbvWryQMtBpZqySDfTL+CR46y38k9
tNLoUyI+XKH6jd+z1Gi3y0zHYa6V4OrOUJKhKlr+u3VJI0dq+LORI5I4/pyxyqpc
0wIZCj4DaHgExN6VcNSVdcQ0TVRYLRWj++31x5gKslLjIy8Z44Y0KCQrz48PbAJV
fBHp0o64/canJSK7TeC/F1WslG4bPqynSjevgxwm1fZjPV4wEYDVbzDR6f/AEfQ9
wQfPja8N236Pv9GMMRHM6MZREyGjsp0paw+eyLpdrNDcEFAWa9knUNWohTx0iAfb
3BFz/mxxp+ojcPWb8LbWjkZm64K9Cs+UyDDWiI4NHLfuwCftuUPvc9QxfOjQLANz
Thdcpeif/mlgI7T5ZWuRFo0cdTbhHhvhHE2JzP5Lf+Ss2DJjxdzby3qdxUeLYSg2
URgDkVBRN8ze+qEpxDCOMUmGBK4UUw3xtUTBqaGyzJ1/OwBaVV/+nb6ZPSJcgEK3
POlqNai0OcqMkNutKXsOt67kwpIO0D5PC2vee1ZUPy8ck3VX8rbLxYMsjfYyXed+
HgTghydgEzmDeX8qEXlIu07iHhfg4MqQecwUfvNBULNPgcFbshuwox4HZB5xcU9F
gKgBuL9fc+VQWThYW/CC
=FQfY
-----END PGP SIGNATURE-----

--xm4m6jrRJ9bWLOb7s51bUh1t2vtgtG33U--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
