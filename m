From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1,IB/qib: Fix qp_stats sleep with rcu read lock
 held
Date: Mon, 22 Aug 2016 14:21:32 -0400
Message-ID: <8e1fa0b2-9e09-a4a8-d686-ca5e00eb33cf@redhat.com>
References: <1470755786-14054-1-git-send-email-ira.weiny@intel.com>
 <20160809181146.GE23921@leon.nu>
 <20160810055151.GB32695@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UDxUMHisQuf9eQlAlNgj2qiPeIBBHDl74"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160810055151.GB32695-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UDxUMHisQuf9eQlAlNgj2qiPeIBBHDl74
Content-Type: multipart/mixed; boundary="7RevUbk9O9GAGJiXOgXBxkR1mMum7vUlW"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn
 <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <8e1fa0b2-9e09-a4a8-d686-ca5e00eb33cf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1,IB/qib: Fix qp_stats sleep with rcu read lock
 held
References: <1470755786-14054-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 <20160809181146.GE23921-2ukJVAZIZ/Y@public.gmane.org>
 <20160810055151.GB32695-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
In-Reply-To: <20160810055151.GB32695-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>

--7RevUbk9O9GAGJiXOgXBxkR1mMum7vUlW
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/10/2016 1:51 AM, ira.weiny wrote:
> On Tue, Aug 09, 2016 at 09:11:46PM +0300, Leon Romanovsky wrote:
>> On Tue, Aug 09, 2016 at 11:16:26AM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
>>> From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>
>=20
> [snip]
>=20
>>> diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniban=
d/hw/hfi1/debugfs.c
>>> index dbab9d9cc288..c35bef8dd5aa 100644
>>> --- a/drivers/infiniband/hw/hfi1/debugfs.c
>>> +++ b/drivers/infiniband/hw/hfi1/debugfs.c
>>> @@ -223,28 +223,35 @@ DEBUGFS_SEQ_FILE_OPEN(ctx_stats)
>>>  DEBUGFS_FILE_OPS(ctx_stats);
>>> =20
>>>  static void *_qp_stats_seq_start(struct seq_file *s, loff_t *pos)
>>> -__acquires(RCU)
>>> +	__acquires(RCU)
>>>  {
>>>  	struct qp_iter *iter;
>>>  	loff_t n =3D *pos;
>>> =20
>>> -	rcu_read_lock();
>>>  	iter =3D qp_iter_init(s->private);
>>> +
>>> +	/* stop calls rcu_read_unlock */
>>> +	rcu_read_lock();
>>
>> IMHO, it should be placed after your if(!iter) check below.
>=20
> I know this seems weird but this makes the rcu locking "balanced".  Ret=
urning
> NULL here still calls "stop" which is going to call rcu_read_unlock.  I=
f we
> move rcu_read_lock we need to maintain state to determine if we called =
lock or
> not.  This is easier.  To me it does seem odd that the sequence operati=
on does
> not stop on its own when NULL is returned but that is the way it works.=

>=20
>>
>>> +
>>>  	if (!iter)
>>>  		return NULL;
>>> =20
>>> -	while (n--) {
>>> +	if (qp_iter_next(iter)) {
>>> +		kfree(iter);
>>> +		return NULL;
>>> +	}
>>> +	while (n--)
>>>  		if (qp_iter_next(iter)) {
>>>  			kfree(iter);
>>>  			return NULL;
>>>  		}
>>
>> It looks like you forgot to remove the lines above.
>=20
> Nope this replaces a call to qp_iter_next which was in qp_iter_init.
>=20
> As the commit messages says we move the implict next's back into the re=
spective
> start functions.
>=20
> Ira

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--7RevUbk9O9GAGJiXOgXBxkR1mMum7vUlW--

--UDxUMHisQuf9eQlAlNgj2qiPeIBBHDl74
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXu0KsAAoJELgmozMOVy/dEY4P/0XtbxX3fD0EONj9HeIKf8CR
AxjF61k+rjnlmogZbxKCtOyaWyxko4uSSEUbcTpvLB8OfPHERAhuqgjqnZF9MzRX
bE4Wwpi1uCpx/SOHyHtACpeAkS8jq3O4RkcWzdznRJJasylqtPvy5dt4CUfcZQWO
QLwRF9GFU5xsoWtA82SFKNfXXGiMGQHObhSAFZW/WqWkLpuElpqHu7mBkZK8b8SF
Pbq3fbLfc8ODBR3EeODYzvSwXqcbc6CSi7fgTFX7+i68qJ92I8KFGO3rv/hlRMHb
taSr0NnridVKQY7WhjCqNBbrlVQIkN2M/9a+Zq4A+C072rwm+oKEDklDlMBOSgDo
harwaNKo2/+pH8HPyh7XGS4bpYdODyLvxs6a87APXhaZx7FQ3JxxcPVgZA9GJZqT
LKH6MjHmT4dFDtCO/wlWAPLsG9qm6suYayGmtz4xDpUnqRzQAZWY/bFkDl1/Xunc
7H7ApfqlU+k/obNFWvQLO114y6am3DIMuqfunvQ4lh9A5EnvdZvtmyzJoVR+/L5M
nRQK2bS0O2ROaINRWxgxIjd/IE4ubPXbCJbRlR8iBjZsJMZ1D2ydBfcB5e8gHYJh
ajkyUGNv7hUnJ0yM3ig8BPJB4KnVk0CPJX1PGn8RiS8roNZznNgs2STpdATlm0HN
7BLMIj9xAcAaKvtIrMLB
=zNn8
-----END PGP SIGNATURE-----

--UDxUMHisQuf9eQlAlNgj2qiPeIBBHDl74--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
