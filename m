From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Use correct src address in memcpy to rdma stats
 counters
Date: Mon, 12 Dec 2016 17:20:53 -0500
Message-ID: <ed065665-8aa9-46f0-f57e-6cd1dcb7480e@redhat.com>
References: <1478883341-22124-1-git-send-email-shiraz.saleem@intel.com>
 <20161206173917.GB15668@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WuhOiAtFqWqR2a2KLxaGCE38j3HFXvPRM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161206173917.GB15668-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org" <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WuhOiAtFqWqR2a2KLxaGCE38j3HFXvPRM
Content-Type: multipart/mixed; boundary="jcoL4cpuAsCufFKUJMvXjvuolr1SI0lCx";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>,
 "cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org" <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Message-ID: <ed065665-8aa9-46f0-f57e-6cd1dcb7480e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Use correct src address in memcpy to rdma stats
 counters
References: <1478883341-22124-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 <20161206173917.GB15668-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
In-Reply-To: <20161206173917.GB15668-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>

--jcoL4cpuAsCufFKUJMvXjvuolr1SI0lCx
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/6/2016 12:39 PM, Shiraz Saleem wrote:
> Doug - Can you please pick this up for 4.9? It was a bug introduced in =
4.7.=20
>=20
>=20
> On Fri, Nov 11, 2016 at 09:55:41AM -0700, Saleem, Shiraz wrote:
>> hw_stats is a pointer to i40_iw_dev_stats struct in i40iw_get_hw_stats=
().
>> Use hw_stats and not &hw_stats in the memcpy to copy the i40iw device =
stats
>> data into rdma_hw_stats counters.
>>
>> Fixes: b40f4757daa1 ("IB/core: Make device counter infrastructure dyna=
mic")
>>
>> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> ---
>>  drivers/infiniband/hw/i40iw/i40iw_verbs.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infin=
iband/hw/i40iw/i40iw_verbs.c
>> index b71394b..02c8f9a 100644
>> --- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
>> +++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
>> @@ -2498,7 +2498,7 @@ static int i40iw_get_hw_stats(struct ib_device *=
ibdev,
>>  			return -ENOSYS;
>>  	}
>> =20
>> -	memcpy(&stats->value[0], &hw_stats, sizeof(*hw_stats));
>> +	memcpy(&stats->value[0], hw_stats, sizeof(*hw_stats));
>> =20
>>  	return stats->num_counters;
>>  }
>> --=20
>> 2.8.0
>>

Picked up for the current kernel and stable tag added.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--jcoL4cpuAsCufFKUJMvXjvuolr1SI0lCx--

--WuhOiAtFqWqR2a2KLxaGCE38j3HFXvPRM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYTyLFAAoJELgmozMOVy/d8HkQAK3UHqndviBrkZLfrDTyfmWS
OIzHVQckgoukbcPxrncM6LyDrlRruId658AMXZu6YM8h8WI2vWLGASMY28WJhzOf
F3qB6UowW1Kt8peto/oJriQdlHQOjPp/eUBZ+hzJuKFc1kSseiWuUiFXrLeKRh7y
vkDWK1hpoy0R7FcHDKK7z6cm10W2haJsdhXotvYg/ByBuJC9duveWckH1w2QNUP4
JNlhiZxse6izBfCN0p4Y9dQbsKH4Vit+B5WJ2TapwsRkcs0eQ7JW3s1lqYfp9Gpz
46TdOFfyjfhVHrSRKMI4FfAUbifgYeH4FHJCf+aDEaZsBVkED3MrcpZwLHx67Yas
K7B0R4uZUtMLVbz694UxQuZdw6Lp8a4IJdxJyk2Dj+eSZz4HyDvwcnCwfCMcykge
mCRo8Lw9OMFFFjFtvPsKKzFWS5ac0aEueKSgP5TQdRrO1sjcBPelEKS9FQ+0LEVB
nT5Z6TuYN2rEbXvrARWKgQJVYGMv94rCTGf4Ceh05t5gnd9ocSfr6MyT48jMAXwW
syNNt7wzwYUg1ISxS9e/rKoQwABIrtoF037lFDvLE5PPRpRAgE0vVTOB7Yqx9Nse
yDQo/El8OrKoYTVjHffb4oR9abAKn/Pp7Ee8sf/xDQgNVHzMHx/I/38mcJruBICG
g4Ej8OYPsxm7bMOvon9L
=48iQ
-----END PGP SIGNATURE-----

--WuhOiAtFqWqR2a2KLxaGCE38j3HFXvPRM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
