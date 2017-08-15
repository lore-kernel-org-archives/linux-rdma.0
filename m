From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH v2 0/2] Don't allocate ib/iw cm workqueues with
 WQ_MEM_RECLAIM
Date: Tue, 15 Aug 2017 20:56:48 +0000
Message-ID: <VI1PR0502MB3008A36C6EFD5C22ECD8DFADD18D0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <1502824838-21745-1-git-send-email-sagi@grimberg.me>
 <VI1PR0502MB300859CC289623BEA5D2DF9AD18D0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB300859CC289623BEA5D2DF9AD18D0-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Never mind. I read the other thread.

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Parav Pandit
> Sent: Tuesday, August 15, 2017 3:53 PM
> To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>; Doug Ledford
> <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Subject: RE: [PATCH v2 0/2] Don't allocate ib/iw cm workqueues with
> WQ_MEM_RECLAIM
>=20
> Hi Sagi,
>=20
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Sagi Grimberg
> > Sent: Tuesday, August 15, 2017 2:21 PM
> > To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > Subject: [PATCH v2 0/2] Don't allocate ib/iw cm workqueues with
> > WQ_MEM_RECLAIM
> >
> > It's not correct due to the fact that such workqueues cannot allocate
> > memory in their work execution by definition, which is definitly not
> > the case for cm
> Are you saying a work executed on a WQ which is created with
> WQ_MEM_RECLAIM, cannot allocate memory?
> Did I misread 'such workqueues cannot allocate memory'?
>=20
> > workqueues.
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in =
the body
> of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> https://emea01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fvger.=
ke
> rnel.org%2Fmajordomo-
> info.html&data=3D02%7C01%7Cparav%40mellanox.com%7C93927b0ff2eb41195a
> 2208d4e41fa791%7Ca652971c7d2e4d9ba6a4d149256f461b%7C0%7C0%7C636
> 384272020352896&sdata=3D%2FgoMTFzzT1h9rc2WE04mHfU9RRiO415k3eylvl6M
> OfI%3D&reserved=3D0
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
