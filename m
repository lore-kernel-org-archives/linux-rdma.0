From: yogeshwar sonawane <yogyas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: data placement in-order guarantee ?
Date: Fri, 12 Feb 2010 13:18:24 +0530
Message-ID: <b681c62b1002112348s3e77cb43w812d0cb0bc9b0fa2@mail.gmail.com>
References: <b681c62b1002020714s70c24fa7l4fcbf05617986b47@mail.gmail.com>
	 <F1D9D0AC-1AB3-43F6-B04F-A7AD126ED543@Sun.com>
	 <bb7677341002091008n33cfc01au5d4ec4197eac92bf@mail.gmail.com>
	 <0E2907DC-7E0C-4F8E-B548-C7CD08428506@Sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0E2907DC-7E0C-4F8E-B548-C7CD08428506-U0mLk4xYmo8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-xsfywfwIY+M@public.gmane.org>
Cc: =?UTF-8?B?4KSF4KSo4KWB4KSc?= <anuj01-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

thanks to all for adding information.

In continuation, If i am transferring only a single byte using RDMA
write, then can i poll on this byte arrival on receiving side ?
Atleast, can one be sure in single byte case ?

Thanks and Regards,
Yogeshwar

2010/2/10 H=C3=A5kon Bugge <Haakon.Bugge-xsfywfwIY+M@public.gmane.org>:
>
> On Feb 9, 2010, at 19:08 , =E0=A4=85=E0=A4=A8=E0=A5=81=E0=A4=9C wrote=
:
>
> On Tue, Feb 2, 2010 at 9:35 PM, H=C3=A5kon Bugge <Haakon.Bugge-zdmlq+PNF00@public.gmane.org=
m> wrote:
>>
>> [snip]
>> Now, most MPI implementation does not obey this; IIRC MVAPICH does r=
ely on
>> the last byte (word?) being written after all other payload,
>
> But MVAPICH assumes last byte is written in last. What if that is not=
 the
> case?
>
> I would assume you in that case copy incorrect data from your IB rece=
ive
> buffer to your application receive buffer (assuming a one-copy receiv=
e).
> This can happen with a less conservative IB implementation and/or wea=
k
> ordering of I/O transactions.
>
>
>>
>> Scali MPI relies on 4-byte write atomicy and uses a special
>> encoding/decoding which sustains any reordering of the payload (as l=
ong as
>> each 4-byte word is written as an atomic unit). The benefit, besides
>> robustness, is the capability of a worm-hole message consumption (th=
e
>> message can be decoded and copied into the MPI user buffer _before_ =
it has
>> been fully received). This method is currently a patent application,=
 so I do
>> not recommend you to copy-cat this method.
>
> Can u provide a link for this method? Atleast I can go through some d=
etails
> of this technique.
>
> Go to=C2=A0http://portal.uspto.gov/external/portal/pair, have a look =
at
> application=C2=A011/256752 and=C2=A011/437902. As stated above, you s=
hould understand
> that these techniques are protected by patent legislation.
>
>
> H=C3=A5kon
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
