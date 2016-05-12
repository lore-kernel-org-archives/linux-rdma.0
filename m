From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] rdma\hfi1 - coding style issues cleanup
Date: Thu, 12 May 2016 16:25:38 -0400
Message-ID: <f7fb16c7-7d5b-6b77-7879-1f16bdf76665@redhat.com>
References: <1461830300-2851-1-git-send-email-omer.dagan@tandemg.com>
 <20160428124127.GB9685@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ml8R9mCOfEsca9CdJxUqADiXX4kWACDlI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160428124127.GB9685-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ml8R9mCOfEsca9CdJxUqADiXX4kWACDlI
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/28/2016 08:41 AM, Dennis Dalessandro wrote:
> On Thu, Apr 28, 2016 at 10:58:20AM +0300, omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org wrote:=

>> From: Omer Dagan <omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org>
>=20
>> diff --git a/drivers/staging/rdma/hfi1/aspm.h
>> b/drivers/staging/rdma/hfi1/aspm.h
>> index 0d58fe3..384df0a 100644
>> --- a/drivers/staging/rdma/hfi1/aspm.h
>> +++ b/drivers/staging/rdma/hfi1/aspm.h
>> @@ -234,7 +234,7 @@ static inline void aspm_disable_all(struct
>> hfi1_devdata *dd)
>> {
>>     struct hfi1_ctxtdata *rcd;
>>     unsigned long flags;
>> -    unsigned i;
>> +    unsigned int i;
>=20
> Can you please explain the value in doing "unsigned int" vs "unsigned"?=

> None of the static checkers like checkpatch, sparse, or coccinelle seem=

> to mind.

I'm not a big fan of all this churn for something that means next to
nothing.  The C language specifies that unsigned means unsigned int,
adding int is actually redundant and makes code lines longer to read.

>> u64 read_csr(const struct hfi1_devdata *dd, u32 offset)
>> {
>> -    if (dd->flags & HFI1_PRESENT) {
>> +    if (dd->flags & HFI1_PRESENT)
>>         return readq((void __iomem *)dd->kregbase + offset);
>> -    }
>> +
>>     return -1;
>> }
>>
>=20
> Also please don't fix multiple types of issues in one patch. This is
> very easy to lose sight of in the review and stands on its own.
> This is a checkpatch issue. Likely the result of a previous patch
> removing a line of code, something that is only seen when you run
> checkpatch on the entire file not just the patch so this is a good find=
=2E

Agreed.  If you want to resubmit a patch with just this fix, I'll take
it, but the rest of it I don't care for.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--ml8R9mCOfEsca9CdJxUqADiXX4kWACDlI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNObDAAoJELgmozMOVy/dTG4P/2BTAzE/MlvtAHJe5yj0zVYG
4dZ1xGhOWXFPd2hmrCWKudJoRnb8sWUaz3FRj7e9ZfKdkYCNbmItkeQflkaNtDcb
d06zsBkWsOU379qW0jhLfCN1jqfCoMImP4D4WWWSQBS+e1Vm3OKo4LayNFHzEe9c
X38AzWh63+QRE06f7GjzA5BCFGi4NUvwqzIdHB1ln1y/GpMIQgsbNowB4q4DwpBF
e6ieYu27qLpAf5QpNFEp07ZwV/asNKTBoP7KCE7BtztXYXJt+3wXVZS9taFxud1z
Bm5GClBz8SBeghWjHrktPMIIwUnwMw+L2WUbJWpo6n7+kTTSsB/35MRwU05RTAxk
G1fIZtyP5JfvCSyqtGkyp6VP8FAYqWQhzwl6cRtUmfTomlxtqQgwS+hEUaL5nsIc
UTsSLN2QOPGCwwKS9wq3emilc9hdnSKoln+LiQvWGpsz6lXUYsss+jxevk8C0HXk
i/ObOnJotwEZj5sPJXp75o8G+shm/NkiEJYVTOPl0rkJsV/MQjU8SL+N4DLIFK82
rVps9RxSYUJHNwJgLe20xwz+alUbiZmuiqeMdO0XeGc+zTHSRNq3NGmRgS0AKx92
8BOs9ib0Nnita4vM21bYflHLwELGpV6g3EUavCAkJXF+h5F5drf/OfRS3pUk+nOu
VcM2lVhXen0aOJ37f/rt
=j1Mo
-----END PGP SIGNATURE-----

--ml8R9mCOfEsca9CdJxUqADiXX4kWACDlI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
