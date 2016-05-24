From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V5 for-next 1/4] IB/core: Introduce capabilitymask2 field
 in ClassPortInfo mad
Date: Tue, 24 May 2016 15:17:52 -0400
Message-ID: <6c094ba8-9ee8-76d4-94fd-ec9832054b1d@redhat.com>
References: <1463991263-13084-1-git-send-email-erezsh@mellanox.com>
 <1463991263-13084-2-git-send-email-erezsh@mellanox.com>
 <ead67cbd-ca28-322b-0435-ab01c1f04be5@dev.mellanox.co.il>
 <CAAk-MO-2JQpmb8xR4gqQQEfpEpQCgMbxgbOLXhLPW991FhvJWQ@mail.gmail.com>
 <f576c725-b78f-6432-5991-bf82fd0d9a8c@sandisk.com>
 <CAAk-MO-M6heX7bXi53gbDe89AnUQQ0fA2d_uiKHPyF+S_G4qhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BPTmWq0fhswreLKL8kwSqetJQbQ4W7Qvx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAk-MO-M6heX7bXi53gbDe89AnUQQ0fA2d_uiKHPyF+S_G4qhA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Weiny Ira <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BPTmWq0fhswreLKL8kwSqetJQbQ4W7Qvx
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 05/24/2016 03:03 AM, Erez Shitrit wrote:
> On Mon, May 23, 2016 at 6:26 PM, Bart Van Assche
> <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
>> On 05/23/2016 04:49 AM, Erez Shitrit wrote:
>>>
>>> On Mon, May 23, 2016 at 2:33 PM, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiiQ@public.gmane.org=
il>
>>> wrote:
>>>>
>>>> On 5/23/2016 4:14 AM, Erez Shitrit wrote:
>>>>>
>>>>> diff --git a/drivers/infiniband/hw/qib/qib_mad.c
>>>>> b/drivers/infiniband/hw/qib/qib_mad.c
>>>>> index 0bd1837..a872865 100644
>>>>> --- a/drivers/infiniband/hw/qib/qib_mad.c
>>>>> +++ b/drivers/infiniband/hw/qib/qib_mad.c
>>>>> @@ -1172,11 +1172,11 @@ static int pma_get_classportinfo(struct
>>>>> ib_pma_mad *pmp,
>>>>>        * Set the most significant bit of CM2 to indicate support fo=
r
>>>>>        * congestion statistics
>>>>>        */
>>>>> -     p->reserved[0] =3D dd->psxmitwait_supported << 7;
>>>>> +     ib_set_cpi_capmask2(p, dd->psxmitwait_supported << 7);
>>>>
>>>>
>>>> Is this really equivalent to what it's replacing ?
>>>
>>>
>>> Yes. the previous code sets the msb bit in the first byte of the
>>> capmask2 (where it was with 3 bytes), no other setting for capmask2
>>> in that flow, so it is the same.
>>
>>
>> Hello Erez,
>>
>> I think you need the following to set the highest bit of
>> cap_mask2_resp_time:
>>
>> ib_set_cpi_capmask2(p, dd->psxmitwait_supported << (31 - 5))
>>
>> Bart.
>=20
> Thanks Bart, I will check. and update.

If we can get a close on this issue, I'd like to move forward with this
patchset.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--BPTmWq0fhswreLKL8kwSqetJQbQ4W7Qvx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXRKjgAAoJELgmozMOVy/dGC4P/iMhSXp/Ndk7HJ1Z9eSoa1Fy
qKtrUC1+M9CTlWuyMurxltJIH4kNB1NORHSPOL65R+eIImu5wxMQa0r15VdEfhUW
vrfeMueDjxDIpv9BXNMQ6Loc0xF+k385ozaH13K9518meWwLkIINd43X+ItkfW0w
pKxkCyph/Z7gPUcoz42auL4Cgwb5NVMTZO6CP4kpOflP3Pd06f/uskriF0W7cFKa
4yuvFZzyojmL0lhrtn2v5dmy+HrqpxEpYoKsY+WR/OePiDrXcZ0v3bEr8mKZtQwr
PUXxxCADyJ78z2Y8m+QfljlJItIvZ7+deEPETPK4JNMRvjVWWcK+FFbrPkgYe+oG
p9lAEi/itnSudvoouihMNLnxShKIgqpDQOdwNFZCU4KQdhfk6svBoAiJlitAjiG8
vDh6rRcV7rZA+IGGJp9Gx46Utt11LH8ZNQEe0JhjRD7sFWKISMnzm0XX4I9p9o0S
PoAkfFwNhuBfPV22yQRRC3Dfo+tRo5d5M4T24e2VxXNvjVyJIT/z4cXxZp0kRRm+
uLVikZ4E14DfIpyJbo4GDmmV0ppTm5c3QjybVnvwNlq/IFDqYzObYksEAqg5OeQK
WYmK7NGY32vUgTaBCqZA4Ha2h45G/WLilcOjUz7ZUaBVj+/y3uobiFI0YAl+D1LQ
wu9fVzx8ObF65fRpQLR/
=mZnf
-----END PGP SIGNATURE-----

--BPTmWq0fhswreLKL8kwSqetJQbQ4W7Qvx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
