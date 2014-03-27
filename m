From: Reiter Rafael <rafael.reiter-cv18SyjCLaheoWH0uzbU5w@public.gmane.org>
Subject: Re: Kernel oops/panic with NFS over RDMA mount after disrupted Infiniband
 connection
Date: Thu, 27 Mar 2014 08:53:50 +0100
Message-ID: <lh0le0$u5$1@ger.gmane.org>
References: <5332D425.3030803@ims.co.at> <4E6350BB-5E9C-40D9-8624-6CAA78E5B902@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E6350BB-5E9C-40D9-8624-6CAA78E5B902-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 03/26/2014 07:15 PM, Chuck Lever wrote:
>=20
> Hi Rafael-
>=20
> I=92ll take a look. Can you report your HCA and how you reproduce thi=
s issue?

The HCA is Mellanox Technologies MT26428.

Reproduction:
1) Mount a directory via NFS/RDMA
mount -t nfs -o port=3D20049,rdma,vers=3D4.0,timeo=3D900 172.16.100.2:/=
 /mnt/
2) Pull the Infiniband cable or use ibportstate to disrupt the Infiniba=
nd connection
3) ls /mnt
4) wait 5-30 seconds

>=20
> Do you (or does anyone) know whether OpenSuSE uses the stock upstream=
 providers, or has any of OFED been applied to this kernel?

My first post was misleading -- I use the vanilla 3.10.17 kernel, and t=
he error occurs with and without Mellanox OFED. The above report
references the vanilla kernel.

Rafael

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
