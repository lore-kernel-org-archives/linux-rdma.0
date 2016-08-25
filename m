From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Question on RDMA atomic operations
Date: Thu, 25 Aug 2016 07:11:36 +0000
Message-ID: <E7A19716-E97F-4BC3-9865-3740F7847AF7@mellanox.com>
References: <DB0C5879-C46D-47BF-98F8-DECE15CC4D08@umich.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DB0C5879-C46D-47BF-98F8-DECE15CC4D08-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dong Young Yoon <dyoon-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Aug 24, 2016, at 11:43 PM, Dong Young Yoon <dyoon-63aXycvo3TyHXe+LvDLADg@public.gmane.org> wrote:
>=20
> Hi,
>=20
> My name is Dong Young and I am a PhD student at the University of Michiga=
n.
> Recently, we have been working on a research topic related to RDMA and ha=
d an observation where there is a race condition between RDMA atomic operat=
ions (e.g., fetch-and-add) and RDMA 1-sided writes.
> We would like to verity whether what we observed is actually true (i.e., =
no atomicity guaranteed between RDMA atomic operation and RDMA read/write).
Hi Dong,

If you post an atomic operation followed by RDMA read/write, you need a fen=
ce between the two, because the second one might start processing before th=
e first one has completed processing.=20

In order to do that, you need to set the IBV_SEND_FENCE in the send_flags o=
f the wr.

> Is it really true? I have also contacted other fellow researchers who wor=
ked on RDMA, but they do not seem to be 100% sure on this matter.
> Thank you so much in advance for your help.
>=20
> Thanks,
> Dong Young--
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
