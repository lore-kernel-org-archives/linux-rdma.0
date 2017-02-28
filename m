From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: v4.11 mlx5 regression
Date: Tue, 28 Feb 2017 15:44:26 -0500 (EST)
Message-ID: <2010225383.40243457.1488314666020.JavaMail.zimbra@redhat.com>
References: <alpine.LFD.2.20.1702272047120.2997@schleppi.fritz.box> <1488233058.2597.1.camel@sandisk.com> <alpine.LFD.2.20.1702280950380.2045@schleppi.fritz.box> <1488300599.2370.5.camel@sandisk.com> <VI1PR0502MB30082C037BEE60367954ED0FD1560@VI1PR0502MB3008.eurprd05.prod.outlook.com> <1488312028.2370.12.camel@sandisk.com> <742435998.40235677.1488312819300.JavaMail.zimbra@redhat.com> <VI1PR0502MB30087B8BB5E6733E92E96D62D1560@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB30087B8BB5E6733E92E96D62D1560-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Parav Pandit" <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Sent: Tuesday, February 28, 2017 3:34:58 PM
> Subject: RE: v4.11 mlx5 regression
> 
> Hi Bart, Laurence,
> 
> In middle of debugging/using setup right now for other issue.
> I am basically using nvme-rdma target mode code and somewhere in path of MR
> or QP setup it fails.
> I am suspecting MR because QP1 creation has passed.
> I will get to the bottom of this to provide traces tomorrow.
> 
> Parav
> 
> 
> > -----Original Message-----
> > From: Laurence Oberman [mailto:loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> > Sent: Tuesday, February 28, 2017 2:14 PM
> > To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> > dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > Subject: Re: v4.11 mlx5 regression
> > 
> > 
> > 
> > ----- Original Message -----
> > > From: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > > To: parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
> > > Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > > Sent: Tuesday, February 28, 2017 3:00:44 PM
> > > Subject: Re: v4.11 mlx5 regression
> > >
> > > On Tue, 2017-02-28 at 19:53 +0000, Parav Pandit wrote:
> > > > I am using Linux-block tree testing on x86_64.
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
> > > >
> > > > Commit ac1820fb286b552b6885d40ab34f1e59b815f1f1 introduced
> > dma_ops
> > > > related change that you made.
> > > > With this change I am hitting below error in mlx5_ib driver.
> > > > "DMAR: Allocating domain for mlx5_0 failed"
> > > >
> > > > I revert back to commit edccb59429657b09806146339e2b27594c1d1da0.
> > > > With revert I do not hit the error.
> > > >
> > > > I do not have cycles to debug/fix this currently. Do you think this
> > > > might be related to your change?
> > >
> > > Hello Parav,
> > >
> > > Since I do not have access to an mlx5 setup I hope that you realize
> > > that without a bisect your report is useless to me.
> > >
> > > Bart.--
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > > in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More
> > majordomo
> > > info at  http://vger.kernel.org/majordomo-info.html
> > >
> > 
> > Hello Parav,
> > 
> > I had tested all of Barts recent commits with mlx5.
> > Read/write direct/buffered small and large I/O.
> > They all passed for me.
> > 
> > If you give me a little more detail on your test I will see what I find in
> > my test
> > bed here.
> > 
> > Regards
> > Laurence
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{��ٚ�{ay�ʇڙ�,j��f���h���z��w������j:+v���w�j�m��������zZ+��ݢj"��

OK, just FYI, all my testing was IB/SRP using EDR-100 mlx5 RDMA, I dont have NVME targets.
Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
