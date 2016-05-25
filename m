From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Fwd: Re: [PATCH v8 07/22] IB/hns: Add event queue support
Date: Wed, 25 May 2016 16:34:33 -0400
Message-ID: <cafab3f2-e033-398c-563e-7f4ffcca1a61@redhat.com>
References: <df14eb59-6005-4412-8e85-d613b104ab96@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kx6i0S2UDqqpAK1DKabdQuUJLIS9bUrUa"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <df14eb59-6005-4412-8e85-d613b104ab96-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kx6i0S2UDqqpAK1DKabdQuUJLIS9bUrUa
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable




-------- Forwarded Message --------
Subject: Re: [PATCH v8 07/22] IB/hns: Add event queue support
Date: Wed, 25 May 2016 15:22:05 -0400
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Organization: Red Hat, Inc.
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On 05/25/2016 11:05 AM, Lijun Ou wrote:
> This patch added event queue support for RoCE driver. It is used
> for RoCE interrupt. RoCE includes 32 synchronous event irqs, 1
> asynchronous event irq and 1 common overflow irq.

> +#define roce_writel(value, addr)     writel((value), (addr))
> +#define roce_readl(addr)            readl((addr))

These two defines are useless.  They just make the code width longer for
no real purpose.  Here's an example from my last email

>> +				((u64)le32_to_cpu(roce_readl(hr_dev->reg_base +
>> +					     ROCEE_SYS_IMAGE_GUID_H_REG)) <<
>> +					     ADDR_SHIFT_32);

If you are going to do a #define for this, at least let the #define do
some work for you.  Something like:

#define hns_readl(dev, reg) readl((dev)->reg_base + (reg))

then the above can read more like this

>> +				((u64)le32_to_cpu(hns_readl(hr_dev,=20
>> +					     ROCEE_SYS_IMAGE_GUID_H_REG)) <<
>> +					     ADDR_SHIFT_32);

You could do additional tricks to make the overall length of lines
shorter while loosing none of the readability if you altered your
register names a little.  And if all of your ROCEE registers have a
common prefix or postfix, you can embedd that in the #define to keep the
register names shorter in your file.  For instance, they appear to all
start with ROCEE and end with REG, so maybe something like this:

#define hns_readl(dev, reg) readl((dev->)reg_base + ROCEE_##reg##_REG)

so that the above starts to look like this:

>> +				((u64)le32_to_cpu(hns_readl(hr_dev,
>> +					     SYS_IMAGE_GUID_H)) << 32);

which is much more readable in my opinion.



> +/* Address shift 12bit with the special hardware address operation of =
RoCEE */
> +#define ADDR_SHIFT_12				12
> +

And this is the one that should talk about the register that requires
the address be shifted as though using a 4K page size even when you aren'=
t.

>  /* Address shift 32bit with the special hardware address operation of =
RoCEE */
>  #define ADDR_SHIFT_32				32

I really don't know when you actually need a define for a 32 bit shift...=
=2E

> +/* Address shift 44bit with the special hardware address operation of =
RoCEE */
> +#define ADDR_SHIFT_44				44

This one, just like the 12 shift, needs an explanation of some sort.



--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD




--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--kx6i0S2UDqqpAK1DKabdQuUJLIS9bUrUa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXRgxZAAoJELgmozMOVy/dJw8P/RQqc0Hszz24cMRC+++y17cg
mSjIKi3qGTNC+b8Wr6AZMRSDXn+78qM0fXF7ZpLLwU9RZgR3KeTJjYTn3tQgZSe1
kRgGgTb+/4ZflqHNjwf5Kt5TF+ANy7ORgm9pV9OT9UDmeXrhFxq/8TIgheCDcHf+
f9oxBua31GNl6g4sG/l69GVy8WYRsM/HXetkkgXHgmNnUe0FZuvtU6wazexXS0nV
zaVkvfUgI2kkhOB6vK5aSndNbv7DC5DfbckFcFUv2AQ5gVKIyYW0kQEV2xrTzr42
mKXqDkWYI99CRDafcPwDjvKDDWjcCPiuBvh67FZ1ssFPfsUkOJwanNgO6tn+Kclr
YjVwaFF9tpcb9chHfzxQDsOCkJw7gXlYOuZ8XUDTqRSPmXC1RuduIkv1jJf4qAPx
HgeXVUiRUp9MUGD06ve9EGcz6Kl8LP3uCX9F56z5hZRVNMQ4rmLuaEU2+jRikhlG
IiGlkOcm2fmJqZQ1rb9GOY29GZY84B+XVwfx1bWKPuTSrppldphncSC7klTfVBY3
hdwqaQC+4tdRoKONoh1VhFlzgVTLdmBwGX+ew+lV3B8n4uTdOADGpwGjyAtHY0vn
L0Smw30w0ADIbsJWRFI5iZ0J+rktJpOIfAjyHkbxsN8w5MDsiVL72HLxgGYagfo/
HXoNgO3+PPvl+aPQuc0u
=dMKK
-----END PGP SIGNATURE-----

--kx6i0S2UDqqpAK1DKabdQuUJLIS9bUrUa--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
