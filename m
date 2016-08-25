From: Asgeir Eiriksson <asgeir.eiriksson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Question on RDMA atomic operations
Date: Thu, 25 Aug 2016 14:11:13 -0700
Message-ID: <F998C7B6-4095-43A6-A717-350C097E3125@gmail.com>
References: <DB0C5879-C46D-47BF-98F8-DECE15CC4D08@umich.edu> <E7A19716-E97F-4BC3-9865-3740F7847AF7@mellanox.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E7A19716-E97F-4BC3-9865-3740F7847AF7-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dong Young Yoon <dyoon-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Cc: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Dong,

The ordering rules for iWARP RDMA are spelled out in RFC7306 (see =
https://tools.ietf.org/pdf/rfc7306.pdf section 5, pp. 24 for the two =
ordering cases you asked about) and RFC5040 has the rest of the iWARP =
RDMA ordering rules

The answer to your question is the same for iWARP RDMA as that provided =
by Majd for IB

Regards,

=E2=80=98Asgeir


> On Aug 25, 2016, at 12:11 AM, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>=20
>=20
>> On Aug 24, 2016, at 11:43 PM, Dong Young Yoon <dyoon-63aXycvo3TyHXe+LvDLADg@public.gmane.org> =
wrote:
>>=20
>> Hi,
>>=20
>> My name is Dong Young and I am a PhD student at the University of =
Michigan.
>> Recently, we have been working on a research topic related to RDMA =
and had an observation where there is a race condition between RDMA =
atomic operations (e.g., fetch-and-add) and RDMA 1-sided writes.
>> We would like to verity whether what we observed is actually true =
(i.e., no atomicity guaranteed between RDMA atomic operation and RDMA =
read/write).
> Hi Dong,
>=20
> If you post an atomic operation followed by RDMA read/write, you need =
a fence between the two, because the second one might start processing =
before the first one has completed processing.=20
>=20
> In order to do that, you need to set the IBV_SEND_FENCE in the =
send_flags of the wr.
>=20
>> Is it really true? I have also contacted other fellow researchers who =
worked on RDMA, but they do not seem to be 100% sure on this matter.
>> Thank you so much in advance for your help.
>>=20
>> Thanks,
>> Dong Young--
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
