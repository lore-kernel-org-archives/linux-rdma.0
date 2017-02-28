From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: v4.11 mlx5 regression
Date: Tue, 28 Feb 2017 20:00:44 +0000
Message-ID: <1488312028.2370.12.camel@sandisk.com>
References: <alpine.LFD.2.20.1702272047120.2997@schleppi.fritz.box>
         <1488233058.2597.1.camel@sandisk.com>
         <alpine.LFD.2.20.1702280950380.2045@schleppi.fritz.box>
         <1488300599.2370.5.camel@sandisk.com>
         <VI1PR0502MB30082C037BEE60367954ED0FD1560@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB30082C037BEE60367954ED0FD1560-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Content-ID: <BDCD15B605BE6B4BB7D9692909978BE0-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-02-28 at 19:53 +0000, Parav Pandit wrote:
> I am using Linux-block tree testing on x86_64.
> git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
>=20
> Commit ac1820fb286b552b6885d40ab34f1e59b815f1f1 introduced dma_ops relate=
d change that you made.
> With this change I am hitting below error in mlx5_ib driver.
> "DMAR: Allocating domain for mlx5_0 failed"
>=20
> I revert back to commit edccb59429657b09806146339e2b27594c1d1da0.
> With revert I do not hit the error.
>=20
> I do not have cycles to debug/fix this currently. Do you think this might=
 be related to your change?

Hello Parav,

Since I do not have access to an mlx5 setup I hope that you realize that
without a bisect your report is useless to me.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
