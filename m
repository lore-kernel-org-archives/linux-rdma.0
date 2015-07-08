From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] infiniband: Remove redundant NULL check before kfree
Date: Wed, 08 Jul 2015 18:24:01 -0400
Message-ID: <559DA301.20203@redhat.com>
References: <1037392254.437811436329408244.JavaMail.weblogic@ep2mlwas06a>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PBsSRKACBsJ7uFAK4Pu3hrJc7Qh1SPR0g"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1037392254.437811436329408244.JavaMail.weblogic@ep2mlwas06a>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: maninder1.s-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, PANKAJ MISHRA <pankaj.m-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PBsSRKACBsJ7uFAK4Pu3hrJc7Qh1SPR0g
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 07/08/2015 12:23 AM, Maninder Singh wrote:
> Hello,
>=20
>>> +			for (i =3D 0; i < dev->caps.num_ports; i++)
>>> +				kfree(dm[i]);
>>> 			goto out;
>>> 		}
>>> 	}
>>> --
>>> 1.7.9.5
>>>
>>
>> If you are going to change this, you might as well make it 100% correc=
t:
>>
>> i=E2=80=94-;
>> while (i >=3D 0)
>> 	kfree(dm[i]);
>>
>> Then you don=E2=80=99t have to worry about whether kfree works on NULL=
, every item you free will be guaranteed to be non-NULL.
> Thanks for suggestion :)
> Sent new patch with described changes, I was thinking one more thing.
>=20
> In below code :-
>         if (!ibdev->sriov.is_going_down)
>             queue_work(ibdev->sriov.demux[i].ud_wq, &dm[i]->work);
>         spin_unlock_irqrestore(&ibdev->sriov.going_down_lock, flags);
>     }
> out:
>     kfree(dm);
>     return;
>=20
> dm is freed after queue_work, is it correct to free dm when other dm[i]=
 are allocated ? i did not get it.

The dm is just there to give an easy way to refer to a variable number
of work structs.  The flow is supposed to be something like this:

alloc(dm)
for(i=3D0;i<num_qps;i++)
    dm[i] =3D=3D alloc(work item);
for(i=3D0;i<num_qps;i++)
    init dm[i] work item
    queue dm[i] work item
free(dm)

In this scenario, all of the dm[i] items should be queued to delayed
work.  When that work completes, it should then free these structs.  So,
yes, the dm variable itself is just a temporary means of keeping all
those work struct pointers together.  However, your question caused me
to look closely here, and I see that there is a bug.  In particular, if
we check the sriov.is_going_down and as a result *don't* queue a work
item, then we end up leaking that work struct.  In addition, I think
there is room to optimize this routine considerably.  I'll post a patch
for that in a minute.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--PBsSRKACBsJ7uFAK4Pu3hrJc7Qh1SPR0g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVnaMBAAoJELgmozMOVy/dbMcQAIG2/opz+xWAPdt3OcqePsI2
TCXkMULl2MG32GV4te/C5SXMJbo01psM/GLjuhLVdwLsgMOYKCVdHG1hTka2sWEz
JJTVWOZu5pa6qW1FYR1V3rAVNMzTDtY9Zjozn6joTvW2ymt6RKrR1COK47LYy1Q7
DSw6RzWdPYoHP6OXMafd2yqhwA6bDGqmmTDtuSh+Dk2y1/kVnVqv3FPWHE6KoDj4
38eyk5a6a9hwxzm633ObpOLuHKsOK29dFezlxrbyi91jBXAwivit3kTqSHulM0Xq
M3NdAuRIjwNGUxr9jHhVqN3pQ4Ci4Psl0kRFtdOPunwnARshxA1fCRTpn19EiZ7r
y4hkm6ICI0Ui4OpB99Xlrxt0zKVbEEwVlV/97GF0Chk6QB4qLJoqdqFfKDv/3z3M
RA2Vsgd5spHZkFyT3nYueyub4mhrl6JrhdPXqs70yyXFI6NPYfsRVjCr1BkHIAqX
2DyZZr3bDeBjC5TwND4O3LYGjJoCh2TXyz/xA573Gv1rtlCAKjXeoGnkpDpmClBu
TUydW+GFU1yyEw+1GkFLwjLNxU+zNHHYT9pwXd5u12EvkbGLRqg+b8tzo9Xbh89K
/aYlBBOWs46ABq6ynd8ubdZvZpleu4+uJ6yGUoWPEGSWsbPTCbMlbiLQHPAhV4qH
GQx7OgUkKvgtPI4sxxgl
=hrXL
-----END PGP SIGNATURE-----

--PBsSRKACBsJ7uFAK4Pu3hrJc7Qh1SPR0g--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
