From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3 12/26] xprtrdma: Port to new memory registration API
Date: Sat, 10 Oct 2015 04:06:29 +0300
Message-ID: <56186495.6060309@dev.mellanox.co.il>
References: <1444290669-5252-1-git-send-email-sagig@mellanox.com>
 <1444290669-5252-13-git-send-email-sagig@mellanox.com>
 <87F3CC02-2979-4C6B-990A-C31C52790ABC@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87F3CC02-2979-4C6B-990A-C31C52790ABC-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> out_list_err:
>> -	rc =3D PTR_ERR(f->fr_pgl);
>> +	rc =3D -ENOMEM;
>> 	dprintk("RPC:       %s: ib_alloc_fast_reg_page_list status %i\n=E2=80=
=9D,
>
> Should you update this debugging message?

Yes I will.

>> +	n =3D ib_map_mr_sg(mr, frmr->sg, frmr->sg_nents, PAGE_SIZE);
>> +	if (unlikely(n !=3D frmr->sg_nents)) {
>
> The basic logic looks OK. But signed v. unsigned comparison here?
> Is there a guarantee that the maximum value sg_nents can have is
> INT_MAX?
>
> i and n are signed, sg_nents is unsigned. I=E2=80=99d prefer to have
> the variable signage all agree. Since we=E2=80=99re counting stuff,
> maybe unsigned all around is a better choice? (rc should
> remain signed).

OK, I'll make i, n, len unsigned integers.

>
> If ib_map_mr_sg can return a negative value, maybe =E2=80=9Crc =3D ib=
_map_mr_sg=E2=80=9D
> is more clear. Is n used anywhere else?

Nop.

>
> Use %u formatter for displaying unsigned variables.
>
>
>> +		pr_err("RPC:       %s: failed to map mr %p (%d/%d)\n",
>> +		       __func__, frmr->fr_mr, n, frmr->sg_nents);
>> +		rc =3D n < 0 ? n : -EINVAL;
>> +		goto out_senderr;
>
> Is frmr->sg_nents set correctly here for the ib_dma_unmap_sg()
> call in the error exit? Maybe you want to use the value in
> =E2=80=9Cn=E2=80=9D instead (as long as it=E2=80=99s positive, of cou=
rse).

Umm, I think that frmr->sg_nents is assigned before the unmap is even
reachable (we assign before mapping because we won't take partial
maapings at least for now).



I'll be waiting for more comments before posting v4.

Cheers,
Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
