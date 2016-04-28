From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 10/12] IB/srpt: convert to the generic RDMA READ/WRITE API
Date: Thu, 28 Apr 2016 17:02:37 -0400
Message-ID: <57227A6D.4000802@redhat.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <1460410360-13104-11-git-send-email-hch@lst.de>
 <570E96B5.5030002@sandisk.com> <20160414133255.GA22523@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bF2BsIgwa92SVdOwOWfFULfIIm2anqIA9"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160414133255.GA22523@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: swise@opengridcomputing.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bF2BsIgwa92SVdOwOWfFULfIIm2anqIA9
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/14/2016 09:32 AM, Christoph Hellwig wrote:
> On Wed, Apr 13, 2016 at 11:57:57AM -0700, Bart Van Assche wrote:
>> On 04/11/2016 02:32 PM, Christoph Hellwig wrote:
>>>   static int srpt_get_desc_tbl(struct srpt_send_ioctx *ioctx,
>>> -			     struct srp_cmd *srp_cmd,
>>> -			     enum dma_data_direction *dir, u64 *data_len)
>>> +		struct srp_cmd *srp_cmd, enum dma_data_direction *dir,
>>> +		struct scatterlist **sg, unsigned *sg_cnt, u64 *data_len)
>>>   {
>> [ ... ]
>>>
>>> -		db =3D idb->desc_list;
>>> -		memcpy(ioctx->rbufs, db, ioctx->n_rbuf * sizeof(*db));
>>>   		*data_len =3D be32_to_cpu(idb->len);
>>> +		return srpt_alloc_rw_ctxs(ioctx, idb->desc_list, nbufs,
>>> +				sg, sg_cnt);
>>> +	} else {
>>> +		*data_len =3D 0;
>>> +		return 0;
>>>   	}
>>> -out:
>>> -	return ret;
>>>   }
>>
>> srpt_get_desc_tbl() only has one caller. Have you considered to move=20
>> srpt_alloc_rw_ctxs() from this function to the caller of=20
>> srpt_get_desc_tbl()?
>=20
> I looked into a couple options.  srpt_alloc_rw_ctxs needs the
> pointer to the srp_direct_buf array, and the number of buffers, so we'd=

> need two more output arguments to srpt_get_desc_tbl, so it didn't
> seem worthwhile to me.  If you want me to make the change anyway, I can=

> update the patch.
>=20

Hi Christoph,

I see you responded to Bart's comment above, but in the same email he
had a second comment on this patch (that the logic was incorrect in part
of it), and I've not seen a response to that.  Here's the comment I'm
referring to:

>> -    if (srpt_get_desc_tbl(send_ioctx, srp_cmd, &dir, &data_len)) {
>> -        pr_err("0x%llx: parsing SRP descriptor table failed.\n",
>> -               srp_cmd->tag);
>> +    rc =3D srpt_get_desc_tbl(send_ioctx, srp_cmd, &dir, &sg, &sg_cnt,=

>> +            &data_len);
>> +    if (rc) {
>> +        if (rc !=3D -EAGAIN) {
>> +            pr_err("0x%llx: parsing SRP descriptor table failed.\n",
>> +                   srp_cmd->tag);
>> +        } else {
>> +            printk_ratelimited("out of MRs for 0x%llx\n", srp_cmd->ta=
g);
>> +        }
>>           goto release_ioctx;
>>       }
>=20
> Sorry but releasing an I/O context if srpt_alloc_rw_ctxs() returns
> -EAGAIN looks wrong to me. If this happens the I/O context should be
> added to the wait list without releasing it. Additionally,
> srpt_recv_done() will have to be modified such that newly received
> commands are added to the wait list if this list is not empty to
> prevent that starvation of a postponed request occurs due to new
> incoming requests.



--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--bF2BsIgwa92SVdOwOWfFULfIIm2anqIA9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXInptAAoJELgmozMOVy/dcAEP/3RIus5fk8GVIzLtl1o18QzJ
NmmK02vow8a8RW8iijd1exnYeoUYx4Nw+9TBCkEgoS6+vYT/uTZjKHmr2VpuRb1k
rwtgFnTk0A6KhcuTJhvgCwtTNJI9+y32jVibR8yTmwwwek+1Tr5kNhLqR+YtfuWh
j6zKttww6I2EnrLe3zcfL6rwifFxbCjuqWgl21J3a+giXtUHyp9bWeGTdJvInoCt
bHiCOBIdWLMCr2wn7PIbvvMPvq/iXHTYvhuW9yQ9xGWgmp+GhiY+UB+6q9OIPP3Q
p9GOx5CMD8NqQfy7bKnerFDGPZzMDXjLzspJs4/Fg0+pAxHEdnhMi55NbVxNX09F
URd1fK6A0bxnph4+GEgK6SLHbegzhLgWKtvnVWsSkDozkWo3mtJSB2F/1+F5FSsG
x/45O/nt8U7Qu8BBMGjP/Rr0NmyyaRTIJFge87GY1jydnU8TcZA+l5wNHgmg9YST
RIPFxP8t6CWlQetn2c0vIkfiUC7fyRnFOwLaoGU6ZJsC7korg9m26uzURG1lPiyC
c+5Uhgb2IUqQT+TJnUcXpB56BUjfQq3j/cmQc3rDbGumIaWVtbeE/JgK4UAUiH+F
9kqRyh9VHZXRku7Nqqadtq0EQkaHhrkhIpTkLAA0IDd6GGpZvNCtWP5DWyr5pvz/
riHjKZ5+aal8GAQrquyN
=V27K
-----END PGP SIGNATURE-----

--bF2BsIgwa92SVdOwOWfFULfIIm2anqIA9--
