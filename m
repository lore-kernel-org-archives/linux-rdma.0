From: Amir Vadai <amirv.mellanox-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IB SR-IOV
Date: Mon, 12 Aug 2013 18:28:46 +0300
Message-ID: <5208FF2E.7070108@gmail.com>
References: <CAKY8vKrJ=BDOKd5hnZjiS7XO_u-Sz+PsOuymaDxJbHBP2RCEEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKY8vKrJ=BDOKd5hnZjiS7XO_u-Sz+PsOuymaDxJbHBP2RCEEQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ernst Gunnar Gran <ernstgr-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/08/2013 10:01, Ernst Gunnar Gran wrote:
> Hi
>=20
> I=92m about to start experimenting with SR-IOV and IB (ConnectX-2 G2,=
 HP
> DL360p Gen8, E5-2609). Is it OK to just download the latest OFED
> release and start playing, or are there any known issues that I shoul=
d
> know of when it comes to SR-IOV with the current release?
>=20
> Thanks,
> Ernst Gunnar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

Adding Or Gerlitz who is mlx4_ib maintainer.

Make sure to update the FW to latest FW for your HW from mellanox.com
Upstream kernel has support in SR-IOV and IB, so you can work with it.
If using MLNX_OFED, can look at the release notes.

Amir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
