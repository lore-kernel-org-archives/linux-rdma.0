From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] iw_cxgb4: Fix cxgb4 arm CQ logic to handle
 IB_CQ_REPORT_MISSED_EVENTS
Date: Tue, 23 Aug 2016 12:44:29 -0400
Message-ID: <69627627-77d1-8c4b-5960-934dedc04f7b@redhat.com>
References: <20160823145733.21093-1-bharat@chelsio.com>
 <00f801d1fd56$d1e44d70$75ace850$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UHCSBMj3PWDDIqmpFrqUmX8fsKCHvPFDn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00f801d1fd56$d1e44d70$75ace850$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Potnuri Bharat Teja' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UHCSBMj3PWDDIqmpFrqUmX8fsKCHvPFDn
Content-Type: multipart/mixed; boundary="GWVVdjP4kjctQbQwT6kkuBi8ohShBlG8r"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>,
 'Potnuri Bharat Teja' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <69627627-77d1-8c4b-5960-934dedc04f7b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] iw_cxgb4: Fix cxgb4 arm CQ logic to handle
 IB_CQ_REPORT_MISSED_EVENTS
References: <20160823145733.21093-1-bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
 <00f801d1fd56$d1e44d70$75ace850$@opengridcomputing.com>
In-Reply-To: <00f801d1fd56$d1e44d70$75ace850$@opengridcomputing.com>

--GWVVdjP4kjctQbQwT6kkuBi8ohShBlG8r
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/23/2016 11:55 AM, Steve Wise wrote:
>> Current cxgb4 arm CQ logic ignores IB_CQ_REPORT_MISSED_EVENTS for
>> request completion notification on a CQ. Due to this ib_poll_handler()=

>> assumes all events polled and avoids further iopoll scheduling.
>>
>> This patch adds logic to cxgb4 ib_req_notify_cq() handler to check if
>> CQ is not empty and return accordingly. Based on the return value of
>> ib_req_notify_cq() handler, ib_poll_handler() will schedule a run of
>> iopoll handler.
>>
>> Signed-off-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
>=20
> Looks good.   Doug, perhaps this can make 4.8-rc?
>=20
> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>=20
>=20

Yep, applied.  Thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--GWVVdjP4kjctQbQwT6kkuBi8ohShBlG8r--

--UHCSBMj3PWDDIqmpFrqUmX8fsKCHvPFDn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvH1tAAoJELgmozMOVy/d1joP/i7NoUlKEfYV3X24S+lZIN3I
8K1yHNhUnHzpUqDKBThKN3slo7rf4+5DQg9lmVdWx0sXn9qkjxYlFspEy0iK7PqQ
PRRqLW6b5hrDFNjI8oWeQPe6nSlCAb8W9U+FfnGJsgX5sC1pFUFmYg+A7bhi49gW
eZn6Z4kko++hdz4x5l1DFefYSGuyHtykMs2rEmhx9OixP43RhMHjRhrYy/JbqNAe
K1FoKq7SPBsRcUrolq/+Qi0l0/YQangkMgcH5r4FhvedPnUqxyVwB13YuIfrEQVI
fYKeWw59ecbEZk23p8Ly3rk27+4KKvM0DsJYn8WYfERryXO/bjEg/boTIaeKV73M
/dzshCB3Ci/jfPHHmV2sINXx1K7die3JDT8gtLcRysa5Gr9IZOf3GHeSUjJ5cmcT
RBSMNCo5GdKzdEFBCAV+kmJVv9GDIwnttg7p0v7+lUCgM5wPsgUnIA+1FCqAkABu
Vr4/xmgojUlgDolZwxMPd2CyrhV47oLNcLIHEdsvB2X5Lg5dKRv50PnKR/gDAEBz
jshhTDgCvUzyw9llCxWUFjYEqYbQt5904HJIQgmtQmoWJzyRHjlvjtfob3Sl2q4M
i7q+iPLCuABLyjYtmH5mlsTXV9bicZUz+y6gNVyHywJJfrjh6C4R7+JaFL7bAGt7
LGDtNREmzfk6jYJBadzr
=+l5M
-----END PGP SIGNATURE-----

--UHCSBMj3PWDDIqmpFrqUmX8fsKCHvPFDn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
