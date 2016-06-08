From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/29] Soft RoCE driver
Date: Wed, 8 Jun 2016 08:20:55 -0400
Message-ID: <5e1bd9ce-f802-9237-14a0-7cdc2be5089b@redhat.com>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com>
 <20160603052539.GB31196@infradead.org>
 <CAG9sBKN9HQKhRgXWZ8JJwwUdEBaP9VnGwr790C=q4w0XDxkbtw@mail.gmail.com>
 <1465379530.5365.91.camel@haakon3.risingtidesystems.com>
 <20160608104123.GJ3663@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iJ9In4NvEaXfEHbbn94Ov5wdefweAkJIm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160608104123.GJ3663-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linrdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iJ9In4NvEaXfEHbbn94Ov5wdefweAkJIm
Content-Type: multipart/mixed; boundary="wBqAMeGpSmVQ5T1l29iTtt8qJO1GlsAPL"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
 linrdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Message-ID: <5e1bd9ce-f802-9237-14a0-7cdc2be5089b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/29] Soft RoCE driver
References: <1464886657-14258-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 <20160603052539.GB31196-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
 <CAG9sBKN9HQKhRgXWZ8JJwwUdEBaP9VnGwr790C=q4w0XDxkbtw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <1465379530.5365.91.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
 <20160608104123.GJ3663-2ukJVAZIZ/Y@public.gmane.org>
In-Reply-To: <20160608104123.GJ3663-2ukJVAZIZ/Y@public.gmane.org>

--wBqAMeGpSmVQ5T1l29iTtt8qJO1GlsAPL
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 6/8/2016 6:41 AM, Leon Romanovsky wrote:
> On Wed, Jun 08, 2016 at 02:52:10AM -0700, Nicholas A. Bellinger wrote:
>> Hey Moni & HCH, Co.
>>
>> (Adding Sagi CC')
>>
>> On Wed, 2016-06-08 at 11:49 +0300, Moni Shoua wrote:
>>> On Fri, Jun 3, 2016 at 8:25 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>=
 wrote:
>>>> Do you have a changelog compred to the last version?
>>>>
>>>
>>> - Moved from drivers/staging/rdma/rxe to drivers/infiniband/hw/rxe
>>> - Rebase to newer kernel (was 4.4-rc6)
>>> - Removed support in phys. MR
>>> - Removed memory window codes (buggy)
>>> - Mind  IS_ENABLED(CONFIG_IPV6)
>>> - Dispatch IB event on port UP/DOWN
>>> - Validate ICRC in receive
>>> - Validate dgid in receive
>>> - Scatter IPv4 header to right place for UD QP
>>> - Other bug fixes
>>> - Copyright dates were updated in file headers
>>>
>>>
>>>> How well do FRWRs work, does this include Sagi's work in that area?
>>> FRWR is not supported yet
>>>> How well does posting of fenced WRs work?
>>> We ran successfully some simple tests with IBV_SEND_FENCE
>>>
>>
>> Great.
>>
>> A Soft-RoCE environment against v4.7-rc2 for iser and early nvme-fabri=
cs
>> code would be extremely useful.  :-)
>>
>> Can we get this code into 0-day build ASAP..?
>=20
> Hi Nicholas,
>=20
> Per your request, I added Soft-RoCE code to my tree for testing (kbuild=

> and linux-next tests). Please be aware that official RDMA tree is Doug'=
s
> tree and only appearance in his tree will be sign for acceptance.
>=20
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Dtopic/rxe
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Dtesting/rdma-next

I have a branch in my tree with this code in it already.  This isn't a
statement of inclusion, as I still have to finish the review, but it's
on the rxe branch and I haven't seen any 0-day failure so far (it won't
undergo linux-next until it officially hits my next branch).



--wBqAMeGpSmVQ5T1l29iTtt8qJO1GlsAPL--

--iJ9In4NvEaXfEHbbn94Ov5wdefweAkJIm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXWA2nAAoJELgmozMOVy/d8UEQAKoedhp7CqYassbXoFz2GQ+X
8D+FE/gdJx+ALl+ZwuLbfWUmnMHq9M0vGCuMe1R2KB4nsQymaX+hTRpgcYtLBUoF
B/lN+7cd8z7U3959T9QvWCVYBX8xcF4nZHaZMrfVg30C858WkJkO2vho7jiihGy4
VTpLefC2tETIAa7viF4a/qAgEeJ6IPZLxUn/JmFbqJpLf9EgHN8EYGTV1mMwYsua
WBfKwTjimOzd8jBIpLAHSpQt69rD/QdqcgoHDqgq1h5OadLt8sRO2K4xdRjb1yKi
W8/+z+XatYky+nn7aNQgKSe+C6ro35qli0ph/Drx7XydAYgeeMVR9ePcq194JF++
1Q1qlNS3WvRzOcxGo6unatIWvGHrqXTMI3zsPuFyh+DKsGajVHWv7B1vz945LjYG
zgZFJ8Bl7r8a88WVxnGb4uyTUKnRC+3Sh2Ek88K7jVHTp59hUUpDEzRs4A90ClTP
73k8eiY/PHshACb3z9vWVhTSpDI5AWGo9nFn62lAkxEP5OCxHJuQM5JWj6CQqBLI
o1o2mq7XMCgyhGcg1DT3HF482bwigaSqNUVzYLW1HqQcXzSw+fWfc94wPFuKt/xW
fQdtdGdd6nEWLFh/vJgN93zYCqhhxk0t1ryj3u/Fz4XGTinrhDuDbIPySBZCo2ZH
+dGQUstLyOON9Pr8oB3z
=2JoZ
-----END PGP SIGNATURE-----

--iJ9In4NvEaXfEHbbn94Ov5wdefweAkJIm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
