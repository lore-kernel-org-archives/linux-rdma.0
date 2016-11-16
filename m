From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: Configuration of cq->cqe is lower than entries by 1
Date: Wed, 16 Nov 2016 10:05:47 +0000
Message-ID: <SN1PR07MB22078320A469D607CA0734B8F8BE0@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <SN1PR07MB22076C5DE03F1939603C554CF8BC0@SN1PR07MB2207.namprd07.prod.outlook.com>
 <20161114120153.GC4240@leon.nu>,<SN1PR07MB22071D220A9067F58E1F09DAF8BC0@SN1PR07MB2207.namprd07.prod.outlook.com>
 <2DF5C492-C364-4353-8FA9-51FA5EE760F0@mellanox.com>,<SN1PR07MB22072081213EA656CC611E40F8BE0@SN1PR07MB2207.namprd07.prod.outlook.com>
 <84A08B2A-85D5-467C-AE80-63134CA07767@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <84A08B2A-85D5-467C-AE80-63134CA07767-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > Correct. We create it with 64(the result of the roundup) and let him wor=
k with
> 63 only.

ACK
=20

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
